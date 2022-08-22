import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../mini_screens/edit_product.dart';
import '../mini_screens/product_detail_screen.dart';


class Product_Model extends StatefulWidget {
  final dynamic products;

  Product_Model({required this.products});

  @override
  State<Product_Model> createState() => _Product_ModelState();
}

class _Product_ModelState extends State<Product_Model> {

  @override
  Widget build(BuildContext context) {
    var onSale = widget.products['discount'];

    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => Product_Detail_Screen(widget.products)));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
            children: [
              Container(
                width: 220,
                height: 400,
                decoration: BoxDecoration(
                  color: const Color(0xffDEDFE6),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                  ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(15.0),
                          topLeft: Radius.circular(15.0)),
                      child: Container(
                        width: double.maxFinite,
                        height: 150,
                        child: Image(
                          image: NetworkImage(widget.products['product_image'][0]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8,8,0),
                      child: Container(
                        width: 200,
                        height: 115,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)
                        ),
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(8, 15, 0, 0),
                                    child: Text(
                                      widget.products['category'],
                                      style: const TextStyle(
                                          color: Color(0xffE7A44D),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                      Padding(
                                padding: const EdgeInsets.fromLTRB(8, 5, 5, 0),
                                child: Text(
                                      widget.products['porduct_name'],
                                      maxLines: 1,
                                      style: const TextStyle(
                                          color: Color(0xff00203F),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                      ),
                                    const SizedBox(height: 5.0,),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0,right: 0,top: 18),
                                      child: Row(
                                        children: [
                                          const Text(
                                            '\$ ',
                                            style: TextStyle(
                                                color: Color(0xff00203F),
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            widget.products['product_price']
                                                .toStringAsFixed(2),
                                            style: onSale != 0 ? const TextStyle(
                                                fontSize:  11,
                                                decoration: TextDecoration.lineThrough,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w600) : const TextStyle(
                                                fontSize: 16,
                                                color: Color(0xff00203F),
                                                fontWeight: FontWeight.w600),
                                          ),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          onSale != 0 ? Text(
                                            ((1-(onSale/100)) * widget.products['product_price']).toStringAsFixed(2),
                                            style: const TextStyle(
                                                color: Color(0xff00203F),
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ) : const Text(''),
                                        ],
                                      ),
                                    )


                                  ],
                                ),
                              ],
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 40.0),
                                child: IconButton(
                                    onPressed: () {
                                    },
                                    icon: const Icon(
                                      Icons.arrow_circle_right_sharp,
                                      color: Color(0xff00203F),
                                      size: 30,
                                    )
                                ),
                              ),
                            )

                          ],
                        ),
                      ),
                    )

                  ],
                ),
              ),
              widget.products['discount'] != 0 ? Positioned(
                  top: 30,
                  left: 0,
                  child: Container(
                    height: 25,
                    width: 80,
                    decoration: const BoxDecoration(
                        color: Color(0xffE7A44D),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            bottomRight: Radius.circular(15))),
                    child: Center(child: Text('Save ${widget.products['discount'].toString()} %',style: const TextStyle(color: Color(0xff00203F)),),
                    ),
                  )
              ):
              Container(
                color: Colors.transparent,
              ),

              widget.products['sid'] == FirebaseAuth.instance.currentUser?.uid ? Positioned(
                top: 0,
                right: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xffE7A44D),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(15),bottomRight: Radius.circular(15)),),
                  child: IconButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> Edit_Product(items: widget.products,)));
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: Color(0xff00203F),
                    ),
                  ),
                ),
              ) : SizedBox()

            ]
        ),
      ),
    );
  }
}