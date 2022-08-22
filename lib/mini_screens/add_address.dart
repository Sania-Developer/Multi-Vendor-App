import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_vendor/widgets/auth_widgets.dart';
import 'package:multi_vendor/widgets/elevated_button.dart';
import 'package:uuid/uuid.dart';

import '../widgets/appbar_widgets.dart';
import '../widgets/snack_bar.dart';

class Add_Address extends StatefulWidget {
  const Add_Address({Key? key}) : super(key: key);

  @override
  _Add_AddressState createState() => _Add_AddressState();
}

class _Add_AddressState extends State<Add_Address> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  GlobalKey<ScaffoldMessengerState> _scaffoldkey = GlobalKey<ScaffoldMessengerState>();

  late String first_name;
  late String last_name;
  late String phone;
  String countryValue = 'Choose Country';
  String stateValue = 'Choose State';
  String cityValue = 'Choose City';

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldkey,
      child: Scaffold(
        appBar: AppBar(
          title: const AppBarTitle(
            title: 'Add Address',
          ),
          elevation: 0,
          leading: const AppBarBackButton(),
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              reverse: true,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 15, bottom: 50),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                           Text(
                            'Add New Address',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.5),
                          ),
                           Text(
                            'Your Location',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, bottom: 20.0,right: 12.0),
                      child: TextFormField(
                        decoration: decoration_Text_Field.copyWith(
                            label: const Text('First Name'),
                            hintText: 'Enter Your first name'),
                        validator: (value) {
                          try {
                            if (value!.isEmpty) {
                              return 'Please enter your first name';
                            }
                            return null;
                          } catch (e) {
                            print(e);
                          }
                        },
                        onSaved: (value) {
                          first_name = value!;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, bottom: 20.0,right: 12.0),
                      child: TextFormField(
                        decoration: decoration_Text_Field.copyWith(
                            label: const Text('Last Name'),
                            hintText: 'Enter Your last name'),
                        validator: (value) {
                          try {
                            if (value!.isEmpty) {
                              return 'Please enter your last name';
                            }
                            return null;
                          } catch (e) {
                            print(e);
                          }
                        },
                        onSaved: (value) {
                          last_name = value!;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, bottom: 20.0,right: 12.0),
                      child: TextFormField(
                        decoration: decoration_Text_Field.copyWith(
                            label: const Text('Phone No'),
                            hintText: 'Enter Your Phone Number'),
                        validator: (value) {
                          try {
                            if (value!.isEmpty) {
                              return 'Please enter phone number';
                            }
                            return null;
                          } catch (e) {
                            print(e);
                          }
                        },
                        onSaved: (value) {
                          phone = value!;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0,right: 30.0),
                      child: SelectState(
                        style: const TextStyle(color: Color(0xff00203F)),
                        onCountryChanged: (value) {
                          setState(() {
                            countryValue = value;
                          });
                        },
                        onStateChanged: (value) {
                          setState(() {
                            stateValue = value;
                          });
                        },
                        onCityChanged: (value) {
                          setState(() {
                            cityValue = value;
                          });
                        },
                      ),
                    ),

                    const SizedBox(
                      height: 60,
                    ),

                    Center(
                      child: Elevated_button(
                        text: 'Add Address',
                        width: 350,
                        height: 60,
                        onPressed: () {
                          if (_formkey.currentState!.validate()) {
                            if (countryValue != 'Choose Country' &&
                                stateValue != 'Choose State' &&
                                cityValue != 'Choose City') {
                              _formkey.currentState!.save();
                              CollectionReference addresRef = FirebaseFirestore.instance.collection('customer').doc(FirebaseAuth.instance.currentUser!.uid).collection('address');
                              var address_id = const Uuid().v4();
                              addresRef.doc(address_id).set(
                             {
                               'address_id' : address_id,
                               'first_name' : first_name,
                               'last_name' : last_name,
                               'phone' : phone,
                               'country' : countryValue,
                               'state' : stateValue,
                               'city' : cityValue,
                               'default' : true,
                             }
                              ).whenComplete(() => Navigator.pop(context));
                            }
                          } else {
                            MyMessageHandler.showSnackBar(
                                'Please Fill all the Field', _scaffoldkey);
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
