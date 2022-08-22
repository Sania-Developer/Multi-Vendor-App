import 'package:flutter/material.dart';
import 'package:multi_vendor/dashboard_components/preparing_order.dart';
import 'package:multi_vendor/dashboard_components/shipping_order.dart';
import 'package:multi_vendor/widgets/appbar_widgets.dart';

import 'delivered.dart';

class Orders extends StatelessWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const AppBarTitle(
            title: 'Orders',
          ),
          bottom: const TabBar(
            indicatorColor: Color(0xffE7A44D),
            tabs: [
              RepeatedTab(label: 'Preparing'),
              RepeatedTab(label: 'Shipping'),
              RepeatedTab(label: 'Delivered'),
            ],
          ),
          leading: const AppBarBackButton(),
        ),
        body: const TabBarView(
            children: [
              Preparing(),
              Shipping(),
              Delivered(),
            ]
        ),
      ),
    );
  }
}

class RepeatedTab extends StatelessWidget {
  final String label;
  const RepeatedTab({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Center(
        child: Text(label , style: const TextStyle(color: Colors.grey),),
      ),
    );
  }
}

