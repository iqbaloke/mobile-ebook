// ignore_for_file: prefer_const_constructors, deprecated_member_use, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, dead_code, prefer_typing_uninitialized_variables, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend1/app/config/api.dart';
import 'package:frontend1/screen/register.dart';
import 'package:frontend1/views/layouts/menu.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

enum LoginStatus {
  notSigIn,
  sigIn,
}

class _LoginPageState extends State<LoginPage> {
  LoginStatus _loginStatus = LoginStatus.notSigIn;

  late String txtusername, txtpassword;
  final _key = GlobalKey<FormState>();

  bool _secureText = true;
  showSecure() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  _check() {
    final form = _key.currentState;
    if (form!.validate()) {
      form.save();
      _login();
      // print("${txtusername}, ${txtpassword}");
    }
  }

  _login() async {
    final response = await http.post(
      Uri.parse(ApiConfig.apiUrl() + "login"),
      body: {
        'email': txtusername,
        'password': txtpassword,
      },
      headers: {
        'Accept': 'application/json',
      },
    );
    var value = response.statusCode;
    if (value == 200) {
      var data = jsonDecode(response.body);
      var token = data["token"];
      var name = data["user"]["name"];
      var email = data["user"]["email"];
      var thumbnail = data["user"]["thumbnail"];
      setState(() {
        _loginStatus = LoginStatus.sigIn;
        savePreference(value, token, name, email, thumbnail);
      });
    } else {
      print("please check email and password");
    }
  }

  savePreference(int value, String token, name, email, thumbnail) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.setString("name", name);
      preferences.setString("email", email);
      preferences.setString("token", token);
      preferences.setString("thumbnail", thumbnail);
      preferences.commit();
    });
  }

  var value;
  getPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value");
      _loginStatus = value != 1 ? LoginStatus.sigIn : LoginStatus.notSigIn;
    });
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", 1);
      preferences.commit();
      _loginStatus = LoginStatus.notSigIn;
    });
  }

  @override
  void initState() {
    super.initState();
    getPreference();
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSigIn:
        return Scaffold(
          backgroundColor: Color(0xfff5f6f9),
          body: Form(
            key: _key,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 75, left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        "Hello,",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        "Wellcome Back",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(
                        height: 70,
                      ),
                      // email
                      TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.email,
                            size: 20,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: Colors.transparent, width: 0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: Colors.transparent, width: 0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          filled: true,
                          fillColor: Colors.blue.withOpacity(0.2),
                          hintText: "Example@gmail.com",
                          hintStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onSaved: (e) => txtusername = e!,
                        // controller: txtusername,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Field is required";
                          }
                          return null;
                        },
                      ),
                      // end email
                      const SizedBox(
                        height: 15,
                      ),
                      // password
                      TextFormField(
                        obscureText: _secureText,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.lock,
                            size: 20,
                          ),
                          suffixIcon: IconButton(
                            onPressed: showSecure,
                            icon: Icon(
                              _secureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              size: 20,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: Colors.transparent, width: 0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: Colors.transparent, width: 0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          filled: true,
                          fillColor: Colors.blue.withOpacity(0.2),
                          hintText: "Password",
                          hintStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // controller: txtpassword,
                        onSaved: (e) => txtpassword = e!,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Field is required";
                          }
                          return null;
                        },
                      ),                    

                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const <Widget>[
                          Text(
                            "forgot password ?",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      // end text forgot

                      const SizedBox(
                        height: 15,
                      ),
                      ButtonTheme(
                        minWidth: double.infinity,                        
                        child: RaisedButton(
                          onPressed: () {
                            _check();
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            "I don't have an account yet ?",
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegisterPages(),
                                ),
                              );
                            },
                            child: const Text(
                              "create account",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
        break;
      case LoginStatus.sigIn:
        return MenuDrawer(signOut: signOut);
        break;
    }
  }
}
