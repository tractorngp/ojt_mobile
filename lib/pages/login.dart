import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ojt_app/components/Buttons/loginButton.dart';
import 'package:ojt_app/utils/validations.dart';
import 'package:ojt_app/style/style.dart';
import 'package:ojt_app/components/TextFields/inputField.dart';
import 'package:ojt_app/components/Buttons/textButton.dart';
import 'package:ojt_app/pages/user_home.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/services.dart';
import 'package:ojt_app/utils/validations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:ojt_app/services/constants.dart' as Constants;
import 'package:device_info/device_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ojt_app/models/user_model.dart';
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:ojt_app/services/services.dart';
import 'package:auto_orientation/auto_orientation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LoginPage extends StatefulWidget {
  final String loginType;
  LoginPage(this.loginType);

  @override
  State<StatefulWidget> createState(){
    return new LoginPageState(this.loginType);
  } 
}


class LoginPageState extends State<LoginPage>
{
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  Size screenSize;
  String loginType;
  String _username, _password;
  ScrollController scrollController = new ScrollController();
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  String deviceToken;
  String devicePlatform;
  TextEditingController idCtrl;
  TextEditingController pwdCtrl;
  bool autovalidate = false;
  String _deviceid = 'Unknown';
  String pushToken;
  UserModel user;
  RestDatasource api = new RestDatasource();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  BuildContext _loadingContext;
  final Firestore firestore = Firestore.instance;

  @override
  initState() {
    super.initState();
    idCtrl = new TextEditingController();
    pwdCtrl = new TextEditingController();
    initTheView();
    _firebaseMessaging.getToken().then((String token) {
      print("Push Messaging token: $token");
      pushToken = token;
    });
  }

  setOrientation() {
     AutoOrientation.portraitUpMode();
     SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  

  initTheView() async{
    _deviceid = await initDeviceId();
    getUser();
  }

  Future<String> initDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }

  LoginPageState(loginType);

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    
    Validations validations = new Validations();

    var loginBtn = new LoginButton(
      buttonName: "Login",
      onTap: _submit,
      width: screenSize.width / 2,
      height: 50.0,
      bottomMargin: 10.0,
      borderWidth: 0.0,
      buttonColor: darkGrey
    );
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
              padding: EdgeInsets.only(left: 0.0,top: 0.0, right: 0.0),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      padding: new EdgeInsets.only(bottom: 10.0, left: 20.0, right: 0, top: 20.0),
                      // height: screenSize.height / 2.5,
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
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

