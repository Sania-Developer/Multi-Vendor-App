import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_vendor/widgets/appbar_widgets.dart';
import 'package:multi_vendor/widgets/elevated_button.dart';
import '../widgets/auth_widgets.dart';

class Forget_Password extends StatefulWidget {
  const Forget_Password({Key? key}) : super(key: key);

  @override
  _Forget_PasswordState createState() => _Forget_PasswordState();
}

final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
TextEditingController _emailController = TextEditingController();

class _Forget_PasswordState extends State<Forget_Password> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(
          title: 'Forget Password',
        ),
        leading: const AppBarBackButton(),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Form(
          key: _formkey,
          child: Padding(
            padding: const EdgeInsets.only(top: 60.0,left: 15, right: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'To reset your Password Please enter your E-mail Address',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff00203F)
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 50,
                ),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: decoration_Text_Field.copyWith(
                      label: const Text('Full Email'),
                      hintText: 'Enter Your Full Email'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your Email';
                    } else if (value.isValidEmail() == false) {
                      return 'Your Email is Invalid';
                    } else {
                      return null;
                    }
                  },

                ),
                const SizedBox(
                  height: 40,
                ),
                Elevated_button(text: 'Send Reset Password link', width: double.infinity, height: 60,onPressed: ()async{
                  if(_formkey.currentState!.validate()){
                    try{
                      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text);
                    }catch(e){
                      print(e);
                    }
                  }else{
                    print('Form not Valid');
                  }

                },)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
