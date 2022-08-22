import 'package:flutter/material.dart';

class RepeateTab extends StatelessWidget {
  late String label;

  RepeateTab({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Container(
        width: 100,
        child: Center(
          child: Text(
            label,
            style: const TextStyle(color: Color(0xff00203F)),
          ),
        ),
      ),
    );
  }
}