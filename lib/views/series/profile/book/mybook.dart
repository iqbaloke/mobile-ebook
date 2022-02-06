// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_local_variable, avoid_unnecessary_containers, sized_box_for_whitespace

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend1/app/config/api.dart';
import 'package:frontend1/app/config/network.dart';
import 'package:frontend1/views/series/profile/book/createbook.dart';
import 'package:frontend1/views/series/profile/book/updatebook.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyBookPages extends StatefulWidget {
  const MyBookPages({Key? key}) : super(key: key);

  @override
  _MyBookPagesState createState() => _MyBookPagesState();
}

class _MyBookPagesState extends State<MyBookPages> {
  _deleteBook(String slug) async {
    final response = await http.delete(
      Uri.parse(ApiConfig.apiUrl() + "book/creator/bookdelete/$slug"),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer 2|REtIUQLUecTleqVgIuG3qFd8gVMEYjru34btOfYf',
      },
    );
    var message = jsonDecode(response.body);
    if (response.statusCode == 200) {
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
    }
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

  Future<List<dynamic>> myBook() async {
    final response = await http.get(
      Uri.parse(ApiConfig.apiUrl() + "book/creator/my-book"),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
    return json.decode(response.body)["mybook"];
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      myBook();
      getPreference();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          // var tokenuser = token;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateBook(
                tokenuser: token.toString(),
              ),
            ),
          );
        },
        child: Center(
          child: Icon(
            Icons.add,
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "All Book",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                FutureBuilder(
                  future: myBook(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.data == null) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Text(
                        "You Have ${snapshot.data.length} book",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          Divider(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: FutureBuilder(
                future: myBook(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (snapshot.data.length < 1) {
                      return Column(
                        children: [
                          SizedBox(
                            height: 15,
                          ),
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
                          SizedBox(
                            height: 15,
                          ),
                          Center(
                            child: Container(
                              height: 35,
                              width: 100,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                child: Text(
                                  "create book",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1.0,
                                blurRadius: 5.0,
                              ),
                            ],
                            color: Colors.white,
                          ),
                          child: DataTable(
                            dataRowHeight: 60,
                            columns: const [
                              DataColumn(
                                label: Text(
                                  "image",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataColumn(
                                numeric: false,
                                label: Text(
                                  "book name",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                tooltip: "Product Name",
                              ),
                              DataColumn(
                                label: Text(
                                  "Status",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  "Action",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                            rows: List.generate(
                              snapshot.data.length,
                              (index) {
                                final title =
                                    snapshot.data[index]["title"].toString();

                                final category = snapshot.data[index]
                                        ["category_id"]["category_name"]
                                    .toString();

                                final tag = snapshot.data[index]["tag_id"]
                                        ["tag_name"]
                                    .toString();
                                final slug =
                                    snapshot.data[index]["slug"].toString();
                                final price =
                                    snapshot.data[index]["price"].toString();
                                final thumbnail = snapshot.data[index]
                                        ["thumbnail"]
                                    .toString();
                                final file_id = snapshot.data[index]["file_id"]
                                        ["name"]
                                    .toString();
                                final description = snapshot.data[index]
                                        ["description"]
                                    .toString();
                                final page =
                                    snapshot.data[index]["page"].toString();
                                final book_file = snapshot.data[index]
                                        ["book_file"]
                                    .toString();

                                final b = snapshot.data[index]["order_count"]
                                    .toString();
                                final c =
                                    snapshot.data[index]["publish"].toString();
                                final d =
                                    snapshot.data[index]["approved"].toString();
                                final e =
                                    snapshot.data[index]["publish"].toString();
                                final f =
                                    snapshot.data[index]["reviews"].toString();
                                return DataRow(cells: [
                                  DataCell(
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          image: DecorationImage(
                                            image: NetworkImage(thumbnail),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Container(
                                      width: 100,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            title,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "sale :" + b + " order",
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.black,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            "reviewa : " + f + " reviews",
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.black,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "publish",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            c == "1"
                                                ? Icon(
                                                    Icons.check_sharp,
                                                    color: Colors.blue,
                                                    size: 14,
                                                  )
                                                : Icon(
                                                    Icons.clear,
                                                    color: Colors.red,
                                                    size: 14,
                                                  ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "approved",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            d == "1"
                                                ? Icon(
                                                    Icons.check_sharp,
                                                    color: Colors.blue,
                                                    size: 14,
                                                  )
                                                : Icon(
                                                    Icons.clear,
                                                    color: Colors.red,
                                                    size: 14,
                                                  ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  DataCell(
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    UpdateBook(
                                                  oldtitle: title,
                                                  oldcategory: category,
                                                  oldtag: tag,
                                                  oldslug: slug,
                                                  oldprice: price,
                                                  oldthumbnail: thumbnail,
                                                  oldfile_id: file_id,
                                                  olddescription: description,
                                                  oldpage: page,
                                                  oldbook_file: book_file,
                                                  oldpublish: c,
                                                  tokenuser: token.toString(),
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            height: 20,
                                            width: 70,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color:
                                                  Colors.blue.withOpacity(0.8),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                "update",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        GestureDetector(
                                          onTap: () => Alert(
                                            context: context,
                                            title: "DO YOU WANT DELETE BOOK ??",
                                            content: Column(
                                              children: [
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "title",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        ": " + title,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 3,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Sale",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        ": " + b,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 3,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "count",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        ": " + b,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
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
                                                  _deleteBook(slug);
                                                },
                                              )
                                            ],
                                          ).show(),
                                          child: Container(
                                            height: 20,
                                            width: 70,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color:
                                                  Colors.red.withOpacity(0.8),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                "delete",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]);
                              },
                            ),
                          ),
                        ),
                      );
                    }
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
