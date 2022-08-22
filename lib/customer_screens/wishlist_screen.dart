import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_vendor/models/wish_model.dart';
import 'package:multi_vendor/provider/wishlist_provider.dart';
import 'package:multi_vendor/widgets/alert_dialog.dart';
import 'package:multi_vendor/widgets/appbar_widgets.dart';
import 'package:provider/provider.dart';


class Wishllist_Screen extends StatefulWidget {
  @override
  _Wishllist_ScreenState createState() => _Wishllist_ScreenState();
}

class _Wishllist_ScreenState extends State<Wishllist_Screen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const AppBarTitle(
              title: 'Wishlist',
            ),
            elevation: 0,
            backgroundColor: Colors.white,
            leading: const AppBarBackButton(),
            actions: [
              context.watch<Wish>().getWishItem.isEmpty
                  ? const SizedBox()
                  : IconButton(
                  onPressed: () {
                    setState(() {
                      my_alert_dialog.showMy_Dialog(
                          context: context,
                          title: 'Clear Wishlist',
                          content: 'Are you sure to clear wishlist ?',
                          tabNo: () {
                            Navigator.pop(context);
                          },
                          tabYes: () {
                            context.read<Wish>().clearWish();
                            Navigator.pop(context);
                          });                      });
                  },
                  icon: const Icon(
                    Icons.delete_forever,
                    color: Color(0xff00203F),
                  )),
            ],
          ),
          body: context.watch<Wish>().getWishItem.isNotEmpty
              ? WishItem()
              : const EmptyWishlist(),
        ),
      ),
    );
  }

  Consumer<Wish> WishItem() {
    return Consumer<Wish>(builder: (context, wish, child) {
      return ListView.builder(
          itemCount: wish.count,
          itemBuilder: (context, index) {
            final product = wish.getWishItem[index];
            return Wishlist_Model(product: product,);
          });
    });
  }
}

class EmptyWishlist extends StatelessWidget {
  const EmptyWishlist({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 150.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const[
           Image(image: AssetImage('images/empty_wishlist.png')),
           Text(
            'Your Wishlist is Empty',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5),
          ),
           Text(
            'You have not item in the wishlist yet',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
