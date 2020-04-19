import 'package:flutter/material.dart';

Color appBarColor = const Color.fromRGBO(255, 255, 255, 1);
Color whiteColor = const Color.fromRGBO(255, 255, 255, 1);
Color darkGrey = const Color.fromRGBO(110, 120, 132, 1.0);
Color bottomTabBar = Colors.white54;
Color darkTextColor = const Color.fromRGBO(7, 17, 49, 1.0);
Color lightGrey = const Color.fromRGBO(139, 146, 155, 1.0);
Color borderGrey = const Color.fromRGBO(192, 192, 192, 1.0);
Color paleGrey = const Color.fromRGBO(242, 244, 247, 1.0);
Color percentBarColor = const Color.fromRGBO(225, 226, 231, 1.0);
Color blueBarColor = const Color.fromRGBO(119, 212, 219, 1.0);
Color orangeBarColor = const Color.fromRGBO(242, 176, 74, 1.0);
Color themeColor = const Color.fromRGBO(47, 97, 223, 1.0);
Color greyedOutText = const Color.fromRGBO(112, 120, 131, 1.0);
Color blackColor = const Color.fromRGBO(127, 132, 147, 1.0);
Color darkBlack = const Color.fromRGBO(0, 0, 0, 1.0);
Color textBlackColor = const Color.fromRGBO(7, 17, 49, 1.0);
Color upcomingVisitDot = const Color.fromRGBO(193, 212, 255, 1.0);
Color yesButtonColor = const Color.fromRGBO(49, 96, 221, 1.0);
Color blueThemeColor = const Color.fromRGBO(47, 97, 223, 1.0);
Color redThemeColor = const Color.fromRGBO(255, 58, 58, 1.0);
Color visitDetailsColor = const Color.fromRGBO(7, 17, 49, 1.0);
Color aquaCustom = const Color.fromRGBO(79, 217, 222, 1.0);
Color battleshipGrey = const Color.fromRGBO(110, 120, 132, 1.0);
Color hintColor = Colors.grey;
Color darkIndigo = const Color.fromRGBO(7, 17, 49, 1.0);
Color textFieldBackground = const Color.fromRGBO(234, 240, 252, 1.0);
Color transparentColor = const Color.fromRGBO(230, 230, 230, 1.0);


const String fontFamilyName = "Roboto";

TextStyle pageTitleStyle = TextStyle(
    color: Colors.black,
    fontSize: 28.0,
    fontFamily: fontFamilyName,
    fontWeight: FontWeight.bold);

TextStyle notificationSubtitleStyle = TextStyle(
  color: Colors.black,
  fontSize: 18.0,
  fontFamily: fontFamilyName,
  fontWeight: FontWeight.bold);

TextStyle pageTitleStyleNormal = TextStyle(
    color: Colors.black,
    fontSize: 20.0,
    fontFamily: fontFamilyName,
    fontWeight: FontWeight.w400);

TextStyle pageTitleStyleNormalNoSize = TextStyle(
    color: darkGrey,
    fontFamily: fontFamilyName,
    fontWeight: FontWeight.w300);

TextStyle headingTitleNormal = TextStyle(
    color: Colors.black,
    fontSize: 14.0,
    fontFamily: fontFamilyName,
    fontWeight: FontWeight.normal);

TextStyle headingTitleTextBold = TextStyle(
color: Colors.black,
fontSize: 18.0,
fontFamily: fontFamilyName,
fontWeight: FontWeight.bold);

TextStyle headingTitleBold = TextStyle(
color: Colors.black,
fontSize: 14.0,
fontFamily: fontFamilyName,
fontWeight: FontWeight.bold);


TextStyle pageErrorLabel = TextStyle(
color: Colors.red,
fontSize: 16.0,
fontFamily: fontFamilyName,
fontWeight: FontWeight.bold);

TextStyle overdueLabel = TextStyle(
color: Colors.red,
fontSize: 12.0,
fontFamily: fontFamilyName,
fontWeight: FontWeight.bold);


ThemeData appTheme = new ThemeData(
  brightness: Brightness.light,
  hintColor: Color.fromRGBO(38, 38, 38, 1.0),
  primarySwatch: Colors.red,
);

TextStyle referenceTextStyle = TextStyle(
    color: darkTextColor,
    fontSize: 16.0,
    fontFamily: fontFamilyName,
    fontWeight: FontWeight.w500);

TextStyle referenceTextStyleRed = TextStyle(
    color: Colors.red,
    fontSize: 16.0,
    fontFamily: fontFamilyName,
    fontWeight: FontWeight.w500);

TextStyle referenceTextStyleBold = TextStyle(
    color: darkTextColor,
    fontSize: 16.0,
    fontFamily: fontFamilyName,
    fontWeight: FontWeight.bold);

TextStyle referenceTextStyleSub = TextStyle(
  color: darkGrey,
  fontSize: 12.0,
  fontFamily: fontFamilyName,
  fontWeight: FontWeight.normal);

  TextStyle referenceTextStyleSubNormal = TextStyle(
  color: textBlackColor,
  fontSize: 14.0,
  fontFamily: fontFamilyName,
  fontWeight: FontWeight.normal);

TextStyle referenceTextStyleSubBold = TextStyle(
  color: darkBlack,
  fontSize: 12.0,
  fontFamily: fontFamilyName,
  fontWeight: FontWeight.bold);



TextStyle yesButtonTextStyle = TextStyle(
  color: whiteColor,
  fontSize: 14.0,
  fontFamily: fontFamilyName,
  fontWeight: FontWeight.w500);

