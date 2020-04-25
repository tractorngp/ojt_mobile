import 'package:flutter/material.dart';
import 'package:ojt_app/pages/login.dart';
import 'package:ojt_app/Routes.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io' show Platform;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(Platform.isIOS){
    await FirebaseApp.configure(
      name: 'TractorPG',
      options: const FirebaseOptions(
        googleAppID: '1:240306423405:ios:2023751a726d77a63c2164',
        gcmSenderID: '240306423405',
        apiKey: 'AIzaSyBk-Cbd3GoNDBptjZnknxYaUaOnTJ74DiQ',
        projectID: 'ojtappl',
      ),
    );
  }
  else{
    await FirebaseApp.configure(
      name: 'TractorPG',
      options: const FirebaseOptions(
        googleAppID: '1:240306423405:android:9ddf06112c9c31da3c2164',
        gcmSenderID: '240306423405',
        apiKey: 'AIzaSyBk-Cbd3GoNDBptjZnknxYaUaOnTJ74DiQ',
        projectID: 'ojtappl',
      ),
    );
  }
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OJT',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: LoginPage('user'),
      routes: Routes().routes,
    );
  }
}
