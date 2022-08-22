import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/product_model.dart';


class All_Products extends StatefulWidget {
  const All_Products({Key? key}) : super(key: key);

  @override
  _All_ProductsState createState() =>
      _All_ProductsState();
}

class _All_ProductsState extends State<All_Products> {

  final Stream<QuerySnapshot> _productsStream =
  FirebaseFirestore.instance.collection('products').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _productsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
        //
      },
    );
  }
}
