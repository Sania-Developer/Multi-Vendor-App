import 'package:flutter/material.dart';

class Elevated_button extends StatelessWidget {
  late double width;
  late double height;
  late String text;
  late Function()? onPressed;
  Elevated_button({Key? key, required this.text, required this.width, required this.height, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(20.0),
        fixedSize: Size(width, height),
        textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        primary: const Color(0xffE7A44D),
        onPrimary: const Color(0xff00203F),
        elevation: 7,
        shadowColor: const Color(0xffE7A44D),
        side: const BorderSide(color: Color(0xff00203F), width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Center(child: Text(text,style: const TextStyle(color: Color(0xff00203F)),)),
    );
  }
}