import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:ojt_app/pages/result.dart';
import 'package:ojt_app/style/style.dart';
import 'dart:convert';
import 'package:ojt_app/components/CustomAssessment/ratingchoice.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:photo_view/photo_view.dart';
import 'package:collection/collection.dart';
import 'package:auto_orientation/auto_orientation.dart';
import 'package:ojt_app/services/services.dart';


class TakeOJTsPage extends StatefulWidget {
  TakeOJTsPage({Key key, this.title, this.assessment, this.assessmentFinish}) : super(key: key);
  final VoidCallback assessmentFinish;
  final String title;
  final dynamic assessment;
  @override
  _TakeOJTsPageState createState() => _TakeOJTsPageState();
}

class _TakeOJTsPageState extends State<TakeOJTsPage>{
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  Size screenSize;
  BuildContext _loadingContext;
  List<dynamic> assessmentQs = [];
  List<dynamic> images = [];
  String userType;
  Timer _timer;
  RestDatasource api = new RestDatasource();
  var global_index = 0;
  var prevIndex = 0;
  var currentIndex = 0;
  var assessmentType = "completed";
  var isAssessmentCompleted = false;
  

  @override
  void initState() {
    super.initState();
    getUser();
    assessmentQs = widget.assessment.questions;
    images = widget.assessment.images;
    assessmentType = widget.assessment.status;
    isAssessmentCompleted = (assessmentType != null && assessmentType == 'completed') ? true : false;
    initializeAnswers();
  }

