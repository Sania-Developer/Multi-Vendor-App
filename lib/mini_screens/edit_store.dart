import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:multi_vendor/widgets/elevated_button.dart';
import 'package:multi_vendor/widgets/pick_image_icons.dart';

import '../widgets/appbar_widgets.dart';
import '../widgets/auth_widgets.dart';
import '../widgets/snack_bar.dart';

class Edit_Store extends StatefulWidget {
  final dynamic data;
  const Edit_Store({Key? key, required this.data}) : super(key: key);

  @override
  _Edit_StoreState createState() => _Edit_StoreState();
}

class _Edit_StoreState extends State<Edit_Store> {
  late String store_name;
  late String phone;
  late String? store_logo;
  late String store_cover_image;
  bool proccessing = false;

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  GlobalKey<ScaffoldMessengerState> _scaffoldkey =
      GlobalKey<ScaffoldMessengerState>();

  XFile? _store_logo;
  ImagePicker picker = ImagePicker();
  dynamic _pickImage_fromError;
  void pick_store_logo() async {
    try {
      final picked_logo_image = await picker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        _store_logo = picked_logo_image;
      });
    } catch (e) {
      setState(() {
        _pickImage_fromError = e;
      });
    }
  }

  XFile? _store_cover_image;
  void pick_cover_image() async {
    try {
      final pick_cover_image = await picker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        _store_cover_image = pick_cover_image;
      });
    } catch (e) {
      setState(() {
        _pickImage_fromError = e;
      });
    }
  }

  Future Upload_store_logo() async {
    if (_store_logo != null) {
      try {
        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref('supplier-image/${widget.data['email']}.jpg');
        await ref.putFile((File(_store_logo!.path)));
        store_logo = await ref.getDownloadURL();
      } catch (e) {
        print(e);
      }
    } else {
      store_logo = widget.data['store_logo'];
    }
  }

  Future Upload_cover_image() async {
    if (_store_cover_image != null) {
      try {
        firebase_storage.Reference ref2 = firebase_storage
            .FirebaseStorage.instance
            .ref('supplier-image/${widget.data['email']}.jpg-cover');
        await ref2.putFile((File(_store_cover_image!.path)));
        store_cover_image = await ref2.getDownloadURL();
      } catch (e) {
        print(e);
      }
    } else {
      store_cover_image = widget.data['store_logo'];
    }
  }

  edit_store_data() async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('supplier')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      transaction.update(documentReference, {
        'store_name': store_name,
        'store_logo': store_logo,
        'phone': phone,
        'cover_image': store_cover_image,
      });
    }).whenComplete(() => Navigator.pop(context));
  }

  saveChanges() async {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
      setState(() {
        proccessing = true;
      });
      await Upload_store_logo().whenComplete(
          () => Upload_cover_image().whenComplete(() => edit_store_data()));
    } else {
      MyMessageHandler.showSnackBar('Please fill all the field', _scaffoldkey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
        key: _scaffoldkey,
        child: Scaffold(
          appBar: AppBar(
            leading: const AppBarBackButton(),
            elevation: 0,
            backgroundColor: Colors.white,
            title: const AppBarTitle(title: 'Edit Store'),
          ),
          body: SingleChildScrollView(
            reverse: true,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Form(
              key: _formkey,
              child: Column(children: [
                Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.38,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(50),
                          )),
                      child: Container(
                        child: Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 180,
                              child: Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 180,
                                    child: _store_cover_image != null
                                        ? Image(image: FileImage(File(_store_cover_image!.path)),)
                                        : Image.network(
                                      widget.data['cover_image'],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Pick_image_icons(
                                        icon: Icons.edit,
                                        onPressed: () {
                                          pick_cover_image();
                                        },
                                      ))
                                ],
                              )
                            ),
                            Positioned(
                                top: 105,
                                left: 70,
                                right: 70,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Stack(children: [
                                      CircleAvatar(
                                        backgroundColor: Color(0xffE7A44D),
                                        radius: 85,
                                        child: Center(
                                          child: CircleAvatar(
                                            backgroundImage: _store_logo != null
                                                ? FileImage(
                                                        File(_store_logo!.path))
                                                    as ImageProvider
                                                : NetworkImage(
                                                    widget.data['store_logo']),
                                            radius: 80,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Pick_image_icons(
                                            icon: Icons.edit,
                                            onPressed: () {
                                              pick_store_logo();
                                            },
                                          )),
                                    ]
                                    ),
                                  ],
                                )
                            ),
                          ],
                        ),
                      ),
                    ),
                     const Padding(
                       padding: EdgeInsets.only(bottom: 40.0,left: 60,right: 60),
                       child: Divider(
                        color: Color(0xffE7A44D),
                        thickness: 1.5,
                    ),
                     ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: widget.data['store_name'],
                        decoration: decoration_Text_Field.copyWith(
                            label: const Text('Store Name'),
                            hintText: 'Enter Store Name'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Store Name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          store_name = value!;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: widget.data['phone'],
                        decoration: decoration_Text_Field.copyWith(
                            label: const Text('Phone'),
                            hintText: 'Enter Phone Number'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Phone Number';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          phone = value!;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          proccessing == true
                              ? Elevated_button(
                            text: 'Please wait....',
                            width: 350,
                            height: 60,
                            onPressed: () {
                              null;
                            },
                          )
                              : Elevated_button(
                            text: 'Save Change',
                            width: 350,
                            height: 60,
                            onPressed: () {
                              saveChanges();
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Elevated_button(
                              text: 'Cancel',
                              width: 350,
                              height: 60,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ]),
            ),
          ),
        ));
  }
}
