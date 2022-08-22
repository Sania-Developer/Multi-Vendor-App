import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:multi_vendor/mini_screens/visit_store.dart';
import 'package:multi_vendor/widgets/elevated_button.dart';
import '../main_screens/cart_screen.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import '../models/product_model.dart';
import '../provider/cart_provider.dart';
import '../provider/wishlist_provider.dart';
import '../widgets/appbar_widgets.dart';
import '../widgets/snack_bar.dart';
import 'full_screen_view.dart';


class Product_Detail_Screen extends StatefulWidget {
  final dynamic proList;
  Product_Detail_Screen(this.proList);

  @override
  _Product_Detail_ScreenState createState() => _Product_Detail_ScreenState();
}

class _Product_Detail_ScreenState extends State<Product_Detail_Screen> {
  late List<dynamic> imageList = widget.proList['product_image'];
  final GlobalKey<ScaffoldMessengerState> _scaffoldkey =
  GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    var onSale = widget.proList['discount'];

    var existingItemCartlist = context.read<Cart>().getItem.firstWhereOrNull(
            (product) => product.documentId == widget.proList['product_id']);

    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('category', isEqualTo: widget.proList['category'])
        .where('sub_category', isEqualTo: widget.proList['sub_category'])
        .snapshots();

    final Stream<QuerySnapshot> _reviewsStream = FirebaseFirestore.instance
        .collection('products')
        .doc(widget.proList['product_id'])
        .collection('reviews')
        .snapshots();

