import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ojt_app/components/Buttons/loginButton.dart';
import 'package:ojt_app/utils/validations.dart';
import 'package:ojt_app/style/style.dart';
import 'package:ojt_app/components/TextFields/inputField.dart';
import 'package:ojt_app/components/Buttons/textButton.dart';
import 'package:ojt_app/pages/user_home.dart';
import 'package:ojt_app/pages/admin_home.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/services.dart';

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
  bool autovalidate = false;

  BuildContext _loadingContext;

  void initState() {
    super.initState();
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
        appBar: new AppBar(
          title: Container(
            height: MediaQuery.of(context).size.height * 0.04,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text((widget.loginType == 'admin' ? "Admin Login" : "User Login"), style: termsStyle, textAlign: TextAlign.center),
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
                          padding: new EdgeInsets.only(bottom: 0, left: 0, right: 20.0, top: 40.0),
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              
                            new Row(children: <Widget>[
                              new Text((widget.loginType == 'admin' ? "Admin Login" : "User Login"), style: signinTitleStyle),
                            ])

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
                                  hintText: "ID",
                                  obscureText: false,
                                  textInputType: TextInputType.text,
                                  controller: idCtrl,
                                  textStyle: textStyle,
                                  hintStyle: placeholderStyle,
                                  textFieldColor: whiteColor,
                                  bottomMargin: 0.0,
                                  validateFunction: validations.validateEmail,
                                  // initValue: "",
                                  // onSaved: (String email) {}),
                                  onSaved: (val) => _username = val),
                                new InputField(
                                    hintText: "Password",
                                    obscureText: true,
                                    textInputType: TextInputType.text,
                                    textStyle: textStyle,
                                    hintStyle: placeholderStyle,
                                    textFieldColor: whiteColor,
                                    bottomMargin: 10.0,
                                    validateFunction:
                                        validations.validatePassword,
                                    initValue: "",
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
                                      "Forgot Password?\nCall the admin to reset it.",
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

  onPressed(String routeName) {
    Navigator.of(context).pushNamed(routeName);
  }

  void _showSnackBar(String text) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }


  void _submit() async{
    final form = formKey.currentState;

    if(widget.loginType == 'admin'){
      Navigator.push(
        context,
        MaterialPageRoute(
          settings: RouteSettings(name: "/adminHome"),
          builder: (context) => AdminHomePage(widget.loginType)
        ),
      );
    }
    else{
      Navigator.push(
        context,
        MaterialPageRoute(
          settings: RouteSettings(name: "/userHome"),
          builder: (context) => UserHomePage(widget.loginType)
        ),
    );
    }

    
     
    // if (form.validate()) {
    //   showDialog(
    //       barrierDismissible: false,
    //       context: context,
    //       builder: (BuildContext context) {
    //       _loadingContext = context;
    //       return Center(
    //         child: SpinKitHourGlass(color: whiteColor)
    //       );
    //   });
              
    //   form.save();
    // }
  }
}
