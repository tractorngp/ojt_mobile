import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ojt_app/style/style.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ojt_app/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingPage extends StatefulWidget {
  
  @override
  LandingPageState createState(){
    return new LandingPageState();
  }
}


class LandingPageState extends State<LandingPage>
{
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  Size screenSize;
  ScrollController scrollController = new ScrollController();

  BuildContext _loadingContext;

  void initState() {
    super.initState();
  }

  LandingPageState();

  Future<Null> setUserType(type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("userType", type);
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        backgroundColor: whiteColor,
         body:  new SafeArea(
          top: false,
          bottom: false, 
          child: SingleChildScrollView(
            controller: scrollController,
            child: new Container(
              padding: EdgeInsets.only(left: 0.0,top: 20.0, right: 0.0),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      padding: new EdgeInsets.only(bottom: 0, left: 0, top: 10.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[  
                          Text("Tractor PG", style: pageTitleStyle),

                          Container(
                            width: screenSize.width / 2,
                            height: screenSize.height / 8,
                            margin: EdgeInsets.only(top: 50.0),
                            padding: EdgeInsets.all(5.0),
                            child: FlatButton(
                              color: lightGrey,
                              textColor: darkTextColor,
                              highlightColor: darkGrey,
                              onPressed: () {
                                setUserType('user');
                                Navigator.push(
                                            context,
                                    MaterialPageRoute(
                                      settings: RouteSettings(name: "/LoginPage"),
                                      builder: (context) => LoginPage('user')
                                    ),
                                );
                              },
                              child: Text(
                                "User Login", style: noButtonTextStyleBold,
                              ),
                            ),
                          ),

                          Container(
                            width: screenSize.width / 2,
                            height: screenSize.height / 8,
                            padding: EdgeInsets.all(5.0),
                            child: FlatButton(
                              color: lightGrey,
                              textColor: darkTextColor,
                              highlightColor: darkGrey,
                              onPressed: () {
                                setUserType('admin');
                                Navigator.push(
                                            context,
                                    MaterialPageRoute(
                                      settings: RouteSettings(name: "/LoginPage"),
                                      builder: (context) => LoginPage('admin')
                                    ),
                                );
                              },
                              child: Text(
                                "Admin Login", style: noButtonTextStyleBold
                              ),
                            ),
                          ),
                        ]
                      )
                    )
                  ])
            ))));
  }
}