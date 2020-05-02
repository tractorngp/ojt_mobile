import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ojt_app/style/style.dart';
import 'package:incrementally_loading_listview/incrementally_loading_listview.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:ojt_app/components/all_ojts_card.dart';
import 'package:ojt_app/models/ojt_model.dart';
import 'package:ojt_app/components/bottom_navigation_bar.dart';
import 'package:ojt_app/pages/take_ojt.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ojt_app/models/user_model.dart';
import 'dart:convert';
import 'package:ojt_app/services/services.dart';

class UserHomePage extends StatefulWidget {
  final String loginType;
  UserHomePage(this.loginType);
  @override
  State<StatefulWidget> createState() {
    return new UserHomePageState(this.loginType);
  } 
}


class UserHomePageState extends State<UserHomePage> with SingleTickerProviderStateMixin
{
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  Size screenSize;
  String loginType;
  UserModel user;
  ScrollController scrollController = new ScrollController();
  BuildContext _loadingContext;
  TabController _tabController;
  int _currentIndex = 0;
  int tabIndex = 0;
  var filteredAllOJTs = <OJTsCardModel>[];
  var filteredPendingOJTs = <OJTsCardModel>[];
  var filteredPendingOJTsCount = 0;
  var filteredTotalOJTsCount = 0;
  Future _initialLoad;
  var loadMoreDone;
  bool loadMore = false;
  var isDataLoading;
  bool partialLoad = false;
  var nor = 3, pageIndexGlobal = 0;
  RestDatasource api = new RestDatasource();
  dynamic _lastDocumentAll;
  dynamic _lastDocumentPending;
  String _username = "";

  @override
  initState(){
    super.initState();
    _tabController = new TabController(vsync: this, length: 2, initialIndex: _currentIndex);
    loadMoreDone = true;
    isDataLoading = false;
    initTheView();
  }

  initTheView(){
    getUser();
  }

  UserHomePageState(loginType);

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  fetchOJTsCount() async{
    showLoader();
    api.fetchOJTsCount(user.tokenId).then((dynamic result){
      setState(() {
        filteredPendingOJTsCount = (result.data != null && result.data['pending'] != null) ? result.data['pending'] : 0;
        filteredTotalOJTsCount = (result.data != null && result.data['total'] != null) ? result.data['total'] : 0;
      });
      dismissLoader();
      getData();
    }, onError: (err){
      print("Error");
      dismissLoader();
    });
  }

  fetchOJTsData() async{
    var ojts = [];
    var all_ojts = <OJTsCardModel>[];
    if(_lastDocumentAll != null){
      api.fetchOJTsData(user.tokenId, _lastDocumentAll, null).then((data){
          _lastDocumentAll = data.documents.last;
          ojts = data.documents.toList();
          for(var i=0;i<ojts.length;i++){
            all_ojts.add(OJTsCardModel.map(ojts[i].data));
          }
          setState(() {
            loadMoreDone = true;
            if(loadMore == true){
                filteredAllOJTs = filteredAllOJTs + all_ojts;
                loadMore = false;
            }
            else{
              filteredAllOJTs = all_ojts;
            }
          });
      }, onError: (err){
          print(err);
          _showSnackBar("Error fetching data");
      });
    }
    else{
      api.fetchOJTsData(user.tokenId, _lastDocumentAll, null).then((data){
          _lastDocumentAll = data.documents.last;
          ojts = data.documents.toList();
          for(var i=0;i<ojts.length;i++){
            all_ojts.add(OJTsCardModel.map(ojts[i].data));
          }
          setState(() {
            loadMoreDone = true;
            if(loadMore == true){
                filteredAllOJTs = filteredAllOJTs + all_ojts;
                loadMore = false;
            }
            else{
              filteredAllOJTs = all_ojts;
            }
          });
      }, onError: (err){
          print(err);
          _showSnackBar("Error fetching data");
      });
    }
  }


