// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:flutter/material.dart';

class AllCategory extends StatefulWidget {
  const AllCategory({Key? key, required this.slug}) : super(key: key);
  final String slug;

  @override
  _AllCategoryState createState() => _AllCategoryState();
}

class _AllCategoryState extends State<AllCategory> {
  final List<MyGrid> data = [
    MyGrid(
      image:
          "https://th.bing.com/th/id/R.39ebbd2b6f50cd837b7839cbae3813cd?rik=W54%2bih8fsDP76w&riu=http%3a%2f%2fwww.bhphotovideo.com%2fimages%2fimages2500x2500%2fbeats_by_dr_dre_900_00109_01_studio_wireless_headphones_red_1016369.jpg&ehk=NfT%2bRJ73BF%2fyQBBJt5TZDIDu%2fWshOxWBOQ0YElt0bno%3d&risl=&pid=ImgRaw&r=0",
      title: "accessories",
      description: "10 Book In Category",
    ),
    MyGrid(
      image:
          "https://assets.pikiran-rakyat.com/crop/0x0:0x0/x/photo/2020/12/08/3531563792.jpg",
      title: "food",
      description: "10 Book In Category",
    ),
    MyGrid(
      image:
          "https://cdn.pixabay.com/photo/2019/03/15/09/49/girl-4056684_960_720.jpg",
      title: "tours",
      description: "10 Book In Category",
    ),
    MyGrid(
      image:
          "https://cdn.pixabay.com/photo/2020/09/18/19/31/laptop-5582775_960_720.jpg",
      title: "holidays",
      description: "10 Book In Category",
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "All Category",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        // centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        children: [
          Column(
            children: [
              SizedBox(
                height: 60,
              ),
              Container(
                // color: Colors.grey,
                height: 170,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Search Category",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      // color: Colors.blue,
                      width: 300,
                      child: Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
                        style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            // color: Colors.green,
                            width: 300,
                            height: 50,
                            child: TextFormField(
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.search,
                                  size: 20,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                      color: Colors.transparent, width: 0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                      color: Colors.transparent, width: 0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                filled: true,
                                fillColor: Colors.blue.withOpacity(0.2),
                                hintText: "Search . .. .",
                                hintStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // onSaved: (e) => txtname = e!,
                              // controller: txtusername,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Field is required";
                                }
                                return null;
                              },
                            ),
                          ),
                          // SizedBox(
                          //   width: 10,
                          // ),
                          // Container(
                          //   // color: Colors.blue,
                          //   width: 75,
                          //   height: 50,
                          //   child: Center(
                          //     child: Text(
                          //       "Search",
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(2),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => CategoryDetal(),
                          //   ),
                          // );
                          // print("hello");
                        },
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 1.0,
                                blurRadius: 5.0,
                              ),
                            ],
                            image: DecorationImage(
                              image: NetworkImage(data[index].image),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                height: 45,
                                width: 150,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(50),
                                    topRight: Radius.circular(50),
                                  ),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 10.0, top: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        data[index].title,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        data[index].description,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MyGrid {
  String image;
  String title;
  String description;
  MyGrid({
    required this.image,
    required this.title,
    required this.description,
  });
}
