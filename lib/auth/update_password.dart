import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_vendor/widgets/auth_widgets.dart';
import 'package:multi_vendor/widgets/elevated_button.dart';
import 'package:multi_vendor/widgets/snack_bar.dart';
import '../widgets/appbar_widgets.dart';

class Update_Password extends StatefulWidget {
  const Update_Password({Key? key}) : super(key: key);

  @override
  _Update_PasswordState createState() => _Update_PasswordState();
}

final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
final TextEditingController old_password_controller = TextEditingController();
final TextEditingController new_password_controller = TextEditingController();
final GlobalKey<ScaffoldMessengerState> _scaffoldkey = GlobalKey<ScaffoldMessengerState>();
late String password;
bool check_password = true;


class _Update_PasswordState extends State<Update_Password> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldkey,
      child: Scaffold(
        appBar: AppBar(
          title: const AppBarTitle(
            title: 'Change Password',
          ),
          leading: const AppBarBackButton(),
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            reverse: true,
            keyboardDismissBehavior:
            ScrollViewKeyboardDismissBehavior.onDrag,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 30),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15,),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Image(image: AssetImage('images/change_password.png')),
                        Text(
                          'Change Your Password',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, bottom: 25),
                          child: TextFormField(
                            controller: old_password_controller,
                            decoration: decoration_Text_Field.copyWith(
                                label: const Text('Old Password'),
                                hintText: 'Enter Your Current Password',
                                errorText: check_password != true
                                    ? 'Not valid Password'
                                    : null),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please write your password';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, bottom: 25),
                          child: TextFormField(
                            controller: new_password_controller,
                            decoration: decoration_Text_Field.copyWith(
                                label: const Text('New Password'),
                                hintText: 'New Password'),
                            onChanged: (value){
                              password = value;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please write your New password';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, bottom: 25),
                          child: TextFormField(
                            decoration: decoration_Text_Field.copyWith(
                                label: const Text('Repeat Password'),
                                hintText: 'Repeat Password'),
                            validator: (value ){
                              if (value!.isEmpty) {
                                return 'Please Re-write your New password';
                              }
                              else if(value != new_password_controller.text){
                                return ' Password not Matching ';
                              }
                              return null;
                          },
                          ),
                        ),

                        const SizedBox(
                          height: 50,
                        ),

                        Elevated_button(
                          text: 'Save Changes',
                          width: 340,
                          height: 60,
                          onPressed: () async {
                            if (_formkey.currentState!.validate()) {
                              check_password = await Auth_provider.check_old_password(
                                  FirebaseAuth.instance.currentUser!.email,
                                  old_password_controller.text);
                              setState(() {});
                              check_password == true
                                  ? await FirebaseAuth.instance.currentUser!.updatePassword(new_password_controller.text.trim()).whenComplete(() {
                                    FirebaseFirestore.instance.runTransaction((transaction) async{
                                      DocumentReference documentReference = FirebaseFirestore.instance.collection('customer').doc(FirebaseAuth.instance.currentUser!.uid);
                                      transaction.update(documentReference, {'password' : password});
                                    });
                                    _formkey.currentState!.reset();
                                    old_password_controller.clear();
                                    new_password_controller.clear();
                                    MyMessageHandler.showSnackBar('Your Password has been Updated', _scaffoldkey);
                                    Future.delayed(const Duration(seconds: 3)).whenComplete(() => Navigator.pop(context));
                              })
                                  :
                              print('not valid');
                            } else {
                              print('not valid');
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Auth_provider {
  static Future<bool> check_old_password(email, password) async {
    AuthCredential authCredential =
    EmailAuthProvider.credential(email: email, password: password);

    try {
      var credentialResult = await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(authCredential);

      return credentialResult.user != null;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
