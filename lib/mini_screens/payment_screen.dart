import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_vendor/widgets/elevated_button.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

import '../provider/cart_provider.dart';
import '../provider/stripe_id.dart';
import '../widgets/appbar_widgets.dart';

class Payment_Screen extends StatefulWidget {
  final String phone;
  final String name;
  final String address;
  const Payment_Screen({Key? key,required this.name,required this.phone,required this.address}) : super(key: key);

  @override
  _Payment_ScreenState createState() => _Payment_ScreenState();
}

class _Payment_ScreenState extends State<Payment_Screen> {
  int selectedvalue = 1;
  CollectionReference customer =
  FirebaseFirestore.instance.collection('customer');
  late String orderId;

  void showProgress() {
    ProgressDialog progressDialog = ProgressDialog(context: context);
    progressDialog.show(
        max: 100,
        msg: 'Please wait....',
        progressBgColor: const Color(0xff00203F),
        progressValueColor: const Color(0xffE7A44D));
  }

  @override
  Widget build(BuildContext context) {
    double total_price = context.watch<Cart>().totalprice;
    double total_paid = context.watch<Cart>().totalprice + 10.0;

    return FutureBuilder<DocumentSnapshot>(
        future: customer.doc(FirebaseAuth.instance.currentUser!.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Text("Document does not exist");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Material(
                child: Center(
                  child: CircularProgressIndicator(
                    color: Color(0xffEA4C4),
                  ),
                ));
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;
            return Material(
              color: Colors.white,
              child: SafeArea(
                child: Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    elevation: 0,
                    backgroundColor: Colors.white,
                    title: const AppBarTitle(
                      title: 'Payment',
                    ),
                    leading: const AppBarBackButton(),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 60),
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.14,
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                              color:  const Color(
                                  0xffE7A44D),
                              border: Border.all(color: const Color(
                                  0xff00203F) ),
                              borderRadius: BorderRadius.circular(14)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Total',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                      color: Color(0xff00203F)
                                      ),
                                    ),
                                    Text(
                                      '${total_paid.toStringAsFixed(2)} USD',
                                      style: const TextStyle(
                                          color: Color(0xff007C00),
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                const Divider(
                                  thickness: 2,
                                  color: Color(0xff00203F),
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Order total',
                                      style: TextStyle(
                                          color: Color(0xff00203F),
                                          fontSize: 14),
                                    ),
                                    Text(
                                      total_price.toStringAsFixed(2),
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xff00203F)
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text(
                                      'Shipping Cost',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xff00203F)
                                      ),
                                    ),
                                    Text(
                                      '10.0' + ('USD'),
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xff00203F)
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 40.0,
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                            border: Border.all(color: const Color(
                                0xffE7A44D),width: 1.5 ),
                            borderRadius: BorderRadius.circular(14)
                        ),
                                  child: RadioListTile(
                                    activeColor: const Color(0xff00203F),
                                    value: 1,
                                    groupValue: selectedvalue,
                                    title: const Text('Cash On Delivery',style: TextStyle(color: Color(0xff00203F)),),
                                    subtitle: const Text('Pay Cash At Home'),
                                    onChanged: (int? value) {
                                      setState(() {
                                        selectedvalue = value!;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: const Color(
                                          0xffE7A44D),width: 1.5 ),
                                      borderRadius: BorderRadius.circular(14)
                                  ),
                                  child: RadioListTile(
                                    activeColor: const Color(0xff00203F),
                                    value: 2,
                                    groupValue: selectedvalue,
                                    title:
                                    const Text('Pay via visa / Master Card',style: TextStyle(color: Color(0xff00203F)),),
                                    subtitle: Row(
                                      children: const [
                                        Icon(
                                          Icons.payment,
                                          color: Color(0xffE7A44D),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15.0),
                                          child: Icon(
                                            FontAwesomeIcons.ccMastercard,
                                            color: Color(0xffE7A44D),
                                          ),
                                        ),
                                        Icon(
                                          FontAwesomeIcons.ccVisa,
                                          color: Color(0xffE7A44D),
                                        ),
                                      ],
                                    ),
                                    onChanged: (int? value) {
                                      setState(() {
                                        selectedvalue = value!;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: const Color(
                                          0xffE7A44D),width: 1.5 ),
                                      borderRadius: BorderRadius.circular(14)
                                  ),
                                  child: RadioListTile(
                                    activeColor: const Color(0xff00203F),
                                    value: 3,
                                    groupValue: selectedvalue,
                                    title: const Text('Pay via Paypal',style: TextStyle(color: Color(0xff00203F)),),
                                    subtitle: Row(
                                      children: const [
                                        Icon(
                                          FontAwesomeIcons.ccPaypal,
                                          color: Color(0xffE7A44D),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Icon(
                                          FontAwesomeIcons.paypal,
                                          color: Color(0xffE7A44D),
                                        ),
                                      ],
                                    ),
                                    onChanged: (int? value) {
                                      setState(() {
                                        selectedvalue = value!;
                                      });
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  bottomSheet: Padding(
                    padding: const EdgeInsets.only(left: 25,right: 15,bottom: 8,top: 8),
                    child: Elevated_button(
                      text:
                      'Confirm Order ${total_price.toStringAsFixed(2)}',
                      width: 350,
                      height: 60,
                      onPressed: () async {
                        if (selectedvalue == 1) {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) => SizedBox(
                                height:
                                MediaQuery.of(context).size.height *
                                    0.3,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        'Pay At Home ${total_paid.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                            fontSize: 24,color: Color(0xff00203F)),
                                      ),
                                      Elevated_button(
                                        text:
                                        'Confirm ${total_paid.toStringAsFixed(2)}',
                                        width: 350,
                                        height: 60,
                                        onPressed: () async {
                                          showProgress();
                                          for (var item in context
                                              .read<Cart>()
                                              .getItem) {
                                            CollectionReference
                                            orderRef =
                                            FirebaseFirestore
                                                .instance
                                                .collection(
                                                'orders');
                                            orderId = const Uuid().v4();
                                            await orderRef
                                                .doc(orderId)
                                                .set({
                                              // Customer_Information

                                              'cid': data['cid'],
                                              'customer_name':
                                              widget.name,
                                              'email': data['email'],
                                              'address':
                                              widget.address,
                                              'phone': widget.phone,
                                              'profile_image':
                                              data['profile_image'],

                                              // Supplier_Information

                                              'sid': item.suppId,

                                              // Order_Product_Information

                                              'product_id':
                                              item.documentId,
                                              'product_name': item.name,
                                              'order_id': orderId,
                                              'order_image':
                                              item.imagesUrl.first,
                                              'order_qty': item.qty,
                                              'order_price': item.price,

                                              // Order_Delivery_Information

                                              'delivery_status':
                                              'preparing',
                                              'delivery_date': '',
                                              'order_date':
                                              DateTime.now(),
                                              'payment_status':
                                              'Cash On Delivery',
                                              'order_review': false,
                                            }).whenComplete(() {
                                              // Create a reference to the document the transaction will use
                                              DocumentReference
                                              documentReference =
                                              FirebaseFirestore
                                                  .instance
                                                  .collection(
                                                  'products')
                                                  .doc(item
                                                  .documentId);

                                              return FirebaseFirestore
                                                  .instance
                                                  .runTransaction(
                                                      (transaction) async {
                                                    // Get the document
                                                    DocumentSnapshot
                                                    snapshot2 =
                                                    await transaction.get(
                                                        documentReference);
                                                    transaction.update(
                                                        documentReference, {
                                                      'product_quantity':
                                                      snapshot2[
                                                      'product_quantity'] -
                                                          item.qty
                                                    });
                                                    print(item.qty);
                                                    // Return the new count
                                                  });
                                            });
                                          }
                                          await Future.delayed(
                                              const Duration(
                                                  microseconds:
                                                  100))
                                              .whenComplete(() {
                                            context
                                                .read<Cart>()
                                                .clearCart();
                                            Navigator.popUntil(
                                                context,
                                                ModalRoute.withName(
                                                    '/customer_home'));
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ));
                        } else if (selectedvalue == 2) {
                          int payment = total_paid.round();
                          int pay = payment * 100;

                          await makePayment(data, pay.toString());
                          print('Visa / Master Card');
                        } else if (selectedvalue == 3) {
                          print('Paypal');
                        }
                      },
                    ),
                  ),
                ),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  Map<String, dynamic>? payment_Intent_Data;
  Future<void> makePayment(dynamic data, String total) async {
    try {
      payment_Intent_Data = await creatPaymentIntent(total, 'USD');
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: payment_Intent_Data!['client_secret'],
              applePay: const PaymentSheetApplePay(merchantCountryCode: 'us'),
              googlePay: const PaymentSheetGooglePay(merchantCountryCode: 'us'),
              merchantDisplayName: 'ANNIE'));

      await displayPaymentSheet(data);
    } catch (e) {
      print(e.toString());
    }
  }

  creatPaymentIntent(String total, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': total,
        'currency': currency,
        'payment_method_types[]': 'card',
      };

      final response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer $stripeSecretkey',
            'content_type': 'application/x-www-form-urlencoded',
          });
      return jsonDecode(response.body);
    } catch (e) {
      print(e.toString());
    }
  }

  displayPaymentSheet(dynamic data) async {
    try {
      await Stripe.instance
          .presentPaymentSheet(
          parameters: PresentPaymentSheetParameters(
              clientSecret: payment_Intent_Data!['client_secret'],
              confirmPayment: true))
          .then((value) async {
        payment_Intent_Data = null;

        for (var item in context
            .read<Cart>()
            .getItem) {
          CollectionReference
          orderRef =
          FirebaseFirestore
              .instance
              .collection(
              'orders');
          orderId = const Uuid().v4();
          await orderRef
              .doc(orderId)
              .set({
            // Customer_Information

            'cid': data['cid'],
            'customer_name':
            data['name'],
            'email': data['email'],
            'address':
            data['address'],
            'phone': data['phone'],
            'profile_image':
            data['profile_image'],

            // Supplier_Information

            'sid': item.suppId,

            // Order_Product_Information

            'product_id':
            item.documentId,
            'product_name': item.name,
            'order_id': orderId,
            'order_image':
            item.imagesUrl.first,
            'order_qty': item.qty,
            'order_price': item.price,

            // Order_Delivery_Information

            'delivery_status':
            'preparing',
            'delivery_date': '',
            'order_date':
            DateTime.now(),
            'payment_status':
            'Paid online',
            'order_review': false,
          }).whenComplete(() {
            // Create a reference to the document the transaction will use
            DocumentReference
            documentReference =
            FirebaseFirestore
                .instance
                .collection(
                'products')
                .doc(item
                .documentId);

            return FirebaseFirestore
                .instance
                .runTransaction(
                    (transaction) async {
                  // Get the document
                  DocumentSnapshot snapshot2 = await transaction.get(documentReference);
                  transaction.update(documentReference, {
                    'product_quantity':
                    snapshot2[
                    'product_quantity'] -
                        item.qty
                  });
                  print(item.qty);
                  // Return the new count
                });
          });
        }
        await Future.delayed(
            const Duration(
                microseconds:
                100))
            .whenComplete(() {
          context
              .read<Cart>()
              .clearCart();
          Navigator.popUntil(
              context,
              ModalRoute.withName(
                  '/customer_home'));
        });

        print('paid');
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
