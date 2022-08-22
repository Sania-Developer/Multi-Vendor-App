import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_vendor/auth/customer/customer.dart';
import 'package:multi_vendor/auth/supplier/supplier.dart';
import 'package:multi_vendor/widgets/alert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/update_password.dart';
import '../customer_screens/address_book.dart';
import '../customer_screens/customer_order.dart';
import '../customer_screens/wishlist_screen.dart';
import '../widgets/appbar_widgets.dart';
import '../widgets/elevated_button.dart';
import 'cart_screen.dart';

class Profile_Screen extends StatefulWidget {
  const Profile_Screen({Key? key}) : super(key: key);

  @override
  _Profile_ScreenState createState() => _Profile_ScreenState();
}

class _Profile_ScreenState extends State<Profile_Screen> {
  String? documentId;
  CollectionReference customer =
      FirebaseFirestore.instance.collection('customer');
  CollectionReference anonymous =
      FirebaseFirestore.instance.collection('anonymous');

  @override
  void initState() {
    // TODO: implement initState
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        setState(() {
          documentId = user.uid;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return documentId == null
        ? SafeArea(
            child: Scaffold(
              body: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Elevated_button(
                        width: 200,
                        height: 60,
                        text: ' Become a Buyer ',
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Customer()));
                        }),
                    const SizedBox(
                      height: 40,
                      width: 230,
                      child: Divider(
                        thickness: 2,
                      ),
                    ),
                    Elevated_button(
                        width: 200,
                        height: 60,
                        text: ' Become a Seller ',
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Supplier()));
                        }),
                  ],
                ),
              ),
            ),
          )
        : FutureBuilder<DocumentSnapshot>(
            future: FirebaseAuth.instance.currentUser!.isAnonymous
                ? anonymous.doc(documentId).get()
                : customer.doc(documentId).get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text("Something went wrong");
              }

              if (snapshot.hasData && !snapshot.data!.exists) {
                return const Text("Document does not exist");
              }

              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;
                return Scaffold(
                  backgroundColor: Colors.white,
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 100.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                                  radius: 50.0,
                                                  backgroundImage: NetworkImage(
                                                      data['profile_image']),
                                                  //   data['profile_image']
                                                ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 10,
                                            ),
                                            child: Text(
                                              data['name'].toUpperCase(),
                                              style: const TextStyle(
                                                  color: Color(0xff00203F),
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15),
                                            ),
                                          ),
                                          Text( data['email'],
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12),
                                          )
                                        ],
                                      ),
                                    ),

                            Padding(
                              padding: const EdgeInsets.only(top: 50.0),
                              child: Column(
                                children: [
                                  Repeated_tile(
                                    title: 'My Orders',
                                    icon: Icons.shop_2_outlined,
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                              const Customer_Order_Screen()));
                                    },
                                  ),
                                  Repeated_tile(
                                    title: 'Cart',
                                    icon: Icons.shopping_cart,
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Cart_Screen(
                                                    leading_back:
                                                        AppBarBackButton(),
                                                  )));
                                    },
                                  ),
                                  Repeated_tile(
                                    title: 'Wishlist',
                                    icon: Icons.bookmark,
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Wishllist_Screen()));
                                    },
                                  ),
                                  Repeated_tile(
                                    title: 'Address',
                                    icon: FontAwesomeIcons.addressBook,
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder:
                                                  (context) =>
                                                  const Address_Book()));
                                    },
                                  ),


                                  Repeated_tile(
                                    title: 'Change Password',
                                    icon: Icons.lock,
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Update_Password()));
                                    },
                                  ),

                                  Repeated_tile(
                                    title: 'Edit Profile',
                                    icon: Icons.edit,
                                    onPressed: () {},
                                  ),

                                  Repeated_tile(
                                    title: 'Log Out',
                                    icon: Icons.logout,
                                    onPressed: () {
                                      my_alert_dialog.showMy_Dialog(
                                          context: context,
                                          title: 'Logout',
                                          content:
                                          'Are you sure to Logout',
                                          tabNo: () {
                                            Navigator.pop(context);
                                          },
                                          tabYes: () async {
                                            final prefs = await SharedPreferences.getInstance();
                                            final String? role = prefs.getString('role');
                                            final success = await prefs.remove('role');
                                            await FirebaseAuth
                                                .instance
                                                .signOut();
                                            await Future.delayed(
                                                const Duration(
                                                    microseconds:
                                                    100))
                                                .whenComplete(() =>
                                                Navigator.pop(
                                                    context));
                                          });
                                    },
                                  ),

                                ],
                              ),
                            )

                      ],
                    ),
                  ),
                );
              }
              return const Center(
                  child: CircularProgressIndicator(
                color: Color(0xff00203F),
              ));
            },
          );
  }

  String user_address(dynamic data) {
    if (FirebaseAuth.instance.currentUser!.isAnonymous == true) {
      return 'example: New Jersey-USa';
    } else if (FirebaseAuth.instance.currentUser!.isAnonymous == false &&
        data['address'] == '') {
      return 'Set Your Address';
    }
    return data['address'];
  }
}


class Repeated_tile extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData icon;
  final Function()? onPressed;

  Repeated_tile(
      {required this.title,
      this.subTitle = '',
      required this.icon,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Container(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: GestureDetector(
          onTap: onPressed,
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xffE7A44D),
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Icon(
                      icon,
                      color: const Color(0xff00203F),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 40,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Column(
                  children: [
                    Text(
                      title,
                      style:
                          const TextStyle(color: Color(0xff00203F), fontSize: 20),
                    ),
                    Text(
                      subTitle,
                      style:
                          const TextStyle(color: Color(0xff00203F), fontSize: 13),
                    )
                  ],
                ),
              ),
              const Spacer(),
              const Icon(
                    FontAwesomeIcons.chevronRight,
                    color: Color(0xffE7A44D),
                  )
            ],
          ),
        ),
      ),
    );
  }
}

