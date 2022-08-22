import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/cart_provider.dart';
import 'package:collection/collection.dart';

import '../provider/product_class.dart';
import '../provider/wishlist_provider.dart';

class Wishlist_Model extends StatefulWidget {

  const Wishlist_Model({Key? key ,required this.product}) : super(key: key);
  final Product product;

  @override
  State<Wishlist_Model> createState() => _Wishlist_ModelState();
}

class _Wishlist_ModelState extends State<Wishlist_Model> {
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        decoration: BoxDecoration(
            color:  Colors.white,
            border: Border.all(color: const Color(
                0xffE7A44D),width: 2 ),
            borderRadius: BorderRadius.circular(12)
        ),
        child: SizedBox(
          height: 100,
          child: Stack(
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 100,
                    width: 120,
                    child: Image.network(widget.product.imagesUrl.first),
                  ),
                  Flexible(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.product.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff00203F),
                                  fontWeight: FontWeight.w600),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.product.price.toStringAsFixed(2),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: const BoxDecoration(
                          color:  Color(0xffE7A44D),
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(25)),
                        ),
                        child: Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          context.read<Wish>().remove(widget.product);
                                        },
                                        icon: const Icon(Icons.delete_forever,color: Color(0xff00203F),),),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    context.watch<Cart>().getItem.firstWhereOrNull(
                                            (element) => element.documentId == widget.product.documentId) != null || widget.product.qntty == 0
                                        ? const SizedBox()
                                        :  IconButton(
                                        onPressed: () {
                                          setState(() {
                                            context.read<Cart>().addItem(
                                                widget.product.name,
                                                widget.product.price,
                                                1,
                                                widget.product.qntty,
                                                widget.product.imagesUrl,
                                                widget.product.documentId,
                                                widget.product.suppId);
                                          });
                                        },
                                        icon: const Icon(
                                            Icons.add_shopping_cart,color: Color(0xff00203F),)),
                                  ],
                                )
                      )
                    )
                              ],
                            )
                          ],
                        ),
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
