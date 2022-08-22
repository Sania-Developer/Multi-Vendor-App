import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_vendor/widgets/appbar_widgets.dart';
import 'package:multi_vendor/widgets/elevated_button.dart';


class Balance_Screen extends StatelessWidget {
  const Balance_Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('sid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Material(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        double total_balance = 0.0;
        for (var total in snapshot.data!.docs) {
          total_balance += total['order_qty'] * total['order_price'];
        }

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: const AppBarTitle(
              title: 'Balance',
            ),
            leading: const AppBarBackButton(),
          ),
          body: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            reverse: true,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(
                    image: AssetImage('images/balance_image.png'),
                  ),
                  const Text(
                    'Total Balance:',
                    style: TextStyle(color: Color(0xff00203F), fontSize: 24),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color: const Color(0xff00203F),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: const Color(0xffE7A44D),width: 2)
                      ),
                        child: Center(
                          child: Text(
                      '\$ ' + total_balance.toString(),
                      style:
                            const TextStyle(color: Color(0xffE7A44D), fontSize: 40,fontWeight: FontWeight.bold,),
                    ),
                        )),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  Elevated_button(text: 'Get My Money', width: 350, height: 60,onPressed: (){

                  },),
                  const SizedBox(
                    height: 60,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}