import 'package:flutter/material.dart';
import 'package:multi_vendor/widgets/appbar_widgets.dart';

class Edit_Profile_Screen extends StatelessWidget {
  const Edit_Profile_Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const AppBarTitle(
          title: 'Edit Profile',
        ),
        leading: const AppBarBackButton(),
      ),
    );
  }
}
