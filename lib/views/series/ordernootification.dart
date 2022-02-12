// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend1/app/config/api.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';

class OrderNotification extends StatefulWidget {
  final String usertoken;
  const OrderNotification({Key? key, required this.usertoken})
      : super(key: key);

  @override
  _OrderNotificationState createState() => _OrderNotificationState();
}

class _OrderNotificationState extends State<OrderNotification> {
  Future<List<dynamic>> getOrderNotification() async {
    final response = await http.get(
      Uri.parse(ApiConfig.apiUrl() + "orderNotification"),
      headers: {
        'Authorization': 'Bearer ${widget.usertoken}',
      },
    );
    // print(json.decode(response.body)["orderNotification"]);
    return json.decode(response.body)["orderNotification"];
  }

  OrderNotificationupdate(int idnotification) async {
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${widget.usertoken}',
    };
    var request = http.Request(
      'PATCH',
      Uri.parse(ApiConfig.apiUrl() + "updateorderNotification/$idnotification"),
    );

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      getOrderNotification();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f6f9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          "notification",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: (ListView(
        children: [
          FutureBuilder(
            future: getOrderNotification(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Center(child: CircularProgressIndicator());
              } else {
                if (snapshot.data.length < 1) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          height: 200,
                          width: 300,
                          // color: Colors.black,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: AssetImage("assets/images/nodata.jpg"),
                          )),
                        ),
                      ),
                    ],
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
                        child: LayoutBuilder(
                          builder: (BuildContext context,
                              BoxConstraints constraints) {
                            if (snapshot.data[index]["user_id"] ==
                                snapshot.data[index]["user_check"]) {
                              if (snapshot.data[index]["read_author"] == 1) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: GestureDetector(
                                    onTap: () => Alert(
                                      context: context,
                                      title: "DO YOU WANT DELETE BOOK ??",
                                      content: Column(
                                        children: [
                                          SizedBox(
                                            width: 20,
                                          )
                                        ],
                                      ),
                                      buttons: [
                                        DialogButton(
                                          child: Text(
                                            "Cancle",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18),
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          color:
                                              Color.fromRGBO(0, 179, 134, 1.0),
                                        ),
                                        DialogButton(
                                          color: Colors.red,
                                          child: Text(
                                            "Delete",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18),
                                          ),
                                          onPressed: () {
                                            // _deleteBook(slug);
                                          },
                                        )
                                      ],
                                    ).show(),
                                    child: Card(
                                      color: Colors.white,
                                      shadowColor: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "there is a purchase of your product, from ${snapshot.data[index]["order_user"]["name"]} !!!",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Divider(
                                              height: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  height: 50,
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                          "${snapshot.data[index]["book_id"]["thumbnail"]}"),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    "${snapshot.data[index]["book_id"]["title"]}",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: GestureDetector(
                                    onTap: () {
                                      var idnotification =
                                          snapshot.data[index]["id"];
                                      OrderNotificationupdate(idnotification);
                                    },
                                    child: Card(
                                      color: Colors.blue.withOpacity(0.5),
                                      shadowColor: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "there is a purchase of your product, from ${snapshot.data[index]["order_user"]["name"]} !!!",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Divider(
                                              height: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  height: 50,
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                          "${snapshot.data[index]["book_id"]["thumbnail"]}"),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    "${snapshot.data[index]["book_id"]["title"]}",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            } else {
                              if (snapshot.data[index]["read"] == 1) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Card(
                                    color: Colors.white,
                                    shadowColor: Colors.white,
                                    child: GestureDetector(
                                      onTap: () => Alert(
                                        context: context,
                                        title: "DO YOU WANT DELETE BOOK ??",
                                        content: Column(
                                          children: [
                                            SizedBox(
                                              width: 20,
                                            )
                                          ],
                                        ),
                                        buttons: [
                                          DialogButton(
                                            child: Text(
                                              "Cancle",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18),
                                            ),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            color: Color.fromRGBO(
                                                0, 179, 134, 1.0),
                                          ),
                                          DialogButton(
                                            color: Colors.red,
                                            child: Text(
                                              "Delete",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18),
                                            ),
                                            onPressed: () {
                                              // _deleteBook(slug);
                                            },
                                          )
                                        ],
                                      ).show(),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "congrats you can now read and download books",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Divider(
                                              height: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  height: 50,
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                          "${snapshot.data[index]["book_id"]["thumbnail"]}"),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    "${snapshot.data[index]["book_id"]["title"]}",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: GestureDetector(
                                    onTap: () {
                                      var idnotification =
                                          snapshot.data[index]["id"];
                                      setState(() {
                                        OrderNotificationupdate(idnotification);
                                      });
                                    },
                                    child: Card(
                                      color: Colors.blue.withOpacity(0.5),
                                      shadowColor: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "congrats you can now read and download books",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Divider(
                                              height: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  height: 50,
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                          "${snapshot.data[index]["book_id"]["thumbnail"]}"),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    "${snapshot.data[index]["book_id"]["title"]}",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      );
                    },
                  );
                }
              }
            },
          ),
        ],
      )),
    );
  }
}