TextStyle noButtonTextStyle = TextStyle(
  color: blackColor,
  fontSize: 14.0,
  fontFamily: fontFamilyName,
  fontWeight: FontWeight.w500);

TextStyle saveSettingsButtonTextStyle = TextStyle(
  color: yesButtonColor,
  fontSize: 16.0,
  fontFamily: fontFamilyName,
  fontWeight: FontWeight.w500);

TextStyle saveSettingsButtonTextStyleUnderline = TextStyle(
  color: yesButtonColor,
  decoration: TextDecoration.underline,
  fontSize: 16.0,
  fontFamily: fontFamilyName,
  fontWeight: FontWeight.w500);

TextStyle noButtonTextStyleBold = TextStyle(
  color: darkBlack,
  fontSize: 14.0,
  fontFamily: fontFamilyName,
  fontWeight: FontWeight.bold);


TextStyle underlineTextStyle = TextStyle(
  color: lightGrey,
  fontSize: 16.0,
  fontFamily: fontFamilyName,
  fontWeight: FontWeight.w500,
  decoration: TextDecoration.underline);

TextStyle underlineTextStyleSmall = TextStyle(
  color: lightGrey,
  fontSize: 14.0,
  fontFamily: fontFamilyName,
  fontWeight: FontWeight.w500,
  decoration: TextDecoration.underline);

TextStyle profileButtonStyle = TextStyle(
  color: visitDetailsColor,
  fontSize: 16.0,
  fontFamily: fontFamilyName,
  fontWeight: FontWeight.w500,
  decoration: TextDecoration.underline);



TextStyle whiteTextStyle = TextStyle(
  color: whiteColor,
  fontSize: 14.0,
  fontFamily: fontFamilyName,
  fontWeight: FontWeight.w600);

  TextStyle whiteTextStyleNoSize = TextStyle(
  color: whiteColor,
  fontFamily: fontFamilyName,
  fontWeight: FontWeight.w600);

TextStyle whiteTextStyleSmall = TextStyle(
  color: whiteColor,
  fontSize: 12.0,
  fontFamily: fontFamilyName,
  fontWeight: FontWeight.w700);

TextStyle blackTextStyle = TextStyle(
  color: darkTextColor,
  fontSize: 14.0,
  fontFamily: fontFamilyName,
  fontWeight: FontWeight.w600);

TextStyle blackTextStyleSmall = TextStyle(
  color: blackColor,
  fontSize: 12.0,
  fontFamily: fontFamilyName,
  fontWeight: FontWeight.w700,
  );


TextStyle signinTitleStyle = TextStyle(
    color: battleshipGrey,
    fontSize: 24.0,
    fontFamily: fontFamilyName,
    fontWeight: FontWeight.w300);

TextStyle textStyle = const TextStyle(
color: Color.fromRGBO(38, 38, 38, 1.0),
fontSize: 16.0,
fontFamily: fontFamilyName,
fontWeight: FontWeight.normal);

TextStyle placeholderStyle = TextStyle(
color: hintColor,
fontSize: 18.0,
fontFamily: fontFamilyName,
fontWeight: FontWeight.normal);

TextStyle questionStyle = TextStyle(
    color: darkIndigo,
    fontSize: 16.0,
    fontFamily: fontFamilyName,
    fontWeight: FontWeight.w700);

TextStyle textChoiceAnswerStyle = TextStyle(
  color: darkTextColor,
  fontSize: 14.0,
  fontFamily: fontFamilyName,
  fontWeight: FontWeight.w600);

TextStyle textChoiceAnswerStyleWhite = TextStyle(
  color: whiteColor,
  fontSize: 14.0,
  fontFamily: fontFamilyName,
  fontWeight: FontWeight.w600);


TextStyle textChoiceAnswerStyleNormal = TextStyle(
  color: darkTextColor,
  fontSize: 14.0,
  fontFamily: fontFamilyName,
  fontWeight: FontWeight.normal);

TextStyle textChoiceAnswerStyleNormalNoSize = TextStyle(
  color: darkTextColor,
  fontFamily: fontFamilyName,
  fontWeight: FontWeight.normal);

TextStyle singleChoicePlaceholderStyle = TextStyle(
  color: hintColor,
  fontSize: 14.0,
  fontFamily: fontFamilyName,
  fontWeight: FontWeight.normal);

TextStyle termsButtonStyle = TextStyle(
    color: yesButtonColor,
    fontSize: 18.0,
    fontFamily: fontFamilyName,
    fontWeight: FontWeight.normal);

TextStyle termsStyleBold = TextStyle(
    color: battleshipGrey,
    fontSize: 12.0,
    fontFamily: fontFamilyName,
    fontWeight: FontWeight.bold);

TextStyle termsStyleBoldUnderline = TextStyle(
    color: battleshipGrey,
    fontSize: 12.0,
    fontFamily: fontFamilyName,
    decoration: TextDecoration.underline,
    fontWeight: FontWeight.bold);

TextStyle termsStyle = TextStyle(
    color: battleshipGrey,
    fontSize: 8.0,
    fontFamily: fontFamilyName,
    fontWeight: FontWeight.normal);

TextStyle termsStyleBoldRedUnderline = TextStyle(
    color: Colors.red,
    fontSize: 12.0,
    fontFamily: fontFamilyName,
    decoration: TextDecoration.underline,
    fontWeight: FontWeight.bold);

TextStyle buttonTextStyle = const TextStyle(
    color: Color.fromRGBO(110, 120, 132, 1.0),
    fontSize: 14.0,
    fontFamily: fontFamilyName,
    fontWeight: FontWeight.bold,
    decoration: TextDecoration.none);