import 'package:flutter/material.dart';
import 'package:ojt_app/pages/user_home.dart';
import 'package:ojt_app/pages/admin_home.dart';
import 'package:ojt_app/style/style.dart';
import 'package:ojt_app/pages/about.dart';

class Routes {

  static Routes _routes;
  factory Routes() => _routes ??= new Routes._();
 
  Routes._();

  var routes = <String, WidgetBuilder>{
    "/userHome": (BuildContext context) => new UserHomePage(""),
    "/adminHome": (BuildContext context) => new AdminHomePage(""),
    "/about": (BuildContext context) => new AboutPage()
  };

  routesWitUser(String param) {
    Widget page;  

runApp(GestureDetector(
      
      child: MaterialApp(
      
      supportedLocales: [
          
      ],
        home: page,//new LoginPage(),
        theme: appTheme,
        routes: routes,
        // ... from here it's just your normal app,
        // Remember that any GestureDetector within your app must have
        //   HitTestBehavior.translucent
      ),
    ));

  }

}
