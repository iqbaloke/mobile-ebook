// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, non_constant_identifier_names, unrelated_type_equality_checks

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend1/app/config/api.dart';
import 'package:frontend1/views/series/categories/category_by_slug.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CategoryDetal extends StatefulWidget {
  const CategoryDetal({
    Key? key,
    required this.slug,
    required this.category_name,
    required this.book_count,
    required this.tag_count,    
  }) : super(key: key);
  final String slug;
  final String category_name;
  final int book_count;
  final int tag_count;  
  @override
  _CategoryDetalState createState() => _CategoryDetalState();
}

class _CategoryDetalState extends State<CategoryDetal> {
   String? name, email, token;
  getPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      name = preferences.getString("name").toString();
      email = preferences.getString("email").toString();
      token = preferences.getString("token").toString();
    });
  }

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

  Future<List<dynamic>> getCategory() async {
    final response = await http.get(
      Uri.parse(ApiConfig.apiUrl() +
          "category/single-category/${widget.category_name.toString()}"),
      headers: {'Authorization': 'Bearer $token'},
    );
    return json.decode(response.body)["detailcategory"];
  }

  Future<List<dynamic>> getCategorytag() async {
    final response = await http.get(
      Uri.parse(ApiConfig.apiUrl() +
          "category/categorytag/${widget.category_name.toString()}"),
      headers: {'Authorization': 'Bearer $token'},
    );
    return json.decode(response.body)["category_tag"];
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      getCategory();
      getCategorytag();
      getPreference();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f6f9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: SizedBox(
          height: 30,
          width: 30,
          child: FlatButton(
            color: Colors.white,
            onPressed: () {},
            child: Icon(Icons.arrow_back_ios),
          ),
        ),
        elevation: 0,
        title: Text(
          widget.slug.toString(),
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Padding(
              //   padding: const EdgeInsets.only(left: 8.0, top: 15, right: 8),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: const <Widget>[
              //       Text(
              //         "Tags In Category",
              //         style:
              //             TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              //       ),
              //     ],
              //   ),
              // ),
              SizedBox(
                height: 10,
              ),
              SingleChildScrollView(
                child: FutureBuilder(
                  future: getCategorytag(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.data == null) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      if (widget.tag_count < 1) {
                        return Padding(
                          padding: const EdgeInsets.all(15),
                          child: Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.red.withOpacity(0.3),
                            ),
                            child: Center(
                              child: Text(
                                "Uppsss Tags Not Found...",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.075,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.only(
                              bottom: 2.0,
                              top: 2.0,
                            ),
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              // print(snapshot.data.length);
                              return LayoutBuilder(
                                builder: (BuildContext context,
                                    BoxConstraints constraints) {
                                  if (widget.tag_count == "") {
                                    return Center(
                                      child: Text(
                                        "null",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    );
                                  } else {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CategoryBySlug(
                                              category_name: widget
                                                  .category_name
                                                  .toString(),
                                              tag_name: snapshot.data[index]
                                                      ["tag_name"]
                                                  .toString(),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Container(
                                          width: 100,
                                          height: 15,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.4),
                                                blurRadius: 2.0,
                                              )
                                            ],
                                          ),
                                          child: Center(
                                            child: Text(
                                              snapshot.data[index]["tag_name"],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                          ),
                        );
                      }
                    }
                  },
                ),
              ),
              // SizedBox(
              //   height: 20,
              // ),
              Divider(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "All Book In ${widget.category_name}",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      "${widget.book_count} book in category",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              // SizedBox(
              //   height: 15,
              // ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FutureBuilder(
                  future: getCategory(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.data == null) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      if (widget.book_count < 1) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 50),
                              child: Container(
                                height: 200,
                                width: 200,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image:
                                        AssetImage("assets/images/nodata.jpg"),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: (200.0 / 300.0),
                          ),
                          padding: EdgeInsets.only(bottom: 1),
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
                                          borderRadius:
                                              BorderRadius.circular(5),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                                spreadRadius: 1.0,
                                                blurRadius: 5.0,
                                              ),
                                            ],
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: const Icon(
                                              Icons.favorite_border,
                                              size: 16,
                                              color: Colors.red),
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
                                                color: Colors.grey
                                                    .withOpacity(0.2),
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
// SizedBox(
//               height: 50,
//             ),
//             Container(
//               height: 170,
//               width: MediaQuery.of(context).size.width,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   RichText(
//                       text: TextSpan(
//                     style: TextStyle(color: Colors.black),
//                     children: <TextSpan>[
//                       TextSpan(
//                         text: "Search Category ",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18,
//                         ),
//                       ),
//                       TextSpan(
//                         text: widget.category_name,
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.blue,
//                           fontSize: 18,
//                         ),
//                       ),
//                     ],
//                   )),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   Container(
//                     // color: Colors.blue,
//                     width: 300,
//                     child: Text(
//                       "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
//                       style: TextStyle(
//                         // fontWeight: FontWeight.bold,
//                         fontSize: 14,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(10),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Container(
//                           // color: Colors.green,
//                           width: 300,
//                           height: 40,
//                           child: TextFormField(
//                             decoration: InputDecoration(
//                               prefixIcon: const Icon(
//                                 Icons.search,
//                                 size: 20,
//                               ),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(20),
//                                 borderSide: const BorderSide(
//                                     color: Colors.transparent, width: 0),
//                               ),
//                               enabledBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(20),
//                                 borderSide: const BorderSide(
//                                     color: Colors.transparent, width: 0),
//                               ),
//                               contentPadding: const EdgeInsets.symmetric(
//                                 horizontal: 16,
//                                 vertical: 14,
//                               ),
//                               filled: true,
//                               fillColor: Colors.blue.withOpacity(0.2),
//                               hintText: "Search . .. .",
//                               hintStyle: const TextStyle(
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             // onSaved: (e) => txtname = e!,
//                             // controller: txtusername,
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return "Field is required";
//                               }
//                               return null;
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
