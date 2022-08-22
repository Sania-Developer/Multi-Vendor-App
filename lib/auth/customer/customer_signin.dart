// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_vendor/auth/forget_password.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/auth_widgets.dart';
import '../../widgets/elevated_button.dart';
import '../../widgets/google_button.dart';
import '../../widgets/snack_bar.dart';
import 'package:google_sign_in/google_sign_in.dart';

CollectionReference customer = FirebaseFirestore.instance.collection('customer');

class Customer_LogIn_Screen extends StatefulWidget {
  const Customer_LogIn_Screen({Key? key}) : super(key: key);

  @override
  _Customer_LogIn_ScreenState createState() => _Customer_LogIn_ScreenState();
}

class _Customer_LogIn_ScreenState extends State<Customer_LogIn_Screen> {

  late String uid;
  bool docExist = false;

  Future<bool> check_doc_exist (String doc_id)async{
    try{
      var doc = await customer.doc().get();
      return doc.exists;
    }
    catch(e){
      return false;
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential).whenComplete(() async{
      User? user = FirebaseAuth.instance.currentUser;

      docExist = await check_doc_exist(user!.uid);
      docExist == false ?
      await customer.doc(user.uid).set({
        'name': user.displayName,
        'email': user.email,
        'profile_image': user.photoURL,
        'phone': '',
        'address': '',
        'cid': user.uid,
      }).then((value) {navigate();}) : navigate();
    });
  }

  late String email;
  late String password;
  bool password_invisible = true;
  bool proccessing = false;
  bool send_email_verification = false;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldkey = GlobalKey<ScaffoldMessengerState>();

  void navigate(){
    Navigator.canPop(context)
        ? Navigator.pop(context)
        : Navigator.pushReplacementNamed(context, '/customer_home');
  }

  void login() async{
    setState(() {
      proccessing = true;
    });
    if (_formkey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
        if(FirebaseAuth.instance.currentUser!.emailVerified) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('role', 'customer');
          navigate();
          _formkey.currentState!.reset();
        }else{
          MyMessageHandler.showSnackBar(
              'Please check your email inbox', _scaffoldkey);
          setState(() {
            proccessing = false;
            send_email_verification = true;
          });
        }
      }  on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          setState(() {
            proccessing = false;
          });
          MyMessageHandler.showSnackBar(
              'No user found for that email.', _scaffoldkey);
        } else if (e.code == 'wrong-password') {
          setState(() {
            proccessing = false;
          });
          MyMessageHandler.showSnackBar(
              'Wrong password provided for that user.', _scaffoldkey);
        }

      } catch (e) {
        print(e);
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const Padding(
                        padding:  EdgeInsets.only(top: 8.0),
                        child:  Center(
                          child:
                          AuthHeaderLabel(auth_header_label: 'Sign In'),
                        ),
                      ),
                      const SizedBox(
                        height: 60,
                      ),

                      Google_button(onPressed: (){

                        signInWithGoogle();

                      }),

                      const SizedBox(
                        height: 20,
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
                        height: 14,
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
                      TextButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const Forget_Password()));
                      }, child: const Text('Forget Password?',style: TextStyle(fontSize: 18,fontStyle: FontStyle.italic,color: Color(0xff00203F)),)),
                      const SizedBox(
                        height: 8,
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: proccessing == true
                            ? const CircularProgressIndicator(
                          color: Color(0xff00203F),
                        )
                            : Elevated_button(
                            width: double.infinity,
                            height: 60,
                            text: ' Sign In ',
                            onPressed: () {
                              login();
                            }),
                      ),
                      const  SizedBox(
                        height: 10,
                      ),

                      HaveAccount(
                        have_account: 'Do\'nt have an account?',
                        action_label: 'Sign up',
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/customer_signup');
                        },
                      ),

                      send_email_verification == true ? Center(
                        child: Elevated_button(text: 'Resend Email', width: double.infinity, height: 60 ,onPressed: ()async{
                          try{
                            await FirebaseAuth.instance.currentUser!.sendEmailVerification();
                          }catch(e){
                            print(e);
                          }
                          Future.delayed(const Duration(microseconds: 100)).whenComplete(() {
                            setState(() {
                              send_email_verification = false;
                            });
                          });
                        },),
                      ) : const SizedBox(),
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


