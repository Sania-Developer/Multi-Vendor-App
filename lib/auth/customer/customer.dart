import 'package:flutter/material.dart';
import 'package:multi_vendor/auth/customer/customer_signin.dart';
import 'package:multi_vendor/auth/customer/customer_signup.dart';
import 'package:multi_vendor/widgets/appbar_widgets.dart';
import '../repeated_tab.dart';

class Customer extends StatefulWidget {
  const Customer({Key? key}) : super(key: key);

  @override
  _CustomerState createState() => _CustomerState();
}

class _CustomerState extends State<Customer> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.blueGrey.shade100.withOpacity(0.5),
        appBar: AppBar(
          title: const AppBarTitle(title: 'Become a Buyer',),
          leading: OutlinedButton(
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
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          bottom: TabBar(
            indicatorColor: const Color(0xffE7A44D),
            isScrollable: true,
            tabs: [
              RepeateTab(
                label: 'Sign Up',
              ),
              RepeateTab(
                label: 'Sign In',
              ),

            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Customer_Signup_Screen(),
            Customer_LogIn_Screen(),
          ],
        ),
      ),
    );
  }
}


