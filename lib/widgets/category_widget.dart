import 'package:flutter/material.dart';

import '../mini_screens/subcategory_produts.dart';


class SliderBar extends StatelessWidget {
  final String categoryname;
  const SliderBar({Key? key, required this.categoryname}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      width: MediaQuery.of(context).size.width * 0.05,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.brown.withOpacity(0.2),
              borderRadius: BorderRadius.circular(50)),
          child: RotatedBox(
            quarterTurns: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                categoryname == 'beauty'
                    ? const Text('')
                    : const Text(' << ', style: style),
                Text(categoryname.toUpperCase(), style: style),
                categoryname == 'men'
                    ? const Text('')
                    : const Text(' >> ', style: style),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

const style = TextStyle(
    color: Colors.brown,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 10);

class SubCategModel extends StatelessWidget {
  final String maincategname;
  final String subcategname;
  final String assetsname;
  final String assetlabel;
  const SubCategModel(
      {Key? key,
        required this.assetsname,
        required this.maincategname,
        required this.subcategname,
        required this.assetlabel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SubCategory_Product(
                  maincateg_name: maincategname,
                  subcateg_name: subcategname,
                )));
      },
      child: Column(
        children: [
          SizedBox(
            height: 70,
            width: 70,
            child: Image(
              image: AssetImage(assetsname),
            ),
          ),
          Text(
            assetlabel,
            style: const TextStyle(fontSize: 11),
          )
        ],
      ),
    );
  }
}

class CategHeaderLabel extends StatelessWidget {
  final String headerlabel;
  const CategHeaderLabel({Key? key, required this.headerlabel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 170.0,left: 20,bottom: 30),
      child: Text(
        headerlabel,
        style: const TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.5),
      ),
    );
  }
}
