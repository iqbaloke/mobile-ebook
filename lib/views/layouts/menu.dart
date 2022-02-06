// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:frontend1/app/config/api.dart';
import 'package:frontend1/views/layouts/header.dart';
import 'package:frontend1/views/layouts/layout_home/layout_home.dart';
import 'package:frontend1/views/series/about.dart';
import 'package:frontend1/views/series/cart.dart';
import 'package:frontend1/views/series/profile/income.dart';
import 'package:frontend1/views/series/profile/myprofile.dart';
import 'package:frontend1/views/series/transaction.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MenuDrawer extends StatefulWidget {
  final VoidCallback signOut;
  const MenuDrawer({Key? key, required this.signOut}) : super(key: key);

  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

// late final String cart_count;

class Cart {
  final String cart_count;

  Cart({required this.cart_count});
  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(cart_count: json["cart_count"].toString());
  }
}

class _MenuDrawerState extends State<MenuDrawer> {
  var currentPage = DrawerSections.home;

  String? name, email, token;
  getPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      name = preferences.getString("name").toString();
      email = preferences.getString("email").toString();
      token = preferences.getString("token").toString();
    });
  }

  singOut() {
    setState(() {
      widget.signOut();
    });
  }

  Future<Cart> checkcart() async {
    final response = await http.get(
      Uri.parse(ApiConfig.apiUrl() + "cart/checkcart"),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return Cart.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      checkcart();
      getPreference();
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_typing_uninitialized_variables
    var container;
    // var usertoken = token.toString();
    if (currentPage == DrawerSections.home) {
      container = const MainHome();
    } else if (currentPage == DrawerSections.income) {
      container = const IncomePages();
    } else if (currentPage == DrawerSections.transaction) {
      container = const TransactionPages();
    } else if (currentPage == DrawerSections.cart) {
      container = CartPages(
        usertoken: token.toString(),
      );
    } else if (currentPage == DrawerSections.profile) {
      container = const YoProfile();
    } else if (currentPage == DrawerSections.about) {
      container = const AboutPages();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "E B O O K",
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        actions: [
          FutureBuilder(
            future: checkcart(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Text("");
              } else {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartPages(
                          usertoken: token.toString(),
                        ),
                      ),
                    );
                  },
                  child: Badge(
                    position: BadgePosition.topEnd(top: 3, end: -5),
                    badgeContent: Text(
                      "${snapshot.data!.cart_count}",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    badgeColor: Colors.blue,
                    child: Icon(Icons.notifications_active_outlined),
                  ),
                );
              }
            },
          ),
          SizedBox(
            width: 5,
          ),
          FutureBuilder(
            future: checkcart(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Text("");
              } else {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartPages(
                          usertoken: token.toString(),
                        ),
                      ),
                    );
                  },
                  child: Badge(
                    position: BadgePosition.topEnd(top: 3, end: -5),
                    badgeContent: Text(
                      "${snapshot.data!.cart_count}",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    badgeColor: Colors.blue,
                    child: Icon(Icons.shopping_cart_outlined),
                  ),
                );
              }
            },
          ),
          SizedBox(
            width: 15,
          ),
        ],
        elevation: 0,
      ),
      body: container,
      drawer: Drawer(
        child: SingleChildScrollView(
          // ignore: avoid_unnecessary_containers
          child: Container(
            child: Column(
              children: [
                const MyHeadderDrawer(),
                MyDrawerList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget MyDrawerList() {
    return Container(
      padding: const EdgeInsets.only(
        top: 15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // shows the list of menu drawer
        children: [
          menuItem(1, "Home", Icons.person,
              currentPage == DrawerSections.home ? true : false),
          menuItem(2, "Income", Icons.history,
              currentPage == DrawerSections.income ? true : false),
          menuItem(3, "Transaction", Icons.settings_outlined,
              currentPage == DrawerSections.transaction ? true : false),
          menuItem(4, "Cart", Icons.attach_money,
              currentPage == DrawerSections.cart ? true : false),
          const Divider(),
          menuItem(5, "Profile", Icons.info_outline,
              currentPage == DrawerSections.profile ? true : false),
          menuItem(6, "About Me", Icons.notifications_outlined,
              currentPage == DrawerSections.about ? true : false),
          const Divider(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: GestureDetector(
              onTap: () {
                singOut();
              },
              child: Row(
                children: [
                  Icon(
                    Icons.logout,
                    size: 20,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "Logout",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget menuItem(int id, String title, IconData icon, bool selected) {
    return Material(
      color: selected ? Colors.grey[300] : Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          setState(() {
            if (id == 1) {
              currentPage = DrawerSections.home;
            } else if (id == 2) {
              currentPage = DrawerSections.income;
            } else if (id == 3) {
              currentPage = DrawerSections.transaction;
            } else if (id == 4) {
              currentPage = DrawerSections.cart;
            } else if (id == 5) {
              currentPage = DrawerSections.profile;
            } else if (id == 6) {
              currentPage = DrawerSections.about;
            }
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(
                child: Icon(
                  icon,
                  size: 20,
                  color: Colors.black,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum DrawerSections {
  home,
  income,
  transaction,
  cart,
  profile,
  about,
}
