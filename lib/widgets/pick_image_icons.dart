import 'package:flutter/material.dart';

class Pick_image_icons extends StatelessWidget {
  late Function()? onPressed;
  late IconData icon;
  Pick_image_icons({Key? key, this.onPressed, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xff00203F),
          borderRadius: BorderRadius.circular(50.0)),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: const Color(0xffE7A44D),
        ),
      ),
    );
  }
}