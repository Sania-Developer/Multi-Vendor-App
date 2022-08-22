import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_vendor/widgets/appbar_widgets.dart';
import '../models/product_model.dart';
import 'edit_store.dart';

class Visit_Stores extends StatefulWidget {
  final String supplier_id;

  Visit_Stores({required this.supplier_id});

  @override
  _Visit_StoresState createState() => _Visit_StoresState();
}

bool following = false;

class _Visit_StoresState extends State<Visit_Stores> {
  @override
  Widget build(BuildContext context) {
    CollectionReference store =
    FirebaseFirestore.instance.collection('supplier');
    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('sid', isEqualTo: widget.supplier_id)
        .snapshots();
    return FutureBuilder<DocumentSnapshot>(
      future: store.doc(widget.supplier_id).get(),
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
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
          snapshot.data!.data() as Map<String, dynamic>;
          return SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.white,
                leading: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(15.0),
                    primary: Colors.white,
                    onPrimary: const Color(0xffE7A44D),
                    shadowColor: Colors.grey,
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                  ),
                ),
                title: const AppBarTitle(title: 'Seller Profile',),
              ),
              body: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                reverse: true,
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.45,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(50),
                          )
                      ),
                      child: Container(
                        child: Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 180,
                              child: data['cover_image'] == '' ? Container(
                                color: const Color(0xffE7A44D),
                                )
                              : Image.network(
                                data['cover_image'],
                                fit: BoxFit.cover,
                              ),
                            ),

                           Positioned(
                             top: 105,
                             left: 70,
                             right: 70,
                             child: Column(
                               children: [
                                 CircleAvatar(
                                   backgroundColor: Color(0xffE7A44D),
                                   radius: 85,
                                   child: Center(
                                     child: CircleAvatar(
                                       backgroundImage: NetworkImage(data['store_logo']),
                                       radius: 80,
                                     ),
                                   ),
                                 ),
                                 SizedBox(
                                   height: 100,
                                   width: MediaQuery.of(context).size.width * 0.5,
                                   child: Column(
                                     children: [
                                       Padding(
                                         padding: const EdgeInsets.all(8.0),
                                         child: Text(
                                           data['store_name'].toUpperCase(),
                                           style: const TextStyle(
                                               fontSize: 24, color: Color(0xff00203F),fontWeight: FontWeight.w500),
                                         ),
                                       ),
                                       data['sid'] == FirebaseAuth.instance.currentUser?.uid ? Container(
                                         height: 45,
                                         width: MediaQuery.of(context).size.width * 0.5,
                                         decoration: BoxDecoration(
                                             color: const Color(0xffE7A44D),
                                             border: Border.all(
                                                 width: 3, color: const Color(0xff00203F)),
                                             borderRadius: BorderRadius.circular(15)),
                                         child: MaterialButton(
                                             onPressed: () {
                                               Navigator.push(context, MaterialPageRoute(builder: (context) => Edit_Store(data: data,)));
                                             },
                                             child: Row(
                                               crossAxisAlignment: CrossAxisAlignment.center,
                                               mainAxisAlignment: MainAxisAlignment.center,
                                               children: const [
                                                 Text('Edit',style: TextStyle(fontSize: 20),),
                                                 SizedBox(width: 13,),
                                                 Icon(
                                                   Icons.edit,
                                                   color: Color(0xff00203F),
                                                 )
                                               ],
                                             )),
                                       ) :
                                       Container(
                                         height: 45,
                                         width: MediaQuery.of(context).size.width * 0.5,
                                         decoration: BoxDecoration(
                                             color: const Color(0xffE7A44D),
                                             border: Border.all(
                                                 width: 3, color: const Color(0xff00203F)),
                                             borderRadius: BorderRadius.circular(15)),
                                         child: MaterialButton(
                                             onPressed: () {
                                               setState(() {
                                                 following = !following;
                                               });
                                             },
                                             child: following == true
                                                 ? const Text(
                                               'following',
                                               style: TextStyle(
                                                   color: Color(0xff00203F),
                                                   fontSize: 16),
                                             )
                                                 : const Text(
                                               'FOLLOW',
                                               style: TextStyle(
                                                   color: Color(0xff00203F),
                                                   fontSize: 20),
                                             )),
                                       )
                                     ],
                                   ),
                                 ),
                               ],
                             ),
                           ),

                          ],
                        ),
                      ),
                    ),

                    StreamBuilder<QuerySnapshot>(
                      stream: _productsStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        }
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Material(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        if (snapshot.data!.docs.isEmpty) {
                          return const Center(
                              child: Text(
                                'This Store \n\n has no items yet !',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 26,
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Acme',
                                    letterSpacing: 1.5),
                              ));
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
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return const Text('Loading');
      },
    );
  }
}


