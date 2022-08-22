import 'package:flutter/material.dart';
import 'package:gradient_borders/input_borders/gradient_outline_input_border.dart';

class Auth_Button_Label extends StatelessWidget {
  final String auth_btn_label;
  final Function() onPressed;

  Auth_Button_Label({required this.auth_btn_label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Material(
          color: const Color(0xffF07470),
          borderRadius: BorderRadius.circular(30),
          child: MaterialButton(
            minWidth: double.infinity,
            onPressed: onPressed,
            child:  Padding(
              padding: const  EdgeInsets.all(8.0),
              child: Text(auth_btn_label,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 22),),
            ),
          )),
    );
  }
}

class HaveAccount extends StatelessWidget {
  final String have_account;
  final String action_label;
  final Function() onPressed;

  HaveAccount({required this.have_account, required this.action_label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          have_account,
          style:
          const TextStyle(fontSize: 16, fontStyle: FontStyle.italic,color: Color(0xffE7A44D)),
        ),
        TextButton(
            onPressed: onPressed,
            child: Text(
              action_label,
              style: const TextStyle(
                  color: Color(0xff00203F),
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                  fontSize: 20),
            ))
      ],
    );
  }
}

class AuthHeaderLabel extends StatelessWidget {
  final String auth_header_label;

  const AuthHeaderLabel({required this.auth_header_label});

  @override
  Widget build(BuildContext context) {
    return Text(
      auth_header_label,
      style: const TextStyle(
          color: Color(0xff00203F),
          fontSize: 32,
          fontWeight: FontWeight.w700),
    );
  }
}

var decoration_Text_Field = InputDecoration(
  fillColor: Colors.white,
  hintText: 'Enter your Full Name',
  label: const Text('Name',style: TextStyle(
      color: Color(0xff00203F)
  ),),
  labelStyle: const TextStyle(color: Color(0xff00203F)),
  border: const GradientOutlineInputBorder(
      gradient: LinearGradient(colors: [Color(0xff00203F),Color(0xffE7A44D)])
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: const BorderSide(
        color: Color(0xffE7A44D), width: 1),
    borderRadius: BorderRadius.circular(10),
  ),
  focusedBorder: const GradientOutlineInputBorder(
      width: 2,
      gradient: LinearGradient(colors: [Color(0xff00203F),Color(0xffE7A44D)])
  ),
);




extension EmailValidator on String{
  bool isValidEmail(){
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}