  fetchPendingOJTsData() async{
    var ojts = [];
    var pending_ojts = <OJTsCardModel>[];
    if(_lastDocumentPending != null){
      api.fetchOJTsData(user.tokenId, _lastDocumentPending, "assigned").then((data){
          _lastDocumentPending = data.documents.last;
          ojts = data.documents.toList();
          for(var i=0;i<ojts.length;i++){
            pending_ojts.add(OJTsCardModel.map(ojts[i].data));
          }
          setState(() {
            loadMoreDone = true;
            if(loadMore == true){
                filteredPendingOJTs = filteredPendingOJTs + pending_ojts;
                loadMore = false;
            }
            else{
              filteredPendingOJTs = pending_ojts;
            }
          });
          fetchOJTsData();
      }, onError: (err){
          print(err);
          _showSnackBar("Error fetching data");
      });
    }
    else{
      api.fetchOJTsData(user.tokenId, _lastDocumentPending, "assigned").then((data){
          _lastDocumentPending = data.documents.last;
          ojts = data.documents.toList();
          for(var i=0;i<ojts.length;i++){
            pending_ojts.add(OJTsCardModel.map(ojts[i].data));
          }
          setState(() {
            loadMoreDone = true;
            if(loadMore == true){
                filteredPendingOJTs = filteredPendingOJTs + pending_ojts;
                loadMore = false;
            }
            else{
              filteredPendingOJTs = pending_ojts;
            }
          });
          fetchOJTsData();
      }, onError: (err){
          print(err);
          _showSnackBar("Error fetching data");
      });
    }
  }

