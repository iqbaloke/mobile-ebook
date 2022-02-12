// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend1/app/config/api.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CategoryBySlug extends StatefulWidget {
  const CategoryBySlug(
      {Key? key, required this.tag_name, required this.category_name})
      : super(key: key);
  final String tag_name;
  final String category_name;
  @override
  _CategoryBySlugState createState() => _CategoryBySlugState();
}

class _CategoryBySlugState extends State<CategoryBySlug> {
  Text _buildRatingStars(int rating) {
    String stars = '';
    for (int i = 0; i < rating; i++) {
      stars += '⭐';
    }
    stars.trim();
    return Text(
      stars,
      style: const TextStyle(fontSize: 12),
    );
  }

  String? name, email, token;
  getPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      name = preferences.getString("name").toString();
      email = preferences.getString("email").toString();
      token = preferences.getString("token").toString();
    });
  }

  Future<List<dynamic>> getBookTag() async {
    final response = await http.get(
      Uri.parse(ApiConfig.apiUrl() +
          "category/booktag/${widget.category_name.toString()}/${widget.tag_name.toString()}"),
      headers: {
        'Authorization': 'Bearer $token'
      },
    );
    // print(json.decode(response.body)["book"]);
    return json.decode(response.body)["book"];
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      getBookTag();
      getPreference();
    });
  }

  List<String> imageList = [
    'assets/images/book.png',
    'assets/images/book.png',
    'assets/images/book.png',
    'assets/images/book.png',
    'assets/images/book.png',
    'assets/images/book.png',
    'assets/images/book.png',
    'assets/images/book.png',
    'assets/images/book.png',
    'assets/images/book.png',
    'assets/images/book.png',
    'assets/images/book.png',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f6f9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.tag_name,
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        // centerTitle: true,
        elevation: 1,
      ),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     children: <Widget>[
              //       Container(
              //         // color: Colors.grey,
              //         width: 50,
              //         height: 40,
              //         child: Center(
              //           child: Icon(
              //             Icons.filter_list_outlined,
              //             color: Colors.blue,
              //           ),
              //         ),
              //       ),
              //       Expanded(
              //         child: SingleChildScrollView(
              //           child: SizedBox(
              //             height: 40,
              //             child: ListView(
              //               scrollDirection: Axis.horizontal,
              //               children: <Widget>[
              //                 Container(
              //                   width: 100,
              //                   decoration: BoxDecoration(
              //                     borderRadius: BorderRadius.circular(5),
              //                     color: Colors.white,
              //                     border: Border.all(
              //                       color: Colors.blueAccent,
              //                     ),
              //                   ),
              //                   child: Center(
              //                     child: Text("Tags"),
              //                   ),
              //                 ),
              //                 SizedBox(
              //                   width: 10,
              //                 ),
              //                 Container(
              //                   width: 100,
              //                   decoration: BoxDecoration(
              //                     borderRadius: BorderRadius.circular(5),
              //                     color: Colors.white,
              //                     border: Border.all(
              //                       color: Colors.blueAccent,
              //                     ),
              //                   ),
              //                   child: Center(
              //                     child: Text("Price"),
              //                   ),
              //                 ),
              //                 SizedBox(
              //                   width: 10,
              //                 ),
              //                 Container(
              //                   width: 100,
              //                   decoration: BoxDecoration(
              //                     borderRadius: BorderRadius.circular(5),
              //                     color: Colors.white,
              //                     border: Border.all(
              //                       color: Colors.blueAccent,
              //                     ),
              //                   ),
              //                   child: Center(
              //                     child: Text("Starts"),
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // Divider(
              //   height: 10,
              //   color: Colors.blue,
              // ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FutureBuilder(
                  future: getBookTag(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.data == null) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: (200.0 / 300.0),
                        ),
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: 165,
                              margin: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 1.0,
                                    blurRadius: 5.0,
                                  ),
                                ],
                                color: Colors.white,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Container(
                                      height: 80,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(snapshot
                                              .data[index]["thumbnail"]
                                              .toString()),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.white,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          LayoutBuilder(
                                            builder: (BuildContext context,
                                                BoxConstraints constraints) {
                                              if (snapshot.data[index]
                                                          ["payment"]
                                                      .toString() ==
                                                  "0") {
                                                return Container(
                                                  height: 35,
                                                  width: 70,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: Colors.blue
                                                        .withOpacity(0.7),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "free",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                return Text("");
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                      snapshot.data[index]["title"],
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 2),
                                    child: Row(
                                      children: [
                                        Text(
                                          snapshot.data[index]["category_id"]
                                              ["category_name"],
                                          style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          snapshot.data[index]["tag_id"]
                                              ["tag_name"],
                                          style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Row(
                                      children: [
                                        _buildRatingStars(1),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "${snapshot.data[index]["order_count"]} sale",
                                          style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          "${snapshot.data[index]["price"]}",
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "inStok",
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    height: 20,
                                    thickness: 1,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 25,
                                        width: 80,
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            "Add to card",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                        height: 25,
                                        width: 25,
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.2),
                                              spreadRadius: 1.0,
                                              blurRadius: 5.0,
                                            ),
                                          ],
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: const Icon(Icons.favorite_border,
                                            size: 16, color: Colors.red),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                        height: 25,
                                        width: 25,
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.2),
                                              spreadRadius: 1.0,
                                              blurRadius: 5.0,
                                            ),
                                          ],
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: const Icon(Icons.share,
                                            size: 16, color: Colors.blue),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
