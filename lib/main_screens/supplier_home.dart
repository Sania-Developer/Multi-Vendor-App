import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_vendor/main_screens/category.dart';
import 'package:multi_vendor/main_screens/home.dart';
import 'package:multi_vendor/main_screens/store_screen.dart';
import 'package:multi_vendor/main_screens/supplier_dashboard.dart';
import 'package:multi_vendor/main_screens/upload_product.dart';

class Supplier_Home_Screen extends StatefulWidget {
  const Supplier_Home_Screen({Key? key}) : super(key: key);

  @override
  _Supplier_Home_ScreenState createState() => _Supplier_Home_ScreenState();
}

class _Supplier_Home_ScreenState extends State<Supplier_Home_Screen> {
  int _selectedindex = 0;
  final List<Widget> _tabs = const[
    Home_Screen(),
    Category_Screen(),
    Store_Screen(),
    Dashboard_SS(),
    Upload_Product_Screen()
  ];
  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('orders').where('sid' , isEqualTo: FirebaseAuth.instance.currentUser!.uid).where('delivery_status' , isEqualTo: 'preparing').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Material(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(
          body: _tabs[_selectedindex],
          bottomNavigationBar: BottomNavigationBar(
            elevation: 0,
            type: BottomNavigationBarType.shifting,
            selectedItemColor: const Color(0xff00203F),
            unselectedItemColor: const Color(0xffE7A44D),
            currentIndex: _selectedindex,
            items:  [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.shop),
                label: 'Stores',
              ),
              BottomNavigationBarItem(

                icon: Badge(
                    showBadge: snapshot.data!.docs.isEmpty ? false : true,
                    badgeColor: const Color(0xfffffbd5),
                    badgeContent: Text(snapshot.data!.docs.length.toString()),
                    child: const Icon(Icons.dashboard)),
                label: 'Dashboard',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.upload),
                label: 'Upload',
              ),
            ],
            onTap: (index){
              setState(() {
                _selectedindex = index;
              });
            },
          ),
        );
        //
      },
    );
  }
}
