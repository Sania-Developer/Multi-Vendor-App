import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_vendor/widgets/appbar_widgets.dart';

class Statics_Screen extends StatelessWidget {
  const Statics_Screen({Key? key}) : super(key: key);

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

        num itemCount = 0;
        for (var item in snapshot.data!.docs) {
          itemCount += item['order_qty'];
        }
        double total_balance = 0.0;
        for (var total in snapshot.data!.docs) {
          total_balance += total['order_qty'] * total['order_price'];
        }

        return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              title: const AppBarTitle(
                title: 'Statics',
              ),
              leading: const AppBarBackButton(),
            ),
            body: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.3,
                      decoration: const BoxDecoration(
                        color: Color(0xff00203F),
                        // borderRadius:
                        //     BorderRadius.only(bottomLeft: Radius.circular(100))
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.show_chart,
                            size: 45,
                            color: Color(0xffE7A44D),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Statistics',
                            style: TextStyle(
                                color: Color(0xffE7A44D),
                                fontSize: 40,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1),
                          ),
                        ],
                      ),
                    ),
                    Statics(text1: 'Total Products', text2: itemCount.toString(), text3: 'You have ${itemCount.toString()} Products', icon: FontAwesomeIcons.clipboardList),
                    Statics(text1: 'Products Sold', text2: snapshot.data!.docs.length.toString(), text3: 'You have ${itemCount.toString()} Products Sold', icon: Icons.sell),
                  ],
                ),
                Positioned(
                    top: 200,
                    left: 40,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.1,
                      decoration: BoxDecoration(
                          color: const Color(0xffE7A44D),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                              color: const Color(0xff00203F), width: 2)),
                      child: Center(
                        child: Text(
                          '\$' + total_balance.toString(),
                          style: const TextStyle(
                              color: Color(0xff00203F),
                              fontSize: 32,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )),
              ],
            ));
      },
    );
  }
}

class Statics extends StatelessWidget {
  final String text1,text2,text3;
  IconData icon;


  Statics({Key? key , required this.text1, required this.text2, required this.text3, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0),
      child: Column(
        children: [
          Text(
            text1 ,
            style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                color: Color(0xff00203F),
                letterSpacing: 1),
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.08,
            decoration: BoxDecoration(
              border: Border.all(
                  color: const Color(0xff00203F), width: 2),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(25),
                bottomLeft: Radius.circular(25),
              ),
              color: const Color(0xd8e7a44d),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: const Color(0xff00203F),
                  size: 40,
                ),
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(
                        0xab00203f))
                  ),
                    child: Text(
                  text2.toString(),
                  style: const TextStyle(
                      color: Color(0xff00203F),
                      fontWeight: FontWeight.w600,
                      fontSize: 38),
                )),
                Text(
                  text3,
                  style: const TextStyle(
                      color: Color(0xff00203F), fontSize: 18),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
