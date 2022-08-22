// ignore_for_file: avoid_print
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../widgets/auth_widgets.dart';
import '../../widgets/elevated_button.dart';
import '../../widgets/pick_image_icons.dart';
import '../../widgets/snack_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


CollectionReference supplier = FirebaseFirestore.instance.collection('supplier');

class Supplier_Signup_Screen extends StatefulWidget {
  const Supplier_Signup_Screen({Key? key}) : super(key: key);

  @override
  _Supplier_Signup_ScreenState createState() => _Supplier_Signup_ScreenState();
}

class _Supplier_Signup_ScreenState extends State<Supplier_Signup_Screen> {
  late String store_name;
  late String email;
  late String password;
  late String store_logo;
  late String _uid;
  bool password_invisible = true;
  bool proccessing = false;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldkey =
  GlobalKey<ScaffoldMessengerState>();

  XFile? _imageFile;
  ImagePicker picker = ImagePicker();
  dynamic _pickImage_fromError;
  void _pickImage_fromCamera() async {
    try {
      final pickediamge = await picker.pickImage(
          source: ImageSource.camera,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        _imageFile = pickediamge;
      });
    } catch (e) {
      setState(() {
        _pickImage_fromError = e;
      });
    }
  }

  void _pickImage_fromGallery() async {
    try {
      final pickediamge = await picker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        _imageFile = pickediamge;
      });
    } catch (e) {
      setState(() {
        _pickImage_fromError = e;
      });
    }
  }

  void signup() async{
    setState(() {
      proccessing = true;
    });
    if (_formkey.currentState!.validate()) {
      if (_imageFile != null) {
        try {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

          try{
            await FirebaseAuth.instance.currentUser!.sendEmailVerification();
          }catch(e){
            print(e);
          }

          firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref('supplier-image/$email.jpg');
          await ref.putFile((File(_imageFile!.path)));
          store_logo = await ref.getDownloadURL();
          await FirebaseAuth.instance.currentUser!.updateDisplayName(store_name);
          await FirebaseAuth.instance.currentUser!.updatePhotoURL(store_logo);
          _uid = FirebaseAuth.instance.currentUser!.uid;
          await supplier.doc(_uid).set({
            'store_name': store_name,
            'email': email,
            'password': password,
            'store_logo': store_logo,
            'phone': '',
            'sid': _uid,
            'cover_image': ''
          });
          _formkey.currentState!.reset();
          MyMessageHandler.showSnackBar(
              'Thanks for Sign Up', _scaffoldkey);
          setState(() {
            _imageFile = null;
          });
          Navigator.pushReplacementNamed(context, '/supplier_signin');
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            setState(() {
              proccessing = false;
            });
            MyMessageHandler.showSnackBar(
                e.message.toString(), _scaffoldkey);
          } else if (e.code == 'email-already-in-use') {
            setState(() {
              proccessing = false;
            });
            MyMessageHandler.showSnackBar(
                e.message.toString(), _scaffoldkey);
          }


        } catch (e) {
          print(e);
        }


      }
      else {
        setState(() {
          proccessing = false;
        });
        MyMessageHandler.showSnackBar(
            'Please Pick Image First', _scaffoldkey);
      }
    } else {
      setState(() {
        proccessing = false;
      });
      MyMessageHandler.showSnackBar(
          'Please fill all the fields', _scaffoldkey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: ScaffoldMessenger(
          key: _scaffoldkey,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              reverse: true,
              keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior.onDrag,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [

                      const Padding(
                        padding:  EdgeInsets.only(top: 8.0),
                        child:  Center(
                          child:
                          AuthHeaderLabel(auth_header_label: 'Sign Up'),
                        ),
                      ),
                      const SizedBox(
                        height: 60,
                      ),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                backgroundColor: const Color(0xffE7A44D),
                                radius: 60,
                                backgroundImage: _imageFile == null
                                    ? null
                                    : FileImage(File(_imageFile!.path)),
                              ),
                              Positioned(
                                top: 0,
                                left: 0,
                                child: Pick_image_icons(
                                  icon: Icons.camera_alt,
                                  onPressed: () {
                                  _pickImage_fromCamera();
                                },
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Pick_image_icons(
                                  icon: Icons.image,
                                  onPressed: () {
                                    _pickImage_fromGallery();
                                  },

                                ),
                              )
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 8.0, bottom: 5),
                            child: Text(
                              'Your Name',
                              style:
                              TextStyle(color: Colors.grey, fontSize: 15),
                            ),
                          ),
                          TextFormField(
                            decoration: decoration_Text_Field.copyWith(
                                label: const Text('Full Name'),
                                hintText: 'Enter Your Full Name'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your name';
                              } else {
                                return null;
                              }
                            },
                            onChanged: (value) {
                              store_name = value;
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 8.0, bottom: 5),
                            child: Text(
                              'Your Email',
                              style:
                              TextStyle(color: Colors.grey, fontSize: 15),
                            ),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            // controller: _nameControllertroller,
                            decoration: decoration_Text_Field.copyWith(
                                label: const Text('Full Email'),
                                hintText: 'Enter Your Full Email'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your Email';
                              } else if(value.isValidEmail() == false){
                                return 'Your Email is Invalid';
                              }else {
                                return null;
                              }
                            },
                            onChanged: (value) {
                              email = value;
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 8.0, bottom: 5),
                            child: Text(
                              'Your Password',
                              style:
                              TextStyle(color: Colors.grey, fontSize: 15),
                            ),
                          ),
                          TextFormField(
                            // controller: _passwordController,
                            obscureText: password_invisible,
                            decoration: decoration_Text_Field.copyWith(
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      password_invisible =
                                      !password_invisible;
                                    });
                                  },
                                  icon: Icon(password_invisible
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  color: const Color(0xff00203F),
                                ),
                                label: const Text('Password'),
                                hintText: 'Enter Your Password'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your password';
                              } else {
                                return null;
                              }
                            },
                            onChanged: (value) {
                              password = value;
                            },
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 8,
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: proccessing == true
                            ? const CircularProgressIndicator(
                          color: Color(0xff00203F),
                        )
                            : Elevated_button(
                            width: double.infinity,
                            height: 60,
                            text: ' Sign Up ',
                            onPressed: () {
                              signup();
                            }),
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      HaveAccount(
                        have_account: 'Already have an account?',
                        action_label: 'Log In',
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/supplier_signin');
                        },
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
