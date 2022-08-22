import 'package:flutter/material.dart';
import 'package:multi_vendor/galleries/accessories_gallery.dart';
import 'package:multi_vendor/galleries/bags_gallery.dart';
import 'package:multi_vendor/galleries/beauty_gallery.dart';
import 'package:multi_vendor/galleries/electronics_gallery.dart';
import 'package:multi_vendor/galleries/homegarden_gallery.dart';
import 'package:multi_vendor/galleries/kids_gallery.dart';
import 'package:multi_vendor/galleries/men_gallery.dart';
import 'package:multi_vendor/galleries/shoes_gallery.dart';
import 'package:multi_vendor/galleries/women_gallery.dart';
import 'package:multi_vendor/widgets/appbar_widgets.dart';
import '../widgets/fakesearch.dart';

class Category_Screen extends StatefulWidget {
  const Category_Screen({Key? key}) : super(key: key);

  @override
  _Category_ScreenState createState() => _Category_ScreenState();
}

class _Category_ScreenState extends State<Category_Screen> {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const FakeSearch(),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 24.0),
                child: Text(
                  'Categories:',
                  style: TextStyle(
                      color: Color(0xff00203F),
                      fontSize: 24.0,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Category_card(
                  category_name: 'Men',
                  image: 'men_icon',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Material(child: Scaffold(appBar: AppBar(
                              elevation: 0,
                               backgroundColor: Colors.white,
                               title: Text('Men',style: TextStyle(color: Color(0xff00203F)),),
                               centerTitle: true,
                               leading: const AppBarBackButton(),
                            ),body: MenGalleryScreen()))));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Category_card(
                  category_name: 'Women',
                  image: 'women_icon',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Material(child: Scaffold(appBar: AppBar(
                              elevation: 0,
                               backgroundColor: Colors.white,
                               title: const Text('Women',style: TextStyle(color: Color(0xff00203F)),),
                               centerTitle: true,
                               leading: const AppBarBackButton(),
                            ),body: WomenGalleryScreen()))));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Category_card(
                  category_name: 'Shoes',
                  image: 'shoes_icon',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Material(child: Scaffold(appBar: AppBar(
                              elevation: 0,
                               backgroundColor: Colors.white,
                               title: const Text('Shoes',style: TextStyle(color: Color(0xff00203F)),),
                               centerTitle: true,
                               leading: const AppBarBackButton(),
                            ),body: ShoesGalleryScreen()))));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Category_card(
                  category_name: 'Bags',
                  image: 'bags_icon',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Material(child: Scaffold(appBar: AppBar(
                              elevation: 0,
                               backgroundColor: Colors.white,
                               title: const Text('Bags',style: TextStyle(color: Color(0xff00203F)),),
                               centerTitle: true,
                               leading: const AppBarBackButton(),
                            ),body: BagsGalleryScreen()))));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Category_card(
                  category_name: 'Electronics',
                  image: 'electronics_icon',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Material(child: Scaffold(appBar: AppBar(
                              elevation: 0,
                               backgroundColor: Colors.white,
                               title: const Text('Electronics',style: TextStyle(color: Color(0xff00203F)),),
                               centerTitle: true,
                               leading: const AppBarBackButton(),
                            ),body: ElectronicsGalleryScreen()))));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Category_card(
                  category_name: 'Accessories',
                  image: 'accessories_icon',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Material(child: Scaffold(appBar: AppBar(
                              elevation: 0,
                               backgroundColor: Colors.white,
                               title: const Text('Accessories',style: TextStyle(color: Color(0xff00203F)),),
                               centerTitle: true,
                               leading: const AppBarBackButton(),
                            ),body: AccessoriesGalleryScreen()))));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Category_card(
                  category_name: 'Home & Garden',
                  image: 'home_garden_icon',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Material(child: Scaffold(appBar: AppBar(
                              elevation: 0,
                               backgroundColor: Colors.white,
                               title: const Text('Home & Garden',style: TextStyle(color: Color(0xff00203F)),),
                               centerTitle: true,
                               leading: const AppBarBackButton(),
                            ),body: HomeGardenGalleryScreen()))));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Category_card(
                  category_name: 'Kids',
                  image: 'kids_icon',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Material(child: Scaffold(appBar: AppBar(
                              elevation: 0,
                               backgroundColor: Colors.white,
                               title: const Text('Kids'),
                               centerTitle: true,
                               leading: const AppBarBackButton(),
                            ),body: KidsGalleryScreen()))));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Category_card(
                  category_name: 'Beauty',
                  image: 'beautry_icon',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Material(child: Scaffold(appBar: AppBar(
                              elevation: 0,
                               backgroundColor: Colors.white,
                               title: const Text('Beauty',style: TextStyle(color: Color(0xff00203F)),),
                               centerTitle: true,
                               leading: const AppBarBackButton(),
                            ),body: BeautyGalleryScreen()))));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Category_card extends StatelessWidget {
  late String image;
  late String category_name;
  late Function()? onTap;
  Category_card(
      {Key? key,
      required this.image,
      required this.category_name,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          child: Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
                color: const Color(0xffE7A44D),
                borderRadius: BorderRadius.circular(25)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image(
                      image: AssetImage('images/$image.png'),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Center(
                        child: Text(
                      category_name,
                      style: const TextStyle(
                          color: Color(0xff00203F),
                          fontSize: 24.0,
                          fontWeight: FontWeight.w600),
                    )),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.arrow_circle_right_sharp,
                        color: Color(0xff00203F),
                        size: 30,
                      )),
                ),
              ],
            ),
          )),
    );
  }
}