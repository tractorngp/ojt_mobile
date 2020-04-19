import 'package:flutter/material.dart';
import 'package:ojt_app/style/style.dart';
import 'package:ojt_app/pages/user_home.dart';
import 'package:ojt_app/pages/admin_home.dart';
import 'package:ojt_app/pages/about.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class BottomNavigationBarComponent extends StatefulWidget{
  final int index;
  BottomNavigationBarComponent(this.index);
  @override
  BottomNavigationBarState createState() {
    return new BottomNavigationBarState();
  }
}

class BottomNavigationBarState extends State<BottomNavigationBarComponent>{
  Size screenSize;
  int _currentIndex = 0;
  int notificationsCount;
  
  BottomNavigationBarState();
  dynamic items = [];
  String userType;
  
  void initState() {
      super.initState();
      _currentIndex = widget.index;
      getUser();
  }

  Future<Null> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userType = prefs.getString("userType");
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return Container(
      height: screenSize.height * 0.11,
      color: Color.fromRGBO(255, 255, 255, 1),
      child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: bottomTabBar,
            onTap: onTabTapped, 
            currentIndex: _currentIndex,
            items: [
              BottomNavigationBarItem(
                backgroundColor: bottomTabBar,
                icon: new Icon(Icons.home, color: _currentIndex == 0 ? Colors.blueAccent[200] : Colors.black54),
                title: Text('')
              ),
              BottomNavigationBarItem(
                backgroundColor: bottomTabBar,
                icon: Icon(Icons.help, color: _currentIndex == 1 ? Colors.blueAccent[200] : Colors.black54),
                title: Text('')
              ),
            ],
      ));
  }


  void onTabTapped(int index) async{
    print("current index: " + index.toString());
    if(index == _currentIndex){
      //Do nothing
    }
    else{
       _currentIndex = index;
        setState(() {
          _currentIndex = index;
        });

        if(index == 0){
          if(userType != null && userType == 'admin'){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AdminHomePage(userType),
              ),
            );
          }
          else{
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => UserHomePage(userType),
              ),
            );
          }
        }
        else if(index == 1){
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AboutPage(),
            ),
          );

        }
        
      }
    }
   
}