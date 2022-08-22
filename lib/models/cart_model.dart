import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import '../provider/cart_provider.dart';
import '../provider/product_class.dart';
import '../provider/wishlist_provider.dart';

class Cart_Model extends StatelessWidget {
  const Cart_Model({Key? key, required this.product, required this.cart}) : super(key: key);
  final Product product;
  final Cart cart;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                    child: Image(image: NetworkImage(product.imagesUrl.first)),
                  ),
                  Flexible(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 0, 0, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              product.name,
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
                                  '\$ ${product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),

                              ],
                            )
                          ],
                        ),
                      )),
                ],
              ),

              Positioned(
                bottom: 0,
                  right: 0,
                  child: Container(
                decoration: const BoxDecoration(
                  color:  Color(0xffE7A44D),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(25)),
                ),
                child: RotatedBox(
                  quarterTurns: 0,
                  child: Row(
                    children: [
                      product.qty == 1
                          ? IconButton(
                          onPressed: () {
                            showCupertinoModalPopup<void>(
                              context: context,
                              builder:
                                  (BuildContext context) =>
                                  CupertinoActionSheet(
                                    title: const Text(
                                        'Remove Item'),
                                    message: const Text(
                                        'Are you sure to remove this item?'),
                                    actions: <
                                        CupertinoActionSheetAction>[
                                      CupertinoActionSheetAction(
                                        isDefaultAction: true,
                                        onPressed: () async{
                                          context.read<Wish>().getWishItem.firstWhereOrNull((element) =>
                                          element.documentId == product.documentId) != null
                                              ? context.read<Cart>().remove(product)
                                              : await context.read<Wish>().addWishItem(
                                              product.name,
                                              product.price,
                                              1,
                                              product.qntty,
                                              product.imagesUrl,
                                              product.documentId,
                                              product.suppId);
                                          context.read<Cart>().remove(product);
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                            'Move to Wishlist'),
                                      ),
                                      CupertinoActionSheetAction(
                                        onPressed: () {
                                          context.read<Cart>().remove(product);
                                          Navigator.pop(
                                              context);
                                        },
                                        child: const Text(
                                            'Delete'),
                                      ),
                                      CupertinoActionSheetAction(
                                        isDestructiveAction:
                                        true,
                                        onPressed: () {
                                          Navigator.pop(
                                              context);
                                        },
                                        child: const Text(
                                            'Cancel'),
                                      )
                                    ],
                                  ),
                            );
                          },
                          icon: const Icon(
                            Icons.delete_forever,
                            size: 18,
                            color: Color(0xff00203F),
                          ))
                          : IconButton(
                          onPressed: () {
                            cart.reduceOne(product);
                          },
                          icon: const Icon(
                            FontAwesomeIcons.minus,
                            size: 18,
                            color: Color(0xff00203F),
                          )),
                      Text(product.qty.toString(),
                          style: product.qty == product.qntty
                              ? const TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                              fontFamily: 'Acme')
                              : const TextStyle(
                              fontSize: 20,
                              fontFamily: 'Acme')),
                      IconButton(
                          onPressed:
                          product.qty == product.qntty
                              ? null
                              : () {
                            cart.increament(product);
                          },
                          icon: const Icon(
                            FontAwesomeIcons.plus,
                            size: 17,
                            color: Color(0xff00203F),
                          )),
                    ],
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
