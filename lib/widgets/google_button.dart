import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Google_button extends StatelessWidget {

  late Function() onPressed;
  Google_button({Key? key,required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Material(
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(20.0),
              fixedSize: const Size(double.infinity, 60),
              textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              primary: Colors.white,
              onPrimary: const Color(0xff00203F),
              side: const BorderSide(color: Color(0xffE7A44D), width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const[
                  Icon(
                    FontAwesomeIcons.google,
                    color: Color(0xff00203F),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Text(
                    'Sign In With Google',
                    style: TextStyle(color: Color(0xff00203F), fontSize: 16),
                  )
                ]),
          )

      ),
    );
  }
}
