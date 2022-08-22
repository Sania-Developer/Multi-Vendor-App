import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_vendor/mini_screens/visit_store.dart';
import 'package:multi_vendor/widgets/appbar_widgets.dart';

class Store_Screen extends StatelessWidget {
  const Store_Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const AppBarTitle(
            title: 'Sellers',
          )),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('supplier').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: GridView.builder(
                  itemCount: snapshot.data!.docs.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 25,
                      crossAxisSpacing: 25),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Visit_Stores(supplier_id: snapshot.data!.docs[index]['sid'])));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 14.0 ,right: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0x43e7a44d),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: const Color(0xffE7A44D))
                          ),
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 110,
                                        decoration: const BoxDecoration(
                                          color: Color(0xffE7A44D),
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(25),
                                              topRight: Radius.circular(25),
                                              bottomLeft: Radius.circular(100),
                                              bottomRight: Radius.circular(100),
                                          )
                                        ),
                                      ),
                                    ],
                                  ),


                                ],
                              ),
                              Positioned(
                                top: 30,
                                right: 35,
                                child: Center(
                                  // padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundImage: NetworkImage(snapshot.data!.docs[index]['store_logo']),
                                  ),
                                ),
                              ),

                              Positioned(
                                bottom: 10,
                                right: 40,
                                left: 40,
                                child: Center(
                                  // padding: const EdgeInsets.only(top: 5.0),
                                  child: Text(snapshot.data!.docs[index]['store_name'],style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600,color: Color(0xff00203F)),),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            );
          }
          return const Center(
            child: Text('No Store'),
          );
        },
      ),
    );
  }
}
