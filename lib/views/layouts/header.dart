// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHeadderDrawer extends StatefulWidget {
  const MyHeadderDrawer({Key? key}) : super(key: key);

  @override
  _MyHeadderDrawerState createState() => _MyHeadderDrawerState();
}

class _MyHeadderDrawerState extends State<MyHeadderDrawer> {
  String? name, email, token, thumbnail;
  getPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      name = preferences.getString("name").toString();
      email = preferences.getString("email").toString();
      token = preferences.getString("token").toString();
      thumbnail = preferences.getString("thumbnail").toString();
    });
  }

  @override
  void initState() {
    super.initState();
    getPreference();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff262aaa),
      width: double.infinity,
      height: 200,
      padding: const EdgeInsets.only(top: 40, left: 20),
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
            ),
          ),
          Row(
            children: [
              // LayoutBuilder(
              //   builder: (BuildContext context, BoxConstraints constraints) {
              //     if () {
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  // image: DecorationImage(
                  //   image: NetworkImage(
                  //     "$thumbnail",
                  //   ),
                  //   fit: BoxFit.cover,
                  // ),
                ),
              ),
              //     } else {
              //   return  Container(
              //   height: 80,
              //   width: 80,
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     shape: BoxShape.circle,
              //     image: DecorationImage(
              //       image: NetworkImage(
              //         "$thumbnail",
              //       ),
              //       fit: BoxFit.cover,
              //     ),
              //   ),
              // );
              //     }
              //   },
              // ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "$name",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "$email",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    // Text(
                    //   "$thumbnail",
                    //   style: TextStyle(
                    //     fontSize: 14,
                    //     color: Colors.white,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
