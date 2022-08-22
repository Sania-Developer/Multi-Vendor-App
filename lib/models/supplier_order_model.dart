import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class Supplier_Order_Model extends StatelessWidget {
  final dynamic order;
  const Supplier_Order_Model({Key? key, required this.order}) : super(key: key);

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
                      image: NetworkImage(order['order_image']),
                    ),
                  ),
                ),
                Flexible(
                    child: Column(
                      children: [
                        Text(
                          order['product_name'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff00203F)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                ('\$ ') + (order['order_price'].toStringAsFixed(2)),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red),
                              ),
                              Text(
                                ('x ') + (order['order_qty'].toString()),
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
          subtitle:  Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('See More ..',style: TextStyle(
                    color: Color(0xff00203F)),),
                Text(order['delivery_status'],style: const TextStyle(
                    color: Color(0xff00203F)))
              ]
          ),
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0x92e7a44d),
                  borderRadius: BorderRadius.only(bottomRight:Radius.circular(15),bottomLeft:Radius.circular(15),),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ('Name:  ') + (order['customer_name']),
                style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Color(0xff00203F),
                    )),
                    Text(
                      ('Phone No:  ') + (order['phone']),
                      style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Color(0xff00203F)),
                    ),
                    Text(
                      ('Email Address:  ') + (order['email']),
                      style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Color(0xff00203F)),
                    ),
                    Text(
                      ('Address:  ') + (order['address']),
                      style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Color(0xff00203F)),
                    ),
                    Row(
                      children: [
                        const Text(
                          ('Payment Status:  '),
                          style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Color(0xff00203F)),
                        ),
                        Text(
                          (order['payment_status']),
                          style: const TextStyle(
                              fontSize: 15,
                              color: Colors.red,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          ('Delivery Status:  '),
                          style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Color(0xff00203F)),
                        ),
                        Text(
                          (order['delivery_status']),
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff007C00)),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          ('Order Date:  '),
                          style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Color(0xff00203F)),
                        ),
                        Text(
                          (DateFormat('dd-MM-yyyy')
                              .format(order['order_date'].toDate())
                              .toString()),
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff007C00)),
                        ),
                      ],
                    ),
                    order['delivery_status'] == 'delivered' ? const Text('This item has been already delivered') : Row(children: [
                      const Text(
                        ('Change Delivery Status to:  '),
                        style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Color(0xff00203F)),
                      ),
                      order['delivery_status'] == 'preparing'
                          ? TextButton(
                          onPressed: () {

                            DatePicker.showDatePicker(context,
                                minTime: DateTime.now(),
                                maxTime: DateTime.now().add(const Duration(days: 365)),
                                onConfirm: (date) async{
                                  await FirebaseFirestore.instance.collection('orders').doc(order['order_id']).update(
                                      {
                                        'delivery_status': 'shipping',
                                        'delivery_date': date,
                                      });
                                }
                            );

                          }, child: const Text('shipping ?',style: TextStyle(color: Colors.red),))
                          : TextButton(
                          onPressed: () async{
                            await FirebaseFirestore.instance.collection('orders').doc(order['order_id']).update(
                                {
                                  'delivery_status' : 'delivered'
                                });
                          }, child: const Text('delivered ?',style: TextStyle(color: Colors.red),))
                    ]),
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
