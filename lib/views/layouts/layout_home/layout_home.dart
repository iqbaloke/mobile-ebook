// ignore_for_file: prefer_const_constructors

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:frontend1/views/layouts/layout_profile/layoutprofile.dart';
import 'package:frontend1/views/series/homes/home.dart';
import 'package:frontend1/views/series/search.dart';
import 'package:frontend1/views/series/transaction.dart';

class MainHome extends StatefulWidget {
  const MainHome({Key? key}) : super(key: key);

  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  int _current = 0;
  List component = [
    HomePages(),
    SearchPages(),
    TransactionPages(),
    LayoutProfile(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _current,
        showElevation: true,
        onItemSelected: (index) => setState(() {
          _current = index;
        }),
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: const Icon(Icons.home),
            title: const Text('Home'),
            activeColor: const Color(0xff2575fc),
          ),
          BottomNavyBarItem(
              icon: const Icon(Icons.search),
              title: const Text('Search'),
              activeColor: const Color(0xff2575fc)),
          BottomNavyBarItem(
              icon: const Icon(Icons.history),
              title: const Text('Transaction'),
              activeColor: const Color(0xff2575fc)),
          BottomNavyBarItem(
              icon: const Icon(Icons.person),
              title: const Text('my book'),
              activeColor: const Color(0xff2575fc)),
        ],
      ),
      body: component[_current],
    );
  }
}
