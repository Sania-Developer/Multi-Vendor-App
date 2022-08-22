import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_vendor/widgets/appbar_widgets.dart';
import '../models/product_model.dart';

class ShoesGalleryScreen extends StatefulWidget {
  bool from_onboarding;
  ShoesGalleryScreen({Key? key , this.from_onboarding = false}) : super(key: key);

  @override
  _ShoesGalleryScreenState createState() => _ShoesGalleryScreenState();
}

class _ShoesGalleryScreenState extends State<ShoesGalleryScreen> {

  final Stream<QuerySnapshot> _productsStream =
  FirebaseFirestore.instance.collection('products').where('category' , isEqualTo: 'Shoes').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.from_onboarding == true ? AppBar(
          title: const AppBarTitle(title: 'Shoes',),
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/customer_home');
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Color(0xffF07470),
              ))
      ): null,
      body: StreamBuilder<QuerySnapshot>(
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
      ),
    );
  }
}

//StaggeredGridView.countBuilder(
//                 physics: NeverScrollableScrollPhysics(),
//                 shrinkWrap: true,
//                 itemCount: snapshot.data!.docs.length,
//                 crossAxisCount: 2,
//                 itemBuilder: (context, index) {
//                   return Product_Model(products: snapshot.data!.docs[index],);
//                 },
//                 staggeredTileBuilder: (context) => StaggeredTile.fit(1)),



