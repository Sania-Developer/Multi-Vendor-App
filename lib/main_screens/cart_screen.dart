import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_vendor/widgets/alert_dialog.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import '../mini_screens/place_order_screen.dart';
import '../models/cart_model.dart';
import '../provider/cart_provider.dart';
import '../widgets/appbar_widgets.dart';
import '../widgets/elevated_button.dart';


class Cart_Screen extends StatefulWidget {
  final Widget? leading_back;
  const Cart_Screen({this.leading_back});

  @override
  _Cart_ScreenState createState() => _Cart_ScreenState();
}

class _Cart_ScreenState extends State<Cart_Screen> {
  @override
  Widget build(BuildContext context) {
    double total = context.watch<Cart>().totalprice;
    return Material(
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const AppBarTitle(
                title: 'Cart',
              ),
              elevation: 0,
              backgroundColor: Colors.white,
              leading: widget.leading_back,
              actions: [
                context.watch<Cart>().getItem.isEmpty
                    ? const SizedBox()
                    : IconButton(
                    onPressed: () {
                      setState(() {
                        my_alert_dialog.showMy_Dialog(
                            context: context,
                            title: 'Clear Cart',
                            content: 'Are you sure to clear cart ?',
                            tabNo: () {
                              Navigator.pop(context);
                            },
                            tabYes: () {
                              context.read<Cart>().clearCart();
                              Navigator.pop(context);
                            });
                      });
                    },
                    icon: const Icon(
                      Icons.delete_forever,
                      color: Color(0xff00203F),
                    )),
              ],
            ),
            body: context.watch<Cart>().getItem.isNotEmpty
                ? CartItem()
                : const EmptyCart(),
            bottomSheet:context.watch<Cart>().getItem.isNotEmpty
                ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          '  Total: \$',
                          style: TextStyle(fontSize: 18.0,color: Color(0xff00203F)),
                        ),
                        Text(
                          total.toStringAsFixed(2),
                          style: const TextStyle(
                              fontSize: 20.0,
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xffE7A44D),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Elevated_button(
                        width: 150,
                        height: 60,
                        text: 'CHECK OUT',
                        onPressed: total == 0.0
                            ? null
                            : () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Place_Order_Screen()));
                        },
                      ),
                    )
                  ],
                ),
              ),
            )
                : const EmptyCart() ),
      ),
    );
  }

  Consumer<Cart> CartItem() {
    return Consumer<Cart>(builder: (context, cart, child) {
      return ListView.builder(
          itemCount: cart.count,
          itemBuilder: (context, index) {
            final product = cart.getItem[index];
            return Cart_Model(
              product: product,
              cart: cart,
            );
          });
    });
  }
}

class EmptyCart extends StatelessWidget {
  const EmptyCart({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 150.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Image(image: AssetImage('images/empty_cart.png')),
          const Text(
            'Your Cart is Empty',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5),
          ),
          const Text(
            'You have not item in the cart yet',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 40,),
          Elevated_button(text: 'Continue Shopping', width: 300, height: 60,onPressed: () {
            Navigator.canPop(context)
                ? Navigator.pop(context)
                : Navigator.pushReplacementNamed(context, '/customer_home');
          },),
        ],
      ),
    );
  }
}


