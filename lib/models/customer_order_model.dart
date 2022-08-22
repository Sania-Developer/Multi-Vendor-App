import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:multi_vendor/widgets/elevated_button.dart';
import '../widgets/auth_widgets.dart';

class Customer_Order_Model extends StatefulWidget {
  final dynamic order;
  const Customer_Order_Model({Key? key ,required this.order}) : super(key: key);

  @override
  State<Customer_Order_Model> createState() => _Customer_Order_ModelState();
}

class _Customer_Order_ModelState extends State<Customer_Order_Model> {

  late double rate;
  late String comment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0xff00203F))),
        child: ExpansionTile(
          title: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.13,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Container(
                    constraints:
                    const BoxConstraints(maxWidth: 80, maxHeight: 80),
                    child: Image(
                      image: NetworkImage(widget.order['order_image']),
                    ),
                  ),
                ),
                Flexible(
                    child: Column(
                      children: [
                        Text(
                          widget.order['product_name'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff00203F)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                ('\$ ') +
                                    (widget.order['order_price']
                                        .toStringAsFixed(2)),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red),
                              ),
                              Text(
                                ('x ') +
                                    (widget.order['order_qty'].toString()),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xffE7A44D)),
                              ),
                            ],
                          ),
                        )
                      ],
                    ))
              ],
            ),
          ),
          subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('See More ..',style: TextStyle(
                    color: Color(0xff00203F)),),
                Text(widget.order['delivery_status'],style: const TextStyle(
                    color: Color(0xff00203F)))
              ]
                ),
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: widget.order['delivery_status'] == 'delivered' ? Colors.brown.withOpacity(0.2) : const Color(0x92e7a44d
                ),
                borderRadius: const BorderRadius.only(bottomRight:Radius.circular(15),bottomLeft:Radius.circular(15),),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ('Name:  ') + (widget.order['customer_name']),
                      style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Color(0xff00203F)),
                    ),
                    Text(
                      ('Phone No:  ') + (widget.order['phone']),
                      style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Color(0xff00203F)),
                    ),
                    Text(
                      ('Email Address:  ') + (widget.order['email']),
                      style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Color(0xff00203F)),
                    ),
                    Text(
                      ('Address:  ') + (widget.order['address']),
                      style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Color(0xff00203F)),
                    ),
                    Row(
                      children: [
                        const Text(
                          ('Payment Status:  '),
                          style:  TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Color(0xff00203F)),
                        ),
                        Text(
                          (widget.order['payment_status']),
                          style: const TextStyle(fontSize: 15,color: Colors.red , fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          ('Delivery Status:  ') ,
                          style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),
                        ),
                        Text(
                          (widget.order['delivery_status']),
                          style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Color(0xff007C00)),
                        ),
                      ],
                    ),
                    widget.order['delivery_status'] == 'shipping'
                        ? Text(
                      ('Estimated Delivery Date:  ') +
                          (DateFormat('dd-MM-yyyy').format(widget.order['delivery_date'].toDate()).toString()),
                      style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Color(0xffE7A44D)),
                    ) : const Text(''),
                    widget.order['delivery_status'] == 'delivered' &&
                        widget.order['order_review'] == false
                        ? TextButton(
                        onPressed: () {
                          showDialog(context: context, builder: (context) => Material(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20 , vertical: 150),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    RatingBar.builder(
                                        initialRating: 1,
                                        minRating: 1,
                                        allowHalfRating: true,
                                        itemBuilder: (context , _){
                                          return const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          );
                                        }, onRatingUpdate: (value){
                                      rate = value;
                                      print(rate);
                                    }),
                                    TextFormField(
                                      // controller: _nameControllertroller,
                                      decoration: decoration_Text_Field.copyWith(
                                          label: const Text('Write your Review'),
                                          hintText: 'Review'),
                                      onChanged: (value){
                                        comment = value;
                                      },
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Elevated_button(text: 'cancel', width: 200,height: 60,onPressed: (){
                                          Navigator.pop(context);
                                        },),
                                        Elevated_button(text: 'cancel', width: 200,height: 60,onPressed: ()async{
                                          DocumentReference documentReference = FirebaseFirestore.instance.collection('orders').doc(widget.order['order_id']);

                                          CollectionReference collRef = FirebaseFirestore.instance.collection('products').doc(widget.order['product_id']).collection('reviews');
                                          await collRef.doc(FirebaseAuth.instance.currentUser!.uid).set({
                                            'name' : widget.order['customer_name'],
                                            'email' : widget.order['email'],
                                            'rate' : rate,
                                            'comment' : comment,
                                            'profile_image': widget.order['profile_image']
                                          }).whenComplete(() => FirebaseFirestore.instance.runTransaction((transaction) async{
                                            transaction.update(documentReference, {
                                              'order_review' : true,
                                            });
                                          }
                                          ));
                                          await Future.delayed(const Duration(microseconds: 100)).whenComplete(() => Navigator.pop(context));
                                        },)
                                      ],
                                    )

                                  ],
                                ),
                              )
                          ));
                        },
                        child: const Text('Write Review'))
                        : const Text(''),
                    widget.order['delivery_status'] == 'delivered' &&
                        widget.order['order_review'] == true
                        ? Row(
                      children: const [
                        Icon(
                          Icons.check,
                          color: Colors.green,
                        ),
                        Text(
                          'Review Added',
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.green),
                        )
                      ],
                    ) : const Text(''),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
