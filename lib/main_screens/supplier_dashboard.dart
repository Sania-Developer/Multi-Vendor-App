import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_vendor/dashboard_components/balance.dart';
import 'package:multi_vendor/dashboard_components/manage_products.dart';
import 'package:multi_vendor/dashboard_components/orders.dart';
import 'package:multi_vendor/dashboard_components/statics.dart';
import 'package:multi_vendor/mini_screens/visit_store.dart';
import 'package:multi_vendor/widgets/alert_dialog.dart';
import '../widgets/appbar_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Dashboard_SS extends StatefulWidget {
  const Dashboard_SS({Key? key}) : super(key: key);

  @override
  _Dashboard_SSState createState() => _Dashboard_SSState();
}

class _Dashboard_SSState extends State<Dashboard_SS> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(
          title: 'Dashboard',
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () {
                my_alert_dialog.showMy_Dialog(
                    context: context,
                    title: 'Logout',
                    content: 'Are you sure to Logout',
                    tabNo: () {
                      Navigator.pop(context);
                    },
                    tabYes: () async {
                      final prefs = await SharedPreferences.getInstance();
                      final String? role = prefs.getString('role');
                      final success = await prefs.remove('role');
                      await FirebaseAuth.instance.signOut();
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(context,'/customer_home');
                    });
              },
              icon: const Icon(
                Icons.logout,
                color: Color(0xff00203F),
              )),
        ],
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Column(
          children: [
            dashboard_card(
              rotate: 3,
              text: 'Store',
              right: 0,
              image: 'my_store',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Visit_Stores(
                            supplier_id:
                                FirebaseAuth.instance.currentUser!.uid)));
              },
            ),
            dashboard_card(
              rotate: 9,
              text: 'Order',
              left: 0,
              image: 'orders',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Orders()));
              },
            ),
            dashboard_card(
              rotate: 3,
              text: 'Balance',
              right: 0,
              image: 'balance_card',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Balance_Screen()));
              },
            ),
            dashboard_card(
              rotate: 9,
              text: 'Statics',
              left: 0,
              image: 'statics',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Statics_Screen()));
              },
            ),
            dashboard_card(
              rotate: 3,
              text: 'Products',
              right: 0,
              image: 'products',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Manage_Product_Screen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class dashboard_card extends StatelessWidget {
  final int rotate;
  final double? left;
  final double? right;
  final String text;
  final String image;
  final Function()? onTap;
  const dashboard_card({
    Key? key,
    required this.rotate,
    required this.text,
    required this.image,
    this.left,
    this.right,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(25.0),
        child: GestureDetector(
          onTap: onTap,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            elevation: 10,
            child: Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                  color: const Color(0xffE7A44D),
                  borderRadius: BorderRadius.circular(25)),
              child: Stack(
                children: [
                  Center(child: Image(image: AssetImage('images/$image.png'))),
                  Positioned(
                      top: 0,
                      left: left,
                      bottom: 0,
                      right: right,
                      child: RotatedBox(
                        quarterTurns: rotate,
                        child: Container(
                            decoration: const BoxDecoration(
                                color: Color(0xff00203F),
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(25),
                                  bottomLeft: Radius.circular(25),
                                )),
                            child: Center(
                              child: Text(
                                text,
                                style: const TextStyle(
                                  color: Color(0xffE7A44D),
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )),
                      ))
                ],
              ),
            ),
          ),
        ));
  }
}


