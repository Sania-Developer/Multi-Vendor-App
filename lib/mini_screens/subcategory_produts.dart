import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../widgets/appbar_widgets.dart';

class SubCategory_Product extends StatefulWidget {
  late String subcateg_name;
  late String maincateg_name;
  bool from_onboarding;

  SubCategory_Product(
      {required this.subcateg_name,
        required this.maincateg_name,
        this.from_onboarding = false});

  @override
  State<SubCategory_Product> createState() => _SubCategory_ProductState();
}

class _SubCategory_ProductState extends State<SubCategory_Product> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('category', isEqualTo: widget.maincateg_name)
        .where('sub_category', isEqualTo: widget.subcateg_name)
        .snapshots();

    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: widget.from_onboarding == true
              ? IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/customer_home');
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Color(0xffF07470),
              ))
              : const AppBarBackButton(),
          title: AppBarTitle(title: widget.subcateg_name),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _productsStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.data!.docs.isEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const[
                  Image(image: AssetImage('images/empty_category.png')),
                  Text(
                    'No Result',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5),
                  ),
                  Text(
                    'This category is Empty',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              );
            }
            var size = MediaQuery.of(context).size;
            final double itemHeight = (size.height - kToolbarHeight - 190) / 2;
            final double itemWidth = size.width / 2;

            return Padding(
              padding: const EdgeInsets.only(top: 14.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 0,
                mainAxisSpacing: 12,
                childAspectRatio: (itemWidth / itemHeight),
                controller: new ScrollController(keepScrollOffset: false),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: List.generate(snapshot.data!.docs.length, (index) {
                  return Product_Model(products: snapshot.data!.docs[index],);
                }),
              ),
            );
          },
        ));
  }
}