  Future<Null> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userString = prefs.getString("user");
    var val = json.decode(userString);
    setState(() {
      user = UserModel.map(val);
    });
    if(user != null){
      var name;
      if(user.name.length > 15){
        name = user.name.split(" ");
        setState(() {
          _username = name[0];
        });
      }
      else{
        _username = user.name;
      }
    }
    fetchOJTsCount();
  }

  Future<Null> getData() async{
    _initialLoad = Future.delayed(Duration(seconds: 0), () {
        pageIndexGlobal = 0;
        fetchPendingOJTsData();
    });
  }

  void _showSnackBar(String text) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  void showLoader(){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
      _loadingContext = context;
      return Center(
        child: SpinKitHourGlass(color: whiteColor)
      );
    });
  }

  void dismissLoader(){
    if(_loadingContext != null){
      Navigator.pop(_loadingContext);
    }
    _loadingContext = null;
  }

  Future _loadMoreItems() async {
    print("Load more");
    loadMore = true;
    if(loadMoreDone){
      print("Loading data");
      setState(() {
         loadMoreDone = false;     
      });
      pageIndexGlobal++;
      //Load more OJTs here
      fetchOJTsData();
    }
  }

  @override
  Widget build(BuildContext context) {

    Function hp = Screen(MediaQuery.of(context).size).hp;
    Function wp = Screen(MediaQuery.of(context).size).wp;
    screenSize = MediaQuery.of(context).size;
    
    return Scaffold(
      key: _scaffoldKey,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        backgroundColor: whiteColor,
        bottomNavigationBar: BottomNavigationBarComponent(0),
         body:  new SafeArea(
          top: true,
          bottom: false, 
          child: SingleChildScrollView(
            controller: scrollController,
            child: Container(
              height: screenSize.height,
              padding: EdgeInsets.only(left: 0.0,top: 20.0, right: 0.0),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 20.0),
                              child: new Image.asset(
                                'assets/tractor.png',
                                height: 60.0,
                                width: 60.0,
                                fit: BoxFit.contain,
                              ),
                            )
                          ]
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 30.0),
                          child: new Image.asset(
                            'assets/full_logo.png',
                            height: 50.0,
                            width: 150.0,
                            fit: BoxFit.contain,
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: screenSize.width / 1.5,
                          padding: EdgeInsets.all(5.0),
                          margin: EdgeInsets.only(left: 20.0, bottom: 10.0),
                          child: Text((widget.loginType == 'admin' ? "Admin: " : "User: ") + (user != null ? _username : ""), style: placeholderStyleBold, maxLines: 3, softWrap: true, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start)
                        )
                        
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0.0),
                      child: new Container(
                        height: screenSize.height * 0.055,
                        decoration: new BoxDecoration(border: new Border(top: BorderSide.none, right: BorderSide.none, left: BorderSide.none, bottom: BorderSide(color: darkGrey))),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new InkWell(
                              onTap: () {
                                _tabController.animateTo(0);
                                setState(() {
                                  print("Hello");
                                  tabIndex = 0;                              
                                });
                              },
                              child: new Container(
                                width: screenSize.width/2 - 35,
                                padding: EdgeInsets.only(top: 8.0, bottom: 2.0),
                                // height: MediaQuery.of(context).size.height * 0.06,
                                // margin: new EdgeInsets.only(bottom: 10.0, right: 5.0),
                                alignment: FractionalOffset.center,
                                decoration: new BoxDecoration(
                                    color: Colors.white,
                                    border: new Border(bottom: BorderSide(color: (tabIndex == 0) ? redThemeColor : Colors.transparent, width: 5.0, style: BorderStyle.solid))
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text("Pending OJTs", style: (tabIndex == 0) ? noButtonTextStyleBold : noButtonTextStyle),
                                    Container(
                                      padding: EdgeInsets.all(3.0),
                                      decoration: new BoxDecoration(
                                        color: redThemeColor,
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      constraints: BoxConstraints(
                                        minWidth: 20.0,
                                        minHeight: 20.0,
                                      ),
                                      child: new Text(
                                        '$filteredPendingOJTsCount',
                                        style: new TextStyle(
                                          color: Colors.white,
                                          fontSize: 10.0,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            new InkWell(
                              onTap: () {
                                _tabController.animateTo(1);
                                setState(() {
                                  print("Hello");
                                  tabIndex = 1;                              
                                });
                              },
                              child: Container(
                                width: screenSize.width/2 - 35,
                                padding: EdgeInsets.only(top: 8.0, bottom: 2.0),
                                // height: MediaQuery.of(context).size.height * 0.05,
                                // margin: new EdgeInsets.only(bottom: 10.0, right: 5.0),
                                alignment: FractionalOffset.center,
                                decoration: new BoxDecoration(
                                    color: Colors.white,
                                    border: new Border(bottom: BorderSide(color: (tabIndex == 1) ? redThemeColor : Colors.transparent, width: 5.0, style: BorderStyle.solid))
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text("All OJTs", style: (tabIndex == 1) ? noButtonTextStyleBold : noButtonTextStyle),
                                    Container(
                                      padding: EdgeInsets.all(3.0),
                                      decoration: new BoxDecoration(
                                        color: redThemeColor,
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      constraints: BoxConstraints(
                                        minWidth: 20.0,
                                        minHeight: 20.0,
                                      ),
                                      child: new Text(
                                        '$filteredTotalOJTsCount',
                                        style: new TextStyle(
                                          color: Colors.white,
                                          fontSize: 10.0,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            )
                          ],
                        ),
                      ),
                    ),


                    new Expanded(
                      child: 
                      new TabBarView(
                          controller: _tabController,
                          // Restrict scroll by user
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  (filteredPendingOJTs != null && filteredPendingOJTs.length >0) ? 
                                    new Column(
                                      mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                        FutureBuilder(
                                          future: _initialLoad,
                                          builder: (context, snapshot) {
                                            switch (snapshot.connectionState) {
                                              case ConnectionState.waiting:
                                              print("Show loader");
                                                return Container(
                                                height: 50.0,
                                                width: screenSize.width,
                                                padding: EdgeInsets.only(top: 0.0),
                                                child: Center(child: SpinKitHourGlass(color: darkGrey)));
                                              case ConnectionState.done:
                                              print("Loading complete");
                                              return 
                                              // AspectRatio(
                                              //   aspectRatio: !loadMoreDone ? (wp(2)/hp(1.342) + 0.05) : (screenSize.height > 600 ? (wp(2)/hp(1.303)) : (wp(2)/hp(1.265))),
                                              //   child: 
                                                Container(
                                                height: !loadMoreDone ? (screenSize.height - 100.0) : (screenSize.height - 150.0),
                                                child: IncrementallyLoadingListView(
                                                  padding: EdgeInsets.only(bottom: 170.0),
                                                hasMore: () => filteredPendingOJTsCount > filteredPendingOJTs.length,
                                                itemCount: () => filteredPendingOJTs.length,
                                                loadMore: () async {
                                                // can shorten to "loadMore: _loadMoreItems" but this syntax is used to demonstrate that
                                                // functions with parameters can also be invoked if needed
                                                await _loadMoreItems();
                                                },
                                                onLoadMore: (){
                                                  isDataLoading = true;
                                                },

                                                onLoadMoreFinished: (){
                                                  isDataLoading = false;
                                                },

                                                loadMoreOffsetFromBottom: 0,
                                                itemBuilder: (BuildContext context, int index) {
                                                  if ((isDataLoading ?? false) && (index == filteredPendingOJTs.length - 1) && (filteredPendingOJTsCount != filteredPendingOJTs.length)) {
                                                    print("Loading indicator");
                                                  return  Container(
                                                    height: 50.0,
                                                    width: screenSize.width,
                                                    padding: EdgeInsets.only(top: 0.0),
                                                    child: Center(child: SpinKitHourGlass(color: darkGrey)));
                                                  }
                                                  else{
                                                    return new GestureDetector( 
                                                        onTap: () {
                                                          print("Here I'm 2! " + index.toString());
                                                           Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                settings: RouteSettings(name: "/takeOJT"),
                                                                builder: (context) => TakeOJTsPage(title: filteredPendingOJTs[index].ojt_name, assessment: filteredPendingOJTs[index], assessmentFinish: (){
                                                                  print("OJT finished");
                                                                }),
                                                              ),
                                                            );
                                                        },
                                                        child: AllOJTsCard(filteredPendingOJTs[index]));
                                                  }
                                                    
                                                }));
                                                default:
                                                return Text('Something went wrong');
                                            }
                                          }
                                        ),
                                        
                                      ]
                                    )
                                  
                                    
                                    : Container(
                                          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                                          child: Text("No OJTs found.", style: termsStyle)
                                      )
                                  ], 
                                ),

                                Container(
                                  width: screenSize.width,
                                  // height: (visitHistoryList.length * 100).ceilToDouble(),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      (filteredAllOJTs != null && filteredAllOJTs.length >0) ? 
                                        new Column(
                                          mainAxisSize: MainAxisSize.max,
                                            children: <Widget>[
                                            FutureBuilder(
                                              future: _initialLoad,
                                              builder: (context, snapshot) {
                                                switch (snapshot.connectionState) {
                                                  case ConnectionState.waiting:
                                                  print("Show loader");
                                                    return Container(
                                                    height: MediaQuery.of(context).size.height * 0.06,
                                                    width: screenSize.width,
                                                    padding: EdgeInsets.only(top: 0.0),
                                                    child: Center(child: SpinKitHourGlass(color: darkGrey)));
                                                  case ConnectionState.done:
                                                  print("Loading complete");
                                                  return 
                                                  AspectRatio(
                                                    aspectRatio: !loadMoreDone ? (wp(2)/hp(1.342) + 0.05) : (screenSize.height > 600 ? (wp(2)/hp(1.303)) : (wp(2)/hp(1.265))),
                                                    child: 
                                                    Container(
                                                    child: IncrementallyLoadingListView(
                                                    hasMore: () => filteredTotalOJTsCount > filteredAllOJTs.length,
                                                    itemCount: () => filteredAllOJTs.length,
                                                    loadMore: () async {
                                                    // can shorten to "loadMore: _loadMoreItems" but this syntax is used to demonstrate that
                                                    // functions with parameters can also be invoked if needed
                                                    await _loadMoreItems();
                                                    },
                                                    onLoadMore: (){
                                                      isDataLoading = false;
                                                    },

                                                    onLoadMoreFinished: (){
                                                      isDataLoading = true;
                                                    },

                                                    loadMoreOffsetFromBottom: 0,
                                                    itemBuilder: (BuildContext context, int index) {
                                                      if ((isDataLoading ?? false) && (index == filteredAllOJTs.length - 1) && (filteredTotalOJTsCount != filteredAllOJTs.length)) {
                                                        print("Loading indicator");
                                                      return  Container(
                                                        height: 50.0,
                                                        width: screenSize.width,
                                                        padding: EdgeInsets.only(top: 0.0),
                                                        child: Center(child: SpinKitHourGlass(color: darkGrey)));
                                                      }
                                                      else{
                                                        return new GestureDetector( 
                                                            onTap: () {
                                                              print("Here I'm! " + index.toString()) ;
                                                            },
                                                            child: AllOJTsCard(filteredAllOJTs[index]));
                                                      }
                                                        
                                                    })));
                                                    default:
                                                    return Text('Something went wrong');
                                                }
                                              }
                                            ),
                                            
                                          ]
                                        )
                                      
                                        
                                        : Container(
                                              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                                              child: Text("No OJTs found.", style: termsStyle)
                                          )
                                      
                                    ], 
                                  ),
                                )
                          ]),
                    )

                  ]
                )
            
            ))));
          
  }


  onPressed(String routeName) {
    Navigator.of(context).pushNamed(routeName);
  }
}


// appBar: new AppBar(
        //   title: Container(
        //     height: MediaQuery.of(context).size.height * 0.04,
        //     child: FittedBox(
        //       fit: BoxFit.contain,
        //       child: Text((widget.loginType == 'admin' ? "Admin Home" : "User Home"), style: termsStyle, textAlign: TextAlign.center),
        //     )
        //   ),
        //   leading: new Container(
        //     height: MediaQuery.of(context).size.height * 0.04,
        //     width: 25.0,
        //     child: new Stack(
        //       alignment: AlignmentDirectional.center,
        //       children: <Widget>[
        //         new FlatButton(
        //             onPressed: (){
        //               Navigator.pop(
        //                 context
        //               );
        //             },
        //             child: new Icon(Icons.arrow_back_ios),
        //         )
        //       ],
        //     ),
        //   ),
        //   centerTitle: true,
        //   textTheme: TextTheme(
        //   title: pageTitleStyle),
        //   backgroundColor: appBarColor,
        //   iconTheme: IconThemeData(
        //     color: darkGrey,
        //   ),
        // ),