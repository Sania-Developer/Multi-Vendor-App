import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_vendor/mini_screens/add_address.dart';
import 'package:multi_vendor/widgets/appbar_widgets.dart';
import 'package:multi_vendor/widgets/elevated_button.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class Address_Book extends StatefulWidget {
  const Address_Book({Key? key}) : super(key: key);

  @override
  _Address_BookState createState() => _Address_BookState();
}

class _Address_BookState extends State<Address_Book> {

  final Stream<QuerySnapshot> _addressStream = FirebaseFirestore.instance
      .collection('customer')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('address')
      .snapshots();

  Future default_address_false({dynamic item})async{
    await FirebaseFirestore.instance
        .runTransaction((transaction) async {
      DocumentReference documentReference =
      FirebaseFirestore.instance
          .collection('customer')
          .doc(FirebaseAuth
          .instance.currentUser!.uid)
          .collection('address')
          .doc(item.id);
      transaction.update(
          documentReference, {'default': false});
    });
  }
  Future default_address_true({dynamic customer}) async{
    await FirebaseFirestore.instance
        .runTransaction((transaction) async {
      DocumentReference documentReference =
      FirebaseFirestore.instance
          .collection('customer')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('address')
          .doc(customer['address_id']);
      transaction
          .update(documentReference, {'default': true});
    });
  }

  Future update_profile({dynamic customer})async{
    await FirebaseFirestore.instance
        .runTransaction((transaction) async {
      DocumentReference documentReference =
      FirebaseFirestore.instance
          .collection('customer')
          .doc(
          FirebaseAuth.instance.currentUser!.uid);
      transaction.update(documentReference, {
        'address':
        '${customer['country']} - ${customer['state']} - ${customer['city']}',
        'phone' : customer['phone']
      });
    });
  }


  void showProgress() {
    ProgressDialog progressDialog = ProgressDialog(context: context);
    progressDialog.show(
        max: 100,
        msg: 'Please wait....',
        progressBgColor: const Color(0xff00203F),
        progressValueColor: const Color(0xffE7A44D));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const AppBarBackButton(),
        title: const AppBarTitle(title: 'Address Book'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
              stream: _addressStream,
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
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const[
                      Image(image: AssetImage('images/empty_screen_image.png')),
                      Text(
                        'No Result',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.5),
                      ),
                      Text(
                    'You have not set an address yet',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                    ),
                  ),
                    ],
                  );
                }

                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var customer = snapshot.data!.docs[index];
                      return Dismissible(
                        key: UniqueKey(),
                        onDismissed: (direction) async{
                          await FirebaseFirestore.instance.runTransaction((transaction) async{
                            DocumentReference documentReference = FirebaseFirestore.instance.collection('customer').doc(FirebaseAuth.instance.currentUser!.uid).collection('address').doc(customer['address_id']);
                            transaction.delete(documentReference);
                          });
                        },
                        child: GestureDetector(
                          onTap: () async {
                            showProgress();
                            for (var item in snapshot.data!.docs) {
                              await default_address_false(item: item);
                            }

                            await default_address_true(customer: customer).whenComplete(() => update_profile(customer: customer));
                            Future.delayed(const Duration(microseconds: 100)).whenComplete(() => Navigator.pop(context));


                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: customer['default'] == true ? const Color(
                                        0xffE7A44D) : Colors.white,
                                    border: Border.all(color: const Color(
                                        0xff00203F) ),
                                    borderRadius: BorderRadius.circular(14)
                                  ),
                                  child: ListTile(
                                    title: SizedBox(
                                      height: 70.0,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${customer['first_name']}  ${customer['last_name']}',
                                            style:
                                                const TextStyle(color: Color(0xff00203F))
                                          ),
                                          Text(
                                              'city/state:  ${customer['city']} ${customer['state']}',
                                              style:
                                              const TextStyle(color: Color(0xff00203F))
                                          ),
                                          Text('country:      ${customer['country']}',
                                              style:
                                              const TextStyle(color: Color(0xff00203F))
                                          ),
                                        ],
                                      ),
                                    ),
                                    subtitle: SizedBox(
                                      height: 50.0,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [

                                          Text('Phone No: +${customer['phone']}',
                                              style:
                                              const TextStyle(color: Color(0xff00203F))
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: customer['default'] == true ? Container(
                                    decoration: const BoxDecoration(
                                      color: Color(0xff00203F),
                                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25))
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 30.0,left: 8,right: 8,bottom: 30),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: const [
                                          Icon(Icons.home,color: Colors.white,),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          RotatedBox(
                                            quarterTurns: 9,
                                            child: Text(
                                                'Default',
                                              style: TextStyle(
                                                color: Colors.white
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ):  const SizedBox()),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
                //
              },
            )
            ),
            Elevated_button(text: 'Add New Address', width: 350, height: 60,onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Add_Address()));
            },),
          ],
        ),
      ),
    );
  }
}
