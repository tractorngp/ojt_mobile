import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ojt_app/style/style.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ojt_app/components/bottom_navigation_bar.dart';

class AboutPage extends StatefulWidget {
  
  @override
  AboutPageState createState(){
    return new AboutPageState();
  }
}


class AboutPageState extends State<AboutPage>
{
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  Size screenSize;
  ScrollController scrollController = new ScrollController();
  String userType;

  BuildContext _loadingContext;

  void initState() {
    super.initState();
  }

  AboutPageState();

  Future<Null> getUserType(type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userType = prefs.getString("userType");
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        backgroundColor: whiteColor,
        bottomNavigationBar: BottomNavigationBarComponent(1),
        appBar: new AppBar(
          title: Container(
            height: MediaQuery.of(context).size.height * 0.04,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text("About", style: termsStyle, textAlign: TextAlign.center),
            )
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
          textTheme: TextTheme(
          title: pageTitleStyle),
          backgroundColor: appBarColor,
          iconTheme: IconThemeData(
            color: darkGrey,
          ),
        ),
         body:  new SafeArea(
          top: false,
          bottom: false, 
          child: SingleChildScrollView(
            controller: scrollController,
            child: new Container(
              padding: EdgeInsets.only(left: 0.0,top: 20.0, right: 0.0),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        new Container(
                          padding: EdgeInsets.only(right: 30.0),
                          child: new Image.asset(
                            'assets/full_logo.png',
                            height: 150.0,
                            width: 150.0,
                            fit: BoxFit.contain,
                          ),
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: 0.0, left: 0.0),
                          child: Image.asset(
                            'assets/tractor.png',
                            height: 150.0,
                            width: 180.0,
                            fit: BoxFit.contain,
                          ),
                        )
                      ],
                    ),

                    Container(
                      padding: new EdgeInsets.only(bottom: 0, left: 0, top: 30.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[  
                          Text("Tractor PG", style: pageTitleStyle),

                          Container(
                            margin: EdgeInsets.only(top: 50.0),
                            child: Text("Version 1.0", style: termsStyleBoldUnderline)
                          ),
                        ]
                      )
                    )
                  ])
            ))));
  }
}