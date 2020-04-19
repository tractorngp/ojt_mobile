import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ojt_app/style/style.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ojt_app/components/bottom_navigation_bar.dart';

class AdminHomePage extends StatefulWidget {
  final String loginType;
  AdminHomePage(this.loginType);
  @override
  State<StatefulWidget> createState() {
    return new AdminHomePageState(this.loginType);
  } 
}


class AdminHomePageState extends State<AdminHomePage>
{
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  Size screenSize;
  String loginType;
  ScrollController scrollController = new ScrollController();
  BuildContext _loadingContext;

  void initState() {
    super.initState();
  }

  AdminHomePageState(loginType);

  @override
  Widget build(BuildContext context) {
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