    return Material(
      child: SafeArea(
        child: ScaffoldMessenger(
          key: _scaffoldkey,
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FullScreenView(
                                  imagelist: imageList,
                                )));
                      },
                      child: Stack(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.45,
                            child: Swiper(
                              pagination: const SwiperPagination(
                                  builder: DotSwiperPaginationBuilder(
                                      color: Colors.grey, activeColor: Color(0xff00203F))),
                              itemBuilder: (context, index) {
                                return Image(image: NetworkImage(imageList[index]));
                              },
                              itemCount: imageList.length,
                              scale: 0.9,
                            ),
                          ),
                          const Positioned(
                              left: 15,
                              top: 20,
                              child: AppBarBackButton()
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 50),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0,left: 5),
                            child: Text(
                              widget.proList['category'],
                              style: const TextStyle(
                                  color: Color(0xffE7A44D),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0,left: 5),
                            child: Text(
                              widget.proList['porduct_name'],
                              style: const TextStyle(
                                  color: Color(0xff00203F),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                const Text(
                                  'USD ',
                                  style: TextStyle(
                                      color: Color(0xff00203F),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  widget.proList['product_price']
                                      .toStringAsFixed(2),
                                  style: onSale != 0
                                      ? const TextStyle(
                                      fontSize: 13,
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w600)
                                      : const TextStyle(
                                      fontSize: 20,
                                      color: Color(0xff00203F),
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                onSale != 0
                                    ? Text(
                                  ((1 - (onSale / 100)) *
                                      widget.proList['product_price'])
                                      .toStringAsFixed(2),
                                  style: const TextStyle(
                                      color: Color(0xff00203F),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                )
                                    : const Text(''),
                              ]),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      var existingItemWishlist = context
                                          .read<Wish>()
                                          .getWishItem
                                          .firstWhereOrNull((product) =>
                                      product.documentId ==
                                          widget.proList['product_id']);
                                      existingItemWishlist != null
                                          ? context.read<Wish>().removeThis(
                                          widget.proList['product_id'])
                                          : context.read<Wish>().addWishItem(
                                          widget.proList['porduct_name'],
                                          onSale != 0
                                              ? ((1 - (onSale / 100)) *
                                              widget
                                                  .proList['product_price'])
                                              : widget.proList['product_price'],
                                          1,
                                          widget.proList['product_quantity'],
                                          widget.proList['product_image'],
                                          widget.proList['product_id'],
                                          widget.proList['sid']);
                                    });
                                  },
                                  icon: context
                                      .read<Wish>()
                                      .getWishItem
                                      .firstWhereOrNull((product) =>
                                  product.documentId ==
                                      widget.proList['product_id']) !=
                                      null
                                      ? const Icon(
                                    Icons.favorite,
                                    color: Color(0xff00203F),
                                    size: 30,
                                  )
                                      : const Icon(
                                    Icons.favorite_border_outlined,
                                    color: Color(0xff00203F),
                                    size: 30,
                                  ))
                            ],
                          ),
                          widget.proList['product_quantity'] == 0
                              ? const Text(
                            ('This item is out of Stock'),
                            style: TextStyle(
                                fontSize: 16, color: Colors.blueGrey),
                          )
                              : Text(
                            (widget.proList['product_quantity'].toString()) +
                                (' pieces available in stock'),
                            style: const TextStyle(
                                fontSize: 16, color: Colors.blueGrey),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text('Product Info:',style: TextStyle(color: Color(0xff00203F),fontSize: 24.0,fontWeight: FontWeight.w600),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0,left: 8.0),
                          child: Text(
                            widget.proList['product_description'],
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.blueGrey.shade800),
                          ),
                        ),
                      ],
                    ),

                    Stack(
                      children: [
                        ExpandableTheme(
                            data: const ExpandableThemeData(
                                iconColor: Color(0xffE7A44D), iconSize: 24),
                            child: review(_reviewsStream)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0,top: 40),
                          child: Text('Similar Products',style: TextStyle(color: Color(0xff00203F),fontSize: 24.0,fontWeight: FontWeight.w600),),
                        ),
                        SizedBox(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: _productsStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return const Text('Something went wrong');
                              }

                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              var size = MediaQuery.of(context).size;
                              final double itemHeight = (size.height - kToolbarHeight - 190) / 2;
                              final double itemWidth = size.width / 2;

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 100.0,top: 30),
                                child: GridView.count(
                                  physics: const NeverScrollableScrollPhysics(),
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 2,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: (itemWidth / itemHeight),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  children: List.generate(snapshot.data!.docs.length, (index) {
                                    return Product_Model(products: snapshot.data!.docs[index],);
                                  }),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ]),
            ),
            bottomSheet: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Visit_Stores(
                                      supplier_id: widget.proList['sid'])));
                        },
                        icon: const Icon(Icons.store,color: Color(0xff00203F),)),
                    const SizedBox(
                      width: 20.0,
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Cart_Screen(
                                    leading_back: AppBarBackButton(),
                                  )));
                        },
                        icon: Badge(
                            showBadge: context.read<Cart>().getItem.isEmpty
                                ? false
                                : true,
                            badgeColor: const Color(0xffE7A44D),
                            badgeContent: Text(context
                                .watch<Cart>()
                                .getItem
                                .length
                                .toString(),style: const TextStyle(color: Color(0xff00203F)),),
                            child: const Icon(Icons.shopping_cart,color: Color(0xff00203F),))),
                  ],
                ),
                Elevated_button(
                  text: existingItemCartlist != null
                      ? 'Added'
                      : 'Add to Cart',
                  onPressed: () {
                    setState(() {
                      if (widget.proList['product_quantity'] == 0) {
                        MyMessageHandler.showSnackBar(
                            'This item is out of Stock', _scaffoldkey);
                      } else if (existingItemCartlist != null) {
                        MyMessageHandler.showSnackBar(
                            'This item is already in cart', _scaffoldkey);
                      } else {
                        context.read<Cart>().addItem(
                            widget.proList['porduct_name'],
                            onSale != 0
                                ? ((1 - (onSale / 100)) *
                                widget.proList['product_price'])
                                : widget.proList['product_price'],
                            1,
                            widget.proList['product_quantity'],
                            widget.proList['product_image'],
                            widget.proList['product_id'],
                            widget.proList['sid']);
                      }
                    });
                  },
                  width: 150,
                  height: 60,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget review(var _reviewStream) {
  return ExpandablePanel(
    collapsed: SizedBox(
      child: reviewsAll(_reviewStream),
    ),
    header: const Padding(
      padding: EdgeInsets.only(left: 8.0,top: 16),
      child: Text(
        'Review',
        style: TextStyle(
          color: Color(0xffE7A44D),
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    expanded: reviewsAll(_reviewStream),
  );
}

Widget reviewsAll(var _reviewStream) {
  return StreamBuilder<QuerySnapshot>(
    stream: _reviewStream,
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
      if (snapshot2.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: snapshot2.data!.docs.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  snapshot2.data!.docs[index]['profile_image'],
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(snapshot2.data!.docs[index]['name']),
                  Row(
                    children: [
                      Text(snapshot2.data!.docs[index]['rate'].toString()),
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                      )
                    ],
                  )
                ],
              ),
              subtitle: Text(
                snapshot2.data!.docs[index]['comment'],
              ),
            );
          });
      //
    },
  );
}

