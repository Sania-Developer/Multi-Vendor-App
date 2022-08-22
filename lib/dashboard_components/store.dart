import 'package:flutter/material.dart';
import 'package:multi_vendor/widgets/appbar_widgets.dart';

class My_Store_Screen extends StatelessWidget {
  const My_Store_Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const AppBarTitle(
          title: 'Store',
        ),
        leading: const AppBarBackButton(),
      ),
    );
  }
}
