import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:social_app/shared/styles/colors.dart';


ThemeData darktheme = ThemeData(
  textTheme: TextTheme(
    bodyText1: TextStyle(
        fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.white),
    subtitle1: TextStyle(
        fontSize: 14.0, fontWeight: FontWeight.w600, color: Colors.white,height: 1.3),    
  ),
  primarySwatch:defultColor,
  appBarTheme: AppBarTheme(
      titleSpacing: 20.0,
      titleTextStyle: TextStyle(
          color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold,
          fontFamily: 'jannah'),
      backwardsCompatibility: false,
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarColor: HexColor('333739')),
      backgroundColor: HexColor('333739'),
      elevation: 0.0,
      iconTheme: IconThemeData(color: Colors.white)),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: defultColor,
    backgroundColor: HexColor('333739'),
    unselectedItemColor: Colors.grey,
    elevation: 20.0,
  ),
  scaffoldBackgroundColor: HexColor('333739'),
  fontFamily: 'jannah'
);

ThemeData lightTheme = ThemeData(
  primarySwatch: defultColor,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: defultColor,
  ),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
      titleSpacing: 20.0,
      titleTextStyle: TextStyle(
          color: Colors.black, fontSize: 20.0,
          fontFamily: 'jannah',
           fontWeight: FontWeight.bold),
      backwardsCompatibility: false,
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark, statusBarColor: Colors.white),
      backgroundColor: Colors.white,
      elevation: 0.0,
      iconTheme: IconThemeData(color: Colors.black)),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: defultColor,
    backgroundColor: Colors.white,
    unselectedItemColor: Colors.grey,
    elevation: 20.0,
  ),
  textTheme: TextTheme(
    bodyText1: TextStyle(
        fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.black),
        subtitle1: TextStyle(
        fontSize: 14.0, fontWeight: FontWeight.w600, color: Colors.black,height: 1.3),
  ),
    fontFamily: 'jannah'
);