  Future<Null> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userType = prefs.getString("userType");
  }

  initializeAnswers(){
    for(var i=0;i<assessmentQs.length;i++){
      assessmentQs[i]['answers'] = [];
      for(var j=0;j<assessmentQs[i]['options'].length;j++){
        assessmentQs[i]['answers'].add(false);
      }
    }
    print("answers");
  }

  processAnswerValues(){
    var assessmentQsCopy = json.decode(json.encode(assessmentQs));
    for(var i=0;i<assessmentQsCopy.length;i++){
      var answersArray = [];
      for(var k=0;k<assessmentQsCopy[i]['answers'].length;k++){
        if(assessmentQsCopy[i]['answers'][k] == true){
          answersArray.add(assessmentQsCopy[i]['options'][k]);
        }
      }
      if(answersArray != null && answersArray.length >0){
        assessmentQsCopy[i]['answer_values'] = answersArray;
      }
      else{
        _showSnackBar("Please answer all questions!");
        return;
      }
    }

    Function eq = const ListEquality().equals;
    var answersMatch = false;
    for(var j=0;j<assessmentQsCopy.length;j++){
      assessmentQsCopy[j].remove('answers');
      if(eq(assessmentQsCopy[j]['answer_values'], assessmentQsCopy[j]['correct_answers'])){
        print("Answers matched for: " + j.toString());
        answersMatch = true;
      }
      else{
        print("Answers didn't match for: " + j.toString());
        answersMatch = false;
        break;
      }
    }
    showLoader();
    api.updateAssessmentStatus(widget.assessment.record_id, answersMatch, widget.assessment.no_of_attempts, assessmentQsCopy).then((res){
        print("Status updated");
        dismissLoader();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultPage(didPass: answersMatch, assessmentFinish: (){
              widget.assessmentFinish();
            })
          )
        );
      }, onError: (err){
        dismissLoader();
        print("Error: " + err.toString());
        _showSnackBar(err.toString());
    });

  }


  @override
  void dispose() {
    super.dispose();
    if(_timer != null)
    _timer.cancel();
  }

  void _showSnackBar(String text) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  setOrientationLandscape() {
     AutoOrientation.landscapeRightMode();
     SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  setOrientationPortrait() {
     AutoOrientation.portraitUpMode();
     SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }


  void showLoader(){
    if(context != null){
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
  }

  void dismissLoader(){
    if(_loadingContext != null){
      Navigator.pop(_loadingContext);
    }
  }

  Future<bool> _onWillPop() async{
    widget.assessmentFinish();
    Navigator.pop(context);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return WillPopScope(
    onWillPop: _onWillPop,
    child:  Scaffold(
      key: _scaffoldKey,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: new AppBar(
          title: Container(
            height: 30.0,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(widget.assessment.ojt_name, style: pageTitleStyleNormalNoSize, textAlign: TextAlign.center),
            )
          ),
          centerTitle: true,
          textTheme: TextTheme(
          title: pageTitleStyle),
          backgroundColor: appBarColor,
          iconTheme: IconThemeData(
            color: darkGrey, //change your color here
          ),
        ),
        
        bottomNavigationBar: isAssessmentCompleted == false ? new BottomAppBar(
          color: appBarColor,
          child: new Container(
            // grey box
            child: new Stack(
              children: [
                new Positioned(
                  child: new Container(
                    width: screenSize.width,
                    child : FlatButton(
                      color: redThemeColor,
                      textColor: whiteColor,
                      shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0)),
                      onPressed: (){
                        print("Save answers");
                        processAnswerValues();
                      },
                      child: Text("Submit")
                    ),
                    padding: new EdgeInsets.only(
                      top: 10.0,
                      right: 50.0,
                      bottom: 10.0,
                      left: 50.0) 
                  ),
                )
              ],
            ),
            width: screenSize.width,
            height: 60.0,
            color: whiteColor,
          )) : BottomAppBar(),
        body: Container(
          height: screenSize.height,
          width: screenSize.width,
          padding: EdgeInsets.only(top: 0.0, bottom: 20.0, left: 10.0, right: 10.0),
          color: whiteColor,
          child: _buildList(context)
        )
                
        
        // )
    ));
  }

  

    Swiper _buildList(context) {
      var imgLength = (images != null ? images.length : 0);
       return new Swiper(
        itemCount: (assessmentQs.length + imgLength),
        pagination: new SwiperPagination(
          builder: const DotSwiperPaginationBuilder(
            size: 10.0, activeSize: 10.0, space: 5.0, color: Color(0xFFE0E0E0), activeColor: Color.fromRGBO(110, 120, 132, 1.0))
          ),
          control: new SwiperControl(
            padding: EdgeInsets.only(top: screenSize.height - (screenSize.height*0.4)),
            color: darkGrey  
          ),
          loop: true,
        
          onIndexChanged:(qIndex) {
            //countly event////////////////
            prevIndex = currentIndex;
            currentIndex = qIndex;

            print("Current Index: $currentIndex");
            print("Prev Index: $prevIndex");
          },
          itemBuilder: (BuildContext context, int index) {
            global_index = index;
            if(index < imgLength){
              return Center(
                child: SingleChildScrollView( 
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: screenSize.width * 0.85,
                        height: screenSize.height * 0.65,
                        child: new GestureDetector( 
                          onTap: () {
                            print("Here I'm! dialog") ;
                            showPhotoDialog(index);
                          },
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/loading.gif',
                            image: images[index],
                            fit: BoxFit.fitWidth
                          )
                        )
                      )
                    ]
                  )
                )
              );
            }
            else{
              return new GestureDetector( 
                  onTap: () {
                    print("Here I'm! " + (imgLength).toString()) ;
                  },
                  child: SingleChildScrollView(
                    child: RatingChoiceComponent(questionText: assessmentQs[index-imgLength]['question_text'], orderNumber: assessmentQs[index-imgLength]['order_num'], options: assessmentQs[index-imgLength]['options'], answers: assessmentQs[index-imgLength]['answers'], q_type: assessmentQs[index-imgLength]['q_type'], status: assessmentType, answer_values: assessmentQs[index-imgLength]['answer_values']),
                  )
              ); 
            }

          },
    );
  }

  showPhotoDialog(index){
    setOrientationLandscape();
    showGeneralDialog(
        context: context,
        barrierColor: Colors.black12.withOpacity(0.8), // background color
        barrierDismissible: false, // should dialog be dismissed when tapped outside
        barrierLabel: "Dialog", // label for barrier
        transitionDuration: Duration(milliseconds: 400), // how long it takes to popup dialog after button click
        pageBuilder: (_, __, ___) { // your widget implementation 
          return SizedBox.expand( // makes widget fullscreen
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: SizedBox.expand(
                    child:  PhotoViewGallery.builder(
                      scrollPhysics: const BouncingScrollPhysics(),
                      builder: (BuildContext context, int photoIndex) {
                          return PhotoViewGalleryPageOptions(
                              imageProvider: NetworkImage(images[index]),
                              initialScale: PhotoViewComputedScale.contained * 1.0,
                            );
                          },
                          itemCount: 1,
                          loadingBuilder: (context, event) => Center(
                            child: Container(
                              width: 20.0,
                              height: 20.0,
                              child: CircularProgressIndicator(
                                value: event == null
                                    ? 0
                                    : event.cumulativeBytesLoaded / event.expectedTotalBytes,
                              ),
                            ),
                          ),
                          backgroundDecoration: BoxDecoration(color: blackColor),
                    )
                  ),
                ),
                Container(
                  width: screenSize.width,
                  height: screenSize.height * 0.05,
                  child: RaisedButton(
                    color: redThemeColor,
                    child: Text(
                      "Dismiss",
                      style: TextStyle(fontSize: 20.0),
                    ),
                    textColor: Colors.white,
                    onPressed: (){
                      setOrientationPortrait();
                      Navigator.pop(context);
                    },
                  )
                )
              ],
            ),
          );
        },
    );
  }
}