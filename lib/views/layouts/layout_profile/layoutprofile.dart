// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:frontend1/views/series/profile/book/mybook.dart';
import 'package:frontend1/views/series/profile/dashborad.dart';
import 'package:frontend1/views/series/profile/income.dart';
import 'package:frontend1/views/series/profile/myprofile.dart';
import 'package:frontend1/views/series/profile/purchased.dart';

class LayoutProfile extends StatefulWidget {
  const LayoutProfile({Key? key}) : super(key: key);

  @override
  _LayoutProfileState createState() => _LayoutProfileState();
}

class _LayoutProfileState extends State<LayoutProfile>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollViewController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 5);
    _scrollViewController = ScrollController(initialScrollOffset: 0.0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollViewController,
        headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
          return <Widget>[
            // SliverToBoxAdapter(
            //   child: Container(
            //     height: 200,
            //     decoration: BoxDecoration(
            //       color: Colors.white,
            //       borderRadius: BorderRadius.circular(5),
            //       boxShadow: [
            //         BoxShadow(
            //           color: Colors.grey.withOpacity(0.1),
            //           spreadRadius: 1.0,
            //           blurRadius: 5.0,
            //         ),
            //       ],
            //     ),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: <Widget>[
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             Padding(
            //               padding: const EdgeInsets.only(top: 20.0, left: 20),
            //               child: Container(
            //                 height: 75,
            //                 width: 75,
            //                 decoration: BoxDecoration(
            //                   gradient: const LinearGradient(
            //                     begin: Alignment.centerLeft,
            //                     end: Alignment.centerRight,
            //                     colors: [Color(0xff92fe9d), Color(0xff00c9ff)],
            //                   ),
            //                   borderRadius: BorderRadius.circular(50),
            //                   boxShadow: [
            //                     BoxShadow(
            //                       color: Colors.grey.withOpacity(0.3),
            //                       spreadRadius: 1.0,
            //                       blurRadius: 5.0,
            //                     ),
            //                   ],
            //                 ),
            //                 child: const Center(
            //                   child: Icon(
            //                     Icons.people,
            //                     color: Colors.white,
            //                   ),
            //                 ),
            //               ),
            //             ),
            //             Padding(
            //               padding: const EdgeInsets.only(
            //                   left: 10, right: 10, top: 30),
            //               child: Row(
            //                 children: [
            //                   SizedBox(
            //                     height: 40,
            //                     width: 70,
            //                     child: Column(
            //                       children: const [
            //                         Text(
            //                           "40",
            //                           style: TextStyle(
            //                               fontSize: 14,
            //                               color: Colors.black,
            //                               fontWeight: FontWeight.bold),
            //                         ),
            //                         SizedBox(
            //                           height: 5,
            //                         ),
            //                         Text(
            //                           "Product",
            //                           style: TextStyle(
            //                               fontSize: 12,
            //                               color: Colors.black,
            //                               fontWeight: FontWeight.bold),
            //                         ),
            //                       ],
            //                     ),
            //                   ),
            //                   SizedBox(
            //                     height: 40,
            //                     width: 70,
            //                     child: Column(
            //                       children: const [
            //                         Text(
            //                           "10",
            //                           style: TextStyle(
            //                               fontSize: 14,
            //                               color: Colors.black,
            //                               fontWeight: FontWeight.bold),
            //                         ),
            //                         SizedBox(
            //                           height: 5,
            //                         ),
            //                         Text(
            //                           "Follow",
            //                           style: TextStyle(
            //                               fontSize: 12,
            //                               color: Colors.black,
            //                               fontWeight: FontWeight.bold),
            //                         ),
            //                       ],
            //                     ),
            //                   ),
            //                   SizedBox(
            //                     height: 40,
            //                     width: 70,
            //                     child: Column(
            //                       children: const [
            //                         Text(
            //                           "126",
            //                           style: TextStyle(
            //                               fontSize: 14,
            //                               color: Colors.black,
            //                               fontWeight: FontWeight.bold),
            //                         ),
            //                         SizedBox(
            //                           height: 5,
            //                         ),
            //                         Text(
            //                           "Followers",
            //                           style: TextStyle(
            //                             fontSize: 12,
            //                             color: Colors.black,
            //                             fontWeight: FontWeight.bold,
            //                           ),
            //                         ),
            //                       ],
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ],
            //         ),
            //         Padding(
            //           padding: const EdgeInsets.only(left: 20.0, top: 15),
            //           child: Row(
            //             children: const [
            //               Text(
            //                 "Content Creators",
            //                 style: TextStyle(color: Colors.grey, fontSize: 12),
            //               ),
            //               SizedBox(
            //                 width: 5,
            //               ),
            //               Icon(
            //                 Icons.verified,
            //                 color: Colors.blue,
            //                 size: 18,
            //               ),
            //             ],
            //           ),
            //         ),
            //         const Padding(
            //           padding: EdgeInsets.only(left: 20.0),
            //           child: Text(
            //             "Iqbal Wahyudi",
            //             style: TextStyle(
            //               fontSize: 16,
            //               fontWeight: FontWeight.bold,
            //             ),
            //           ),
            //         ),
            //         const Padding(
            //           padding: EdgeInsets.only(left: 20.0, top: 5),
            //           child: Text(
            //             "hello, my name is Iqbal Wahyudi. I am a web developer, android developer who started my career from 2018 ago.",
            //             style: TextStyle(color: Colors.grey, fontSize: 12),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            SliverAppBar(
              expandedHeight: 50,
              backgroundColor: Colors.white,
              pinned: true,
              floating: true,
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(50),
                  ),
                ),
              ),
              bottom: TabBar(
                controller: _tabController,
                labelColor: Colors.blue,
                isScrollable: true,
                unselectedLabelColor: Colors.black,
                tabs: const <Widget>[
                  Tab(
                    text: "dashbard",
                  ),
                  Tab(
                    text: "profile",
                  ),
                  Tab(
                    text: "my book",
                  ),
                  Tab(
                    text: "income",
                  ),
                  Tab(
                    text: "purchased",
                  ),
                ],
              ),
            )
          ];
        },
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: TabBarView(
            controller: _tabController,
            children: const <Widget>[
              DashboardPages(),
              YoProfile(),
              MyBookPages(),
              IncomePages(),
              PurchasedPage(),
            ],
          ),
        ),
      ),
    );
  }
}
