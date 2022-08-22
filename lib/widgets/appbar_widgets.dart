import 'package:flutter/material.dart';

class AppBarTitle extends StatelessWidget {
  const AppBarTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
          color: Color(0xff00203F),
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
          fontSize: 24),
    );
  }
}

class AppBarBackButton extends StatelessWidget {
  const AppBarBackButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        Navigator.pop(context);
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(15.0),
        primary: Colors.white,
        onPrimary: const Color(0xffE7A44D),
        shadowColor: Colors.grey,
      ),
      child: const Icon(
        Icons.arrow_back_ios_new,
      ),
    );
  }
}
