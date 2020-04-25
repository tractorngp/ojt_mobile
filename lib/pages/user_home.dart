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
import 'package:cloud_firestore/cloud_firestore.dart';

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
  var moreOJTs = <OJTsCardModel>[];
  Future _initialLoad;
  var loadMoreDone;
  var totalOJTsCount = 2;
  var isDataLoading;
  bool partialLoad = false;
  var nor = 10, pageIndexGlobal = 0;
  final Firestore firestore = Firestore.instance;

  @override
  initState(){
    super.initState();
    initTheView();
    _tabController = new TabController(vsync: this, length: 2, initialIndex: _currentIndex);
    loadMoreDone = true;
    isDataLoading = false;
    moreOJTs
    ..add(new OJTsCardModel("1234","Title 1", "pending", ['image1.png','image2.png'],[
        {
          "questionText": "How are you?",
          "orderNumber": 1,
          "options":[
            "Good",
            "Bad",
            "Don't know"
          ],
          "answers": []
        },
        {
          "questionText": "What do you do?",
          "orderNumber": 2,
          "options": [
            "Job",
            "No Job",
            "Nothing",
            "None of the above"
          ],
          "answers": []
        },
        {
          "questionText": "Do you like the app?",
          "orderNumber": 3,
          "options":[
            "Yes",
            "No",
            "Not sure yet",
            "None of the above"
          ],
          "answers": []
        }
    ]))
    ..add(new OJTsCardModel("2345","Title 2", "complete",['image1.png','image2.png'],[
        {
          "questionText": "How are you?",
          "orderNumber": 1,
          "options":[
            "Good",
            "Bad",
            "Don't know"
          ],
          "answers": []
        },
        {
          "questionText": "What do you do?",
          "orderNumber": 2,
          "options": [
            "Job",
            "No Job",
            "Nothing",
            "None of the above"
          ],
          "answers": []
        },
        {
          "questionText": "Do you like the app?",
          "orderNumber": 3,
          "options":[
            "Yes",
            "No",
            "Not sure yet",
            "None of the above"
          ],
          "answers": []
        }
    ]));
    this.getData();
  }

  initTheView() async{
    await getUser();
    fetchOJTsData();
  }

  UserHomePageState(loginType);

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  fetchOJTsData() async{
    var ojts = firestore.collection('assigned_ojts').where('active', isEqualTo: true).limit(nor).getDocuments();
    print(ojts);
  }

  Future<Null> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userString = prefs.getString("user");
    var val = json.decode(userString);
    user = UserModel.map(val);
  }

  Future<Null> getData() async{
    setState(() {
      filteredAllOJTs = moreOJTs;
      filteredPendingOJTs = filteredAllOJTs;  
    });
    
    _initialLoad = Future.delayed(Duration(seconds: 0), () {
        // showLoader();
        // filteredAllOJTs = moreOJTs;
        // filteredPendingOJTs = filteredAllOJTs;
    });
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

  Future _loadMoreItems() async {
    print("Load more");
    partialLoad = true;
    // showLoader();
    if(loadMoreDone){
      print("Loading data");
      setState(() {
         loadMoreDone = false;     
      });
      pageIndexGlobal++;
      //Load more OJTs here
      var noe = (pageIndexGlobal * nor);
      filteredAllOJTs = moreOJTs.getRange(noe, noe+2);
      filteredPendingOJTs = filteredAllOJTs;
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
        appBar: new AppBar(
          title: Container(
            height: MediaQuery.of(context).size.height * 0.04,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text((widget.loginType == 'admin' ? "Admin Home" : "User Home"), style: termsStyle, textAlign: TextAlign.center),
            )
          ),
          leading: new Container(
            height: MediaQuery.of(context).size.height * 0.04,
            width: 25.0,
            child: new Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                new FlatButton(
                    onPressed: (){
                      Navigator.pop(
                        context
                      );
                    },
                    child: new Icon(Icons.arrow_back_ios),
                )
              ],
            ),
          ),
          centerTitle: true,
          textTheme: TextTheme(
          title: pageTitleStyle),
          backgroundColor: appBarColor,
          iconTheme: IconThemeData(
            color: darkGrey,
          ),
        ),
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(right: 20.0),
                          child: Text((widget.loginType == 'admin' ? "Admin: " : "User: ") + 'username', style: textStyle)
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
                                child: new Text("Pending OJTs", style: (tabIndex == 0) ? noButtonTextStyleBold : noButtonTextStyle),
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
                                child: new Text("All OJTs", style: (tabIndex == 1) ? noButtonTextStyleBold : noButtonTextStyle),
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
                                                  // height: (screenSize.height > 600) ? (screenSize.height > 812 ? screenSize.height * 0.66 : screenSize.height * 0.6517) : (screenSize.height * 0.64),
                                                  // height: (screenSize.height > 812 ? hp(68.4) : ((screenSize.height > 736 && screenSize.height <= 812) ? hp(67) : ((screenSize.height > 667 && screenSize.height <= 736) ? hp(65): (screenSize.height > 568 && screenSize.height <= 667) ? hp(65) : hp(60)))),
                                                  // height: !loadMoreDone ? (screenSize.height > 600 ? hp(60) : hp(50)) : (screenSize.height > 600 ? hp(68.5) : hp(60)),
                                                child: IncrementallyLoadingListView(
                                                hasMore: () => totalOJTsCount > filteredAllOJTs.length,
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
                                                  if ((isDataLoading ?? false) && (index == filteredAllOJTs.length - 1) && (totalOJTsCount != filteredAllOJTs.length)) {
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
                                                                builder: (context) => TakeOJTsPage(title: filteredAllOJTs[index].title, assessment: filteredAllOJTs[index], assessmentFinish: (){
                                                                  print("OJT finished");
                                                                }),
                                                              ),
                                                            );
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

                                Container(
                                  width: screenSize.width,
                                  // height: (visitHistoryList.length * 100).ceilToDouble(),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                                    hasMore: () => totalOJTsCount > filteredAllOJTs.length,
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
                                                      if ((isDataLoading ?? false) && (index == filteredAllOJTs.length - 1) && (totalOJTsCount != filteredAllOJTs.length)) {
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

  void _showSnackBar(String text) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }
}