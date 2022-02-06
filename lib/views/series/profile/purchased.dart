// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend1/app/config/api.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PurchasedPage extends StatefulWidget {
  const PurchasedPage({Key? key}) : super(key: key);

  @override
  _PurchasedPageState createState() => _PurchasedPageState();
}

class _PurchasedPageState extends State<PurchasedPage> {
  String? name, email, token;
  getPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      name = preferences.getString("name").toString();
      email = preferences.getString("email").toString();
      token = preferences.getString("token").toString();
    });
  }

  Future<List<dynamic>> fecthpurchased() async {
    final response = await http.get(
      Uri.parse(ApiConfig.apiUrl() + "dashboard/purchased"),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    // print(json.decode(response.body)["data"]);
    return json.decode(response.body)["data"];
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      fecthpurchased();
      getPreference();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f6f9),
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
                  "Your Purchased book",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                FutureBuilder(
                  future: fecthpurchased(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.data == null) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                              text: "You have",
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: " : ${snapshot.data.length} book purchased",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
                Divider(
                  height: 10,
                  thickness: 1.5,
                ),
                FutureBuilder(
                  future: fecthpurchased(),
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
                          return Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Container(
                              height: 200,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.7),
                                    blurRadius: 2.0,
                                  ),
                                ],
                                color: Colors.white,
                              ),
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Container(
                                      height: 50,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              LayoutBuilder(
                                                builder: (BuildContext context,
                                                    BoxConstraints
                                                        constraints) {
                                                  if (snapshot.data[index]
                                                              ["book"]
                                                              ["user_id"]
                                                              ["thumbnail"]
                                                          .toString() ==
                                                      "null") {
                                                    return Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      width: 40,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        color: Colors.teal[100],
                                                        image: DecorationImage(
                                                          image: AssetImage(
                                                            "assets/images/book.png",
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  } else {
                                                    return Container(
                                                      width: 40,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        image: DecorationImage(
                                                          image: NetworkImage(
                                                            snapshot.data[index]
                                                                    ["book"]
                                                                    ["user_id"][
                                                                    "thumbnail"]
                                                                .toString()
                                                                .toString(),
                                                          ),
                                                          fit: BoxFit.cover,
                                                        ),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.7),
                                                            blurRadius: 2.0,
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  }
                                                },
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    snapshot.data[index]["book"]
                                                        ["user_id"]["name"],
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  Text(
                                                    "${snapshot.data[index]["book"]["order_count"]} book sales",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 10,
                                                        color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Icon(
                                            Icons.more_vert,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    height: 10,
                                    thickness: 1.5,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 75,
                                          width: 75,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                snapshot.data[index]["book"]
                                                        ["thumbnail"]
                                                    .toString(),
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.7),
                                                blurRadius: 2.0,
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                snapshot.data[index]["book"]
                                                    ["title"],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 3,
                                              ),
                                              Text(
                                                snapshot.data[index]["book"]
                                                        ["created_at"]
                                                    .toString(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey,
                                                  fontSize: 10,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Page Book : ",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  Text(
                                                    snapshot.data[index]["book"]
                                                            ["category_id"]
                                                            ["category_name"]
                                                        .toString(),
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 3,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "File Book : ",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  Text(
                                                    snapshot.data[index]["book"]
                                                            ["file_id"]["name"]
                                                        .toString(),
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          // var id = snapshot.data[index]["id"];
                                          // setState(() {
                                          //   deleteCart(id);
                                          // });
                                        },
                                        child: Container(
                                          height: 30,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(7),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "delete",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          // var cart_id =
                                          //     snapshot.data[index]["id"];
                                          // var slug = snapshot.data[index]
                                          //         ["book"]["slug"]
                                          //     .toString();
                                          // setState(() {
                                          //   checkout(cart_id, slug);
                                          // });
                                        },
                                        child: Container(
                                          height: 30,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius:
                                                BorderRadius.circular(7),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "read book",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
