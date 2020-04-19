import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  IconData icon;
  String hintText;
  String initValue;
  TextInputType textInputType;
  Color textFieldColor, iconColor;
  bool obscureText;
  double bottomMargin;
  TextStyle textStyle, hintStyle;
  var validateFunction;
  var onSaved;
  bool enabled;
  TextEditingController controller;
  Key key;

  //passing props in the Constructor.
  //Java like style
  InputField(
      {this.key,
      this.hintText,
      this.obscureText,
      this.textInputType,
      this.textFieldColor,
      this.icon,
      this.iconColor,
      this.bottomMargin,
      this.textStyle,
      this.validateFunction,
      this.onSaved,
      this.hintStyle,
      this.initValue,
      this.enabled,
      this.controller
      });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return (new Container(
        margin: new EdgeInsets.only(bottom: bottomMargin),
        padding: EdgeInsets.all(20.0),
        child: new DecoratedBox(
          decoration: new BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: textFieldColor),
          child: new TextFormField(
            initialValue: initValue,
            controller: controller,
            style: textStyle,
            key: key,
            enabled: this.enabled,
            obscureText: obscureText,
            keyboardType: textInputType,
            validator: validateFunction,
            onSaved: onSaved,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: hintStyle,
              contentPadding: EdgeInsets.all(10.0),        
              enabledBorder: UnderlineInputBorder(      
                borderSide: BorderSide(color: Color.fromRGBO(222, 225, 229, 1.0)),
              ),    
          ),
            
              
        ))));
  }
}
