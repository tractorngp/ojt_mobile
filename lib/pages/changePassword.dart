import "package:flutter/material.dart";
import 'package:ojt_app/style/style.dart';
import 'package:ojt_app/models/user_model.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';
import 'package:ojt_app/pages/user_home.dart';
import 'package:ojt_app/services/services.dart';

class ChangePasswordPage extends StatefulWidget {
  final String from;
  final bool passExpired;
  ChangePasswordPage(this.from, this.passExpired);

  @override
  ChangePasswordPageState createState() => new ChangePasswordPageState();
}

class ChangePasswordPageState extends State<ChangePasswordPage> {
  BuildContext _loadingContext;

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  UserModel user;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _controllerCurrentPassword = new TextEditingController();
  final TextEditingController _controllerPassword = new TextEditingController();
  final TextEditingController _controllerConfirmPassword = TextEditingController();
  ChangePasswordPageState();
  Timer _timer;
  RestDatasource api = new RestDatasource();

  @override
  initState() {
    super.initState();
    getUser();
  }

  Future<Null> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userString = prefs.getString("user");
    if(userString != null && userString != ""){
        var val = json.decode(userString);
        setState(() {
          user = UserModel.map(val);
        });
    }
  }

  @override
  dispose() {
    super.dispose();
    if(_timer != null)
    _timer.cancel();
    
  }

  @override          
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return new Scaffold(
      key: _scaffoldKey,
      backgroundColor: whiteColor,
      appBar: new AppBar(
      title: Container(
        height: 30.0,
        child: FittedBox(
          fit: BoxFit.contain,
          child: Text("Change Password", style: pageTitleStyleNormalNoSize, textAlign: TextAlign.center),
        )
      ),
      // new Text("Change Password"),
       backgroundColor: whiteColor,
       textTheme: TextTheme(
        title: pageTitleStyle),iconTheme: IconThemeData(
        color: battleshipGrey, //change your color here
      )),
      bottomNavigationBar: new BottomAppBar(
          color: appBarColor,
          child: new Container(
            width: screenSize.width,
            height: 60.0,
            padding: EdgeInsets.only(left: screenSize.width / 5, right: screenSize.width / 5, top: 10.0, bottom: 10.0),
            child: new Stack(
              children: [
                InkWell(
                  onTap: submit,
                  child: new Container(
                    width: screenSize.width,
                    height: 60.0,
                    // margin: new EdgeInsets.only(bottom: 10.0, left: 5.0),
                    alignment: FractionalOffset.center,
                    decoration: new BoxDecoration(
                        color: paleGrey,
                        borderRadius: new BorderRadius.all(const Radius.circular(10.0)),
                        border: new Border.all(
                            color: const Color.fromRGBO(221, 221, 221, 1.0),
                            width: 1.0)),
                    child: new Text("Submit", style: saveSettingsButtonTextStyle),
                  ),
                )
              ],
            ),
            color: whiteColor,
          )),
      body: new SafeArea(
        top: true,
        bottom: true,
        child: new Form(
          key: _formKey,
          autovalidate: true,
          child: new ListView(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            children: <Widget>[
              (widget.passExpired != null && widget.passExpired == true) ? 
              Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Text("Password Expired", style: pageErrorLabel),
              )
              : Container(),
              new Text("Please enter a new password."),
              new Divider(
                color: battleshipGrey,
              ),
              new Row(children: <Widget>[
                new Expanded(
                    child: new TextFormField(
                  obscureText: true,
                  style: referenceTextStyleSub,
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(
                    hintStyle: placeholderStyle,
                    labelStyle: referenceTextStyleSub,
                    hintText: "Current Password",
                    enabledBorder: UnderlineInputBorder(      
                      borderSide: BorderSide(color: lightGrey),   
                    ),
                  ),
                  controller: _controllerCurrentPassword
                )),
              ]),
              new Row(children: <Widget>[
                new Expanded(
                    child: new TextFormField(
                  obscureText: true,
                  style: referenceTextStyleSub,
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(
                    hintStyle: placeholderStyle,
                    labelStyle: referenceTextStyleSub,
                    hintText: "Password",
                    enabledBorder: UnderlineInputBorder(      
                      borderSide: BorderSide(color: lightGrey),   
                    ),
                  ),
                  controller: _controllerPassword,
                  validator: (password) {
                    Pattern pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
                    RegExp regex = new RegExp(pattern);
                    if (!regex.hasMatch(password))
                    // return "Password must contain at least: \n1 lowercase letter, 1 uppercase letter,\n1 of the following special characters: \u0028 \u0021 \u0040 \u0023 \u0024 \u0026 \u002A \u0098 \u0029,\n1 number and 8 characters in total.";
                    return "Password must be at least 8 characters long\nand contain the following:\n1 uppercase letter, 1 lowercase letter,\nand 1 of the following special characters: \u0028 \u0021 \u0040 \u0023 \u0024 \u0026 \u002A \u0098 \u0029";
                    else
                    return null;

                  },
                )),
              ]),
              new Row(children: <Widget>[
                new Expanded(
                    child: new TextFormField(
                    obscureText: true,
                    style: referenceTextStyleSub,
                    keyboardType: TextInputType.text,
                    decoration: new InputDecoration(
                      hintStyle: placeholderStyle,
                      labelStyle: referenceTextStyleSub,
                      hintText: "Confirm Password",
                      enabledBorder: UnderlineInputBorder(      
                        borderSide: BorderSide(color: lightGrey),   
                      ),
                    ),
                    controller: _controllerConfirmPassword,
                    validator: (confirmPassword) {
                      if (confirmPassword.isEmpty || _controllerPassword.text != confirmPassword)
                        return "Password and Confirm Password fields must match";//"Confirm Password didn't match with Password";
                    },
                )),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  void submit() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      showLoader();
      if(_controllerPassword.text == _controllerConfirmPassword.text){
          api.updatePassword(user.tokenId, _controllerCurrentPassword.text,  _controllerPassword.text).then((dynamic result){
            dismissLoader();
            print(result);
            if(result != null && result.data['data'] == true){
              _showSnackBar("Password changed successfully");
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  settings: RouteSettings(name: "/userHome"),
                  builder: (context) => UserHomePage('user')
                ),
              );
            }
            else{
              _showSnackBar("Error updating password. Please try again later.");
            }
          }, onError: (err){
            print("Error");
            _showSnackBar("Error updating password. Please try again later.");
            dismissLoader();
          });
      }
      else{
        _showSnackBar("Password and Confirm Password don't match");
      }
    }
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

  void dismissLoader(){
    Navigator.pop(_loadingContext);
  }

  void _showSnackBar(String text) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }
}