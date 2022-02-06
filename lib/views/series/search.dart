// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:frontend1/app/config/network.dart';

import 'categories/detail_category.dart';

class SearchPages extends StatefulWidget {
  const SearchPages({Key? key}) : super(key: key);

  @override
  _SearchPagesState createState() => _SearchPagesState();
}

class _SearchPagesState extends State<SearchPages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(
              10.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Category",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  height: 10,
                  thickness: 1.5,
                ),
                FutureBuilder(
                  future: fetchCategory(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.data == null) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return ListView.builder(
                        padding: const EdgeInsets.only(bottom: 1.0),
                        itemCount: snapshot.data.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              var category_name = snapshot.data[index]
                                      ["category_name"]
                                  .toString();

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (contex) => CategoryDetal(
                                    slug:
                                        snapshot.data[index]["slug"].toString(),
                                    category_name: snapshot.data[index]
                                        ["category_name"],
                                    book_count: snapshot.data[index]
                                        ["book_count"],
                                    tag_count: snapshot.data[index]["tag_count"],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.only(top: 5),
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            snapshot.data[index]
                                                ["category_name"],
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            snapshot.data[index]["book_count"]
                                                    .toString() +
                                                " book",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            size: 14,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    height: 20,
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
                Text(
                  "Tag",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  height: 10,
                  thickness: 1.5,
                ),
                FutureBuilder(
                  future: fetchtag(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.data == null) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return ListView.builder(
                        padding: const EdgeInsets.only(bottom: 1.0),
                        itemCount: snapshot.data.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            // onTap: () {
                            //   Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) => CategoryBySlug(
                            //         tag_name:
                            //             snapshot.data[index]["tag_name"].toString(),
                            //       ),
                            //     ),
                            //   );
                            // },
                            child: Container(
                              padding: EdgeInsets.only(top: 5),
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            snapshot.data[index]["tag_name"],
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Row(
                                      //   children: [
                                      //     Text(
                                      //       snapshot.data[index]["book_count"]
                                      //               .toString() +
                                      //           " book",
                                      //       style: TextStyle(
                                      //         fontWeight: FontWeight.bold,
                                      //         fontSize: 12,
                                      //         color: Colors.grey,
                                      //       ),
                                      //     ),
                                      //     SizedBox(
                                      //       width: 5,
                                      //     ),
                                      //     Icon(
                                      //       Icons.arrow_forward_ios,
                                      //       size: 14,
                                      //     ),
                                      //     SizedBox(
                                      //       width: 5,
                                      //     ),
                                      //   ],
                                      // ),
                                    ],
                                  ),
                                  Divider(
                                    height: 20,
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
