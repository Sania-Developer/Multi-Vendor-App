import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_vendor/mini_screens/payment_screen.dart';
import 'package:multi_vendor/widgets/elevated_button.dart';
import 'package:provider/provider.dart';

import '../customer_screens/address_book.dart';
import '../provider/cart_provider.dart';
import '../widgets/appbar_widgets.dart';
import 'add_address.dart';

class Place_Order_Screen extends StatefulWidget {
  const Place_Order_Screen({Key? key}) : super(key: key);

  @override
  _Place_Order_ScreenState createState() => _Place_Order_ScreenState();
}

class _Place_Order_ScreenState extends State<Place_Order_Screen> {
  CollectionReference customer =
      FirebaseFirestore.instance.collection('customer');
  final Stream<QuerySnapshot> addressStream = FirebaseFirestore.instance
      .collection('customer')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('address')
      .where('default', isEqualTo: true)
      .limit(1)
      .snapshots();
  late String name;
  late String address;
  late String phone;

  @override
  Widget build(BuildContext context) {
    double total_price = context.watch<Cart>().totalprice;

    return StreamBuilder<QuerySnapshot>(
        stream: addressStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Material(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          return Material(
            color: Colors.grey.shade200,
            child: SafeArea(
              child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  title: const AppBarTitle(
                    title: 'Place Order',
                  ),
                  leading: const AppBarBackButton(),
                ),
                body: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 60),
                  child: Column(
                    children: [
                      snapshot.data!.docs.isEmpty
                          ? GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const Add_Address()));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: const Color(
                                        0xff00203F) ),
                                    borderRadius: BorderRadius.circular(14)
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Image(image: AssetImage('images/empty_screen_image.png'),width: 150,height: 150,),
                                    Column(
                                      children: const [
                                         Text(
                                          'No Result',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 1.5),
                                        ),
                                        Text(
                                          'You have not set an \naddress yet',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    )

                                  ],
                                ),
                              ))
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                var customer = snapshot.data!.docs[index];
                                name = customer['first_name'] + ['last_name'].toString();
                                phone = customer['phone'];
                                address = customer['country'] + ' - ' + ['state'].toString() + ' - ' + ['city'].toString();
                                return Stack(
                                  children: [
                                    Container(
                                      height: MediaQuery.of(context).size.height * 0.14,
                                      width: MediaQuery.of(context).size.width * 0.9,
                                      decoration: BoxDecoration(
                                          color: const Color(0xffE7A44D),
                                          border: Border.all(
                                              color:
                                                  const Color(0xff00203F)),
                                          borderRadius:
                                              BorderRadius.circular(14)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 16),
                                        child: ListTile(
                                          title: SizedBox(
                                            height: 60.0,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${customer['first_name']} - ${customer['last_name']}',
                                                  style: const TextStyle(
                                                      color: Color(
                                                          0xff00203F)),
                                                ),
                                                Text(
                                                  '+${customer['phone']}',
                                                  style: const TextStyle(
                                                      color: Color(
                                                          0xff00203F)),
                                                )
                                              ],
                                            ),
                                          ),
                                          subtitle: SizedBox(
                                            height: 40.0,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'city/state:  ${customer['city']} ${customer['state']}',
                                                  style: const TextStyle(
                                                      color: Color(
                                                          0xff00203F)),
                                                ),
                                                Text(
                                                  'country:      ${customer['country']}',
                                                  style: const TextStyle(
                                                      color: Color(
                                                          0xff00203F)),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                        top: 0,
                                        right: 8,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                    const Address_Book()));
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context).size.width * 0.2,
                                            decoration: const BoxDecoration(
                                                color: Color(0xff00203F),
                                                borderRadius: BorderRadius.only(
                                                    bottomLeft:
                                                    Radius.circular(25))),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0,
                                                  left: 8,
                                                  right: 8,
                                                  bottom: 8),
                                              child: Row(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: const [
                                                  Icon(
                                                    Icons.edit,
                                                    color: Colors.white,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    'Edit',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )),
                                  ],
                                );
                              }),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child:
                              Consumer<Cart>(builder: (context, cart, child) {
                            return ListView.builder(
                                itemCount: cart.count,
                                itemBuilder: (context, index) {
                                  final order = cart.getItem[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Container(
                                      height: 100,
                                      decoration: BoxDecoration(

                                          border: Border.all(color: const Color(
                                              0xff00203F) ),
                                          borderRadius: BorderRadius.circular(14)
                                      ),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(15),
                                                        bottomLeft:
                                                            Radius.circular(
                                                                15)),
                                                child: SizedBox(
                                                    width: 100,
                                                    height: 100,
                                                    child: Image.network(order
                                                        .imagesUrl.first))),
                                          ),
                                          Flexible(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  order.name,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                           Color(0xff00203F)),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 4,
                                                      horizontal: 12),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        order.price.toString(),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors
                                                                .red),
                                                      ),
                                                      Text(
                                                        'x ${order.qty}',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          color:
                                                          Color(0xff00203F)),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                bottomSheet: Padding(
                  padding: const EdgeInsets.only(left: 25,right: 15,bottom: 8,top: 8),
                  child: Elevated_button(
                    text: 'Confirm Order ${total_price.toStringAsFixed(2)}',
                    width: 350,
                    height: 60,
                    onPressed: snapshot.data!.docs.isEmpty
                        ? () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const Address_Book()));
                          }
                        : () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Payment_Screen(
                                          name: name,
                                          phone: phone,
                                          address: address,
                                        )));
                          },
                  ),
                ),
              ),
            ),
          );
        });
  }
}
