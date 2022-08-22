import 'package:flutter/material.dart';

class MyMessageHandler{
  static void showSnackBar(String message,var _scaffoldkey){
    _scaffoldkey.currentState!.hideCurrentSnackBar();
    _scaffoldkey.currentState!.showSnackBar( SnackBar(
      duration:  Duration(seconds: 2),
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
      backgroundColor: const Color(0xffE7A44D),
    ));
  }
}