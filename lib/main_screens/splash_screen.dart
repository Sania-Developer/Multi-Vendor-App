import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash_Screen extends StatefulWidget {
  const Splash_Screen({Key? key}) : super(key: key);

  @override
  _Splash_ScreenState createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> {

  void check_user()async{
    final prefs = await SharedPreferences.getInstance();
    final String? role = prefs.getString('role');
    print(role);
    if(role == 'seller'){
      Navigator.pushReplacementNamed(context, '/supplier_home');
    }
    else if(role == 'customer'){
      Navigator.pushReplacementNamed(context, '/customer_home');
    }
    else{
      print("testing 2");
      Navigator.pushReplacementNamed(context, '/customer_home');
    }
  }



  @override
  void initState() {
    Future.delayed(const Duration(seconds: 8), () {
      setState(() async{
        check_user();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 150,
                width: 150,
                child: Lottie.asset('images/logo_animation.json'),
              ),
              const SizedBox(
                height: 7,
              ),
              Column(
                children: [
                  Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          FontAwesomeIcons.github,
                        ),
                        Text(
                          ' / sania-khan-developer',
                          style: TextStyle(color: Color(0xff00203f), fontSize: 17),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        FontAwesomeIcons.linkedin,
                      ),
                      Text(
                        ' / Sania-Developer',
                        style: TextStyle(color: Color(0xff00203f), fontSize: 17),
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