                        Container(
                          padding: new EdgeInsets.only(bottom: 0, left: 0, right: 20.0, top: 20.0),
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(right: 10.0),
                                  child: new Image.asset(
                                    'assets/tractor.png',
                                    height: 80.0,
                                    width: 80.0,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Text((widget.loginType == 'admin' ? "Admin Login" : "OJT App Login"), style: signinTitleStyle)
                              ]
                          ),
                          

                        ]))

                        ],
                      ),
                    ),
                    
                    new Container(
                      // height: screenSize.height / 2,
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          new Form(
                            key: formKey,
                            autovalidate: autovalidate,
                            
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                new InputField(
                                  hintText: "Token ID",
                                  obscureText: false,
                                  textInputType: TextInputType.text,
                                  controller: idCtrl,
                                  textStyle: textStyle,
                                  hintStyle: placeholderStyle,
                                  textFieldColor: whiteColor,
                                  bottomMargin: 0.0,
                                  validateFunction: validations.validateEmail,
                                  onSaved: (val) => _username = val
                                  ),
                                new InputField(
                                    hintText: "Password",
                                    obscureText: true,
                                    textInputType: TextInputType.text,
                                    controller: pwdCtrl,
                                    textStyle: textStyle,
                                    hintStyle: placeholderStyle,
                                    textFieldColor: whiteColor,
                                    bottomMargin: 10.0,
                                    validateFunction:
                                        validations.validatePassword,
                                    onSaved: (val) => _password = val),
                                
                                  Container(
                                    padding: EdgeInsets.all(20.0),
                                    child: loginBtn
                                  )
                              ],
                            ),
                            
                          ),

                          new Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              new TextButton(
                                  buttonName:
                                      "Forgot Password",
                                  onPressed: _onPressed,
                                  buttonTextStyle: buttonTextStyle)
                            ],
                          )
                        ],
                      ),
                  )
                  ],
                ),
            ))));
  }

  _onPressed() {
    AlertDialog dialog = new AlertDialog(
      content: new Text(
        "If you’ve forgotten your password, please call your admin to have it reset.",
        style: referenceTextStyle
      ),
    );
    showDialog(context: context, builder: (_) => dialog);
  }

  void showLoader(){
    if(_loadingContext != null){
      dismissLoader();
    }
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
    if(_loadingContext != null)
    Navigator.pop(_loadingContext);
    _loadingContext = null;
  }

  onPressed(String routeName) {
    Navigator.of(context).pushNamed(routeName);
  }

  void _showSnackBar(String text) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

   Future<Null> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userString = prefs.getString("user");
    if(userString != null && userString != ""){
        var val = json.decode(userString);
        setState(() {
          user = UserModel.map(val);
          idCtrl.text = user.tokenId;
        });
    }
  }

  Future<Null> storeUser() async {
    print("Homepage store user");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userMap = user.toMap();
    var userString = json.encode(userMap);
    prefs.setString("user", userString);
    print("Login store done");
  }


  void _submit(){
    final form = formKey.currentState;
    if (form.validate()) {
      showLoader();
      _username = idCtrl.text;
      _password = pwdCtrl.text;
      print("Salt: " + Constants.SALT);

      DocumentReference documentReference;
      api.getDocumentReference("users", _username).then((DocumentReference docRef){
        documentReference = docRef;
          api.login(_username, _password).then((DocumentSnapshot datasnapshot){
          if (datasnapshot != null) {
            print(datasnapshot.data['name'].toString());
            var passHash = datasnapshot.data['hpw'];
            var passwordsMatch = DBCrypt().checkpw(_password, passHash);
            var checkIfDeviceRegistered = (datasnapshot.data['deviceToken'] != null ? ((datasnapshot.data['deviceToken'].toString() == _deviceid.toString()) ? false : true) : false);
            print(passwordsMatch);
            dismissLoader();
            if(passwordsMatch && !checkIfDeviceRegistered){
              if(datasnapshot.data['role'].toString() != "user"){
                _showSnackBar("Not authorized to login.");
              }
              else if(datasnapshot.data['active'] != null && datasnapshot.data['active'] == false){
                _showSnackBar("User deactivated. Please contact admin.");
              }
              else{
                user = UserModel.map(datasnapshot.data);
                api.updateDeviceToken(_deviceid, pushToken, documentReference).then((res) async{
                    await storeUser();
                    setState(() {
                      idCtrl.text = "";
                      pwdCtrl.text = "";
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          settings: RouteSettings(name: "/userHome"),
                          builder: (context) => UserHomePage('user')
                        ),
                      );
                    });
                });
              }
            }
            else if(checkIfDeviceRegistered == true){
              print("There is another device registered with the user. Please contact admin.");
              _showSnackBar("There is another device registered with the user. Please contact admin.");
            }
            else{
              print("Invalid password");
              _showSnackBar("Invalid password");
            }
          }
          else{
            dismissLoader();
            print("No such user");
            _showSnackBar("Invalid user");
          }
        });
      });    
    }
  }
}


// pushSampleOJTs(){
  //   var ojtTemplate = {
  //     "active": true,
  //     "questions": [
  //         {
  //             "question_text": "How are you?",
  //             "options": ["Good", "Bad", "Ok", "None of the above"],
  //             "order_num": 1,
  //             "correct_answers": ["Good", "Ok"]
  //         },
  //         {
  //             "question_text": "How do you like the app?",
  //             "options": ["Good", "Bad", "Not Great", "Average", "Don't know"],
  //             "order_num": 2,
  //             "correct_answers": ["Good"]
  //         },
  //         {
  //             "question_text": "Did you answer above questions?",
  //             "options": ["Yes", "No"],
  //             "order_num": 3,
  //             "correct_answers": ["Yes"]
  //         }

  //         {
  //             "question_text": "What do you do?",
  //             "options": ["Job", "Homemaker", "Who gives a shit"],
  //             "order_num": 1,
  //             "correct_answers": ["Who gives a shit"]
  //         },

  //         {
  //             "question_text": "What's your age?",
  //             "options": ["0-10", "10-20", "20-50","Dead"],
  //             "order_num": 2,
  //             "correct_answers": ["20-50"]
  //         },
  //         {
  //             "question_text": "Is this the last question?",
  //             "options": ["Yes", "No"],
  //             "order_num": 3,
  //             "correct_answers": ["Yes"]
  //         }

  //         {
  //             "question_text": "The answer is yes",
  //             "options": ["Yes", "No"],
  //             "order_num": 1,
  //             "correct_answers": ["Yes"]
  //         }
  //         {
  //             "question_text": "Do you like this app (Hint: Ofcourse you have to!)?",
  //             "options": ["Yes", "No"],
  //             "order_num": 1,
  //             "correct_answers": ["Yes"]
  //         }
  //     ],
  //     "assigned_to": "/users/1115",
  //     "group_id": "/users/group3",
  //     "images": ["image1.png", "image2.png"],
  //     "no_of_attempts": 0,
  //     "ojt_name": "OJT 4",
  //     "record_id": "19",
  //     "status": "assigned"
  //   };

  //   firestore.collection("assigned_ojts").document('rec19').setData(ojtTemplate).then((result) => {
  //       print("Document successfully written!")
  //   }).catchError((error) => {
  //       print("Error writing document: " + error)
  //   });
  // }
