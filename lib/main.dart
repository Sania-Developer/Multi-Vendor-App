import 'package:flutter/material.dart';
import 'package:multi_vendor/auth/supplier/supplier_signup.dart';
import 'package:multi_vendor/provider/cart_provider.dart';
import 'package:multi_vendor/provider/stripe_id.dart';
import 'package:multi_vendor/provider/wishlist_provider.dart';
import 'package:provider/provider.dart';
import 'auth/customer/customer_signin.dart';
import 'auth/customer/customer_signup.dart';
import 'auth/supplier/supplier_signin.dart';
import 'firebase_options.dart';
import 'main_screens/customer_home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'main_screens/splash_screen.dart';
import 'main_screens/supplier_home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = stripePublishabelkey;
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Cart()),
        ChangeNotifierProvider(create: (_) => Wish()),
      ],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash_screen',
      routes: {
        '/splash_screen': (context) => const Splash_Screen(),
        '/customer_home': (context) => const Customer_Home_Screen(),
        '/supplier_home': (context) => const Supplier_Home_Screen(),
        '/customer_signup': (context) => const Customer_Signup_Screen(),
        '/customer_signin': (context) => const Customer_LogIn_Screen(),
        '/supplier_signup': (context) => const Supplier_Signup_Screen(),
        '/supplier_signin': (context) => const Supplier_LogIn_Screen(),
      },
    );
  }
}
