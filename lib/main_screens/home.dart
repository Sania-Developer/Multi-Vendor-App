import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_vendor/galleries/all_products.dart';
import 'package:multi_vendor/galleries/kids_gallery.dart';
import '../auth/repeated_tab.dart';
import '../galleries/accessories_gallery.dart';
import '../galleries/bags_gallery.dart';
import '../galleries/beauty_gallery.dart';
import '../galleries/electronics_gallery.dart';
import '../galleries/homegarden_gallery.dart';
import '../galleries/men_gallery.dart';
import '../galleries/shoes_gallery.dart';
import '../galleries/women_gallery.dart';
import '../widgets/fakesearch.dart';

class Home_Screen extends StatefulWidget {

  const Home_Screen({Key? key}) : super(key: key);

  @override
  _Home_ScreenState createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 10,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: FakeSearch(),
            ),
            centerTitle: true,
            primary: false,
            bottom: TabBar(
              padding: const EdgeInsets.only(left: 15),
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: const Color(0xffE7A44D))
              ),
              automaticIndicatorColorAdjustment: true,
              indicatorColor: Colors.white,
              isScrollable: true,
              labelPadding: const EdgeInsets.only(left: 24,right: 24),
              tabs: [
                RepeateTab(
                  label: 'All',
                ),
                RepeateTab(
                  label: 'Men',
                ),
                RepeateTab(
                  label: 'Women',
                ),
                RepeateTab(
                  label: 'Bags',
                ),
                RepeateTab(
                  label: 'Shoes',
                ),
                RepeateTab(
                  label: 'Electronics',
                ),
                RepeateTab(
                  label: 'Accessories',
                ),
                RepeateTab(
                  label: 'Home & Garden',
                ),
                RepeateTab(
                  label: 'Kids',
                ),
                RepeateTab(
                  label: 'Beauty',
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              All_Products(),
              MenGalleryScreen(),
              WomenGalleryScreen(),
              BagsGalleryScreen(),
              ShoesGalleryScreen(),
              ElectronicsGalleryScreen(),
              AccessoriesGalleryScreen(),
              HomeGardenGalleryScreen(),
              KidsGalleryScreen(),
              BeautyGalleryScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
