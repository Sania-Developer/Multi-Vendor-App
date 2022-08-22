import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:multi_vendor/main_screens/profile.dart';
import 'package:multi_vendor/main_screens/store_screen.dart';
import 'package:provider/provider.dart';
import '../provider/cart_provider.dart';
import 'cart_screen.dart';
import 'category.dart';
import 'home.dart';

class Customer_Home_Screen extends StatefulWidget {
  const Customer_Home_Screen({Key? key}) : super(key: key);

  @override
  _Customer_Home_ScreenState createState() => _Customer_Home_ScreenState();
}

class _Customer_Home_ScreenState extends State<Customer_Home_Screen> {
  int _selectedindex = 0;
  final List<Widget> _tabs = [
    const Home_Screen(),
    const Category_Screen(),
    const Store_Screen(),
    const Cart_Screen(),
    const Profile_Screen(),
  ];
  @override
  Widget build(BuildContext context) {
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
                showBadge: context.read<Cart>().getItem.isEmpty ? false : true,
                badgeColor: const Color(0xff00203F),
                badgeContent: Text(context.watch<Cart>().getItem.length.toString(),style: const TextStyle(color: Color(0xffE7A44D)),),
                child: const Icon(Icons.shopping_cart)),
            label: 'Cart',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index){
          setState(() {
            _selectedindex = index;
          });
        },
      ),
    );
  }
}
