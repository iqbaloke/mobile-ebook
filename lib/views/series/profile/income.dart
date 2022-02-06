// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend1/app/config/api.dart';
import 'package:frontend1/app/config/network.dart';
import 'package:frontend1/app/model/income.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;

class IncomePages extends StatefulWidget {
  const IncomePages({Key? key}) : super(key: key);

  @override
  _IncomePagesState createState() => _IncomePagesState();
}

class _IncomePagesState extends State<IncomePages> {
  late List<PieData> _chartData;
  late String payment, payment_name, nominal;

  List<PieData> getChartsData() {
    final List<PieData> chartsData = [
      PieData("Product", 1600),
      PieData("Buy", 1200),
      PieData("Favorite", 700),
      PieData("In Progress", 900),
    ];
    return chartsData;
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

  Future<IncomeModel> chekIncome() async {
    final response = await http.get(
      Uri.parse(ApiConfig.apiUrl() + "dashboard/income"),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return IncomeModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }

  final _key = GlobalKey<FormState>();

  _validation() {
    final form = _key.currentState;
    if (form!.validate()) {
      form.save();
      _widraw();
      // print("$nominal, $payment, $payment_name");
    }
  }

  _widraw() async {
    final response = await http.post(
      Uri.parse(ApiConfig.apiUrl() + "dashboard/income/widraw"),
      body: {
        'nominal': nominal,
        'payment': payment,
        'payment_name': payment_name,
      },
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    var check = jsonDecode(response.body);
    // print(check["message"]);
    if (check["message"] == "money") {
      Alert(
        context: context,
        title: "fails",
        desc: "your money is not enough",
      ).show();
    } else {
      if (check["message"] == "success") {
        Alert(
          context: context,
          title: "success",
          desc: "success widraw",
        ).show();
      } else {
        Alert(
          context: context,
          title: "fails",
          desc: "your money is not enough",
        ).show();
      }
    }
  }

  Future<List<dynamic>> fectwidraw() async {
    final response = await http.get(
      Uri.parse(ApiConfig.apiUrl() + "dashboard/income"),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    // print(json.decode(response.body)["widraw"]);
    return json.decode(response.body)["widraw"];
  }

  @override
  void initState() {
    _chartData = getChartsData();
    setState(() {
      chekIncome();
      fectwidraw();
      getPreference();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f6f9),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                  height: 200,
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: SfCircularChart(
                          series: <CircularSeries>[
                            PieSeries<PieData, String>(
                              dataSource: _chartData,
                              xValueMapper: (PieData data, _) => data.xData,
                              yValueMapper: (PieData data, _) => data.yData,
                              dataLabelSettings:
                                  const DataLabelSettings(isVisible: true),
                              enableTooltip: true,
                            )
                          ],
                        ),
                      ),
                      FutureBuilder(
                        future: chekIncome(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.data == null) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {}
                          return Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Income : ${snapshot.data.income_total}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "Residual Income : ${snapshot.data.residual_income}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Expenditure : ${snapshot.data.expenditure}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ButtonTheme(
                                  height: 25,
                                  child: RaisedButton(
                                    onPressed: () {
                                      var income = snapshot.data.income_total;
                                      setState(() {
                                        showsheet(income);
                                      });
                                    },
                                    color: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Text(
                                      "widraw",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    Text(
                      "Transaction",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 20,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: FutureBuilder(
                    future: fectwidraw(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.data == null) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        if (snapshot.data.length < 1) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                height: 200,
                                width: 300,
                                // color: Colors.black,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                  image:
                                      AssetImage("assets/images/nodata.jpg"),
                                )),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                "You not Transaction",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          );
                        } else {
                          return Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
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
                                    columns: const [
                                      // DataColumn(
                                      //   numeric: false,
                                      //   label: Text(
                                      //     "widraw key",
                                      //     style: TextStyle(
                                      //       fontSize: 14,
                                      //       fontWeight: FontWeight.bold,
                                      //     ),
                                      //   ),
                                      //   tooltip: "widraw key",
                                      // ),
                                      DataColumn(
                                        label: Text(
                                          "nominal",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      // DataColumn(
                                      //   label: Text(
                                      //     "payment",
                                      //     style: TextStyle(
                                      //       fontSize: 14,
                                      //       fontWeight: FontWeight.bold,
                                      //     ),
                                      //   ),
                                      // ),
                                      // DataColumn(
                                      //   label: Text(
                                      //     "payment_name",
                                      //     style: TextStyle(
                                      //       fontSize: 14,
                                      //       fontWeight: FontWeight.bold,
                                      //     ),
                                      //   ),
                                      // ),
                                      DataColumn(
                                        label: Text(
                                          "status",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          "created at",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          "action",
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
                                        final a = snapshot.data[index]
                                                ["widraw_key"]
                                            .toString();
                                        final b = snapshot.data[index]
                                                ["nominal"]
                                            .toString();
                                        final c = snapshot.data[index]
                                                ["payment"]
                                            .toString();
                                        final d = snapshot.data[index]
                                                ["payment_name"]
                                            .toString();
                                        final e = snapshot.data[index]["status"]
                                            .toString();
                                        final f = snapshot.data[index]
                                                ["created_at"]
                                            .toString();
                                        return DataRow(cells: [
                                          DataCell(
                                            Container(
                                              child: Text(
                                                b,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Container(
                                              child: e == "1"
                                                  ? Text(
                                                      "success",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                        color: Colors.blue,
                                                      ),
                                                    )
                                                  : Text(
                                                      "process",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                        color: Colors.amber,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                          DataCell(
                                            Container(
                                              child: Text(
                                                f,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () => Alert(
                                                    context: context,
                                                    content: Column(
                                                      children: <Widget>[
                                                        Container(
                                                          height: 75,
                                                          width: 75,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50),
                                                            border: Border.all(
                                                              width: 2,
                                                              color: e == "2"
                                                                  ? Colors
                                                                      .yellow
                                                                  : Colors
                                                                      .green,
                                                            ),
                                                          ),
                                                          child: Center(
                                                            child: e == "2"
                                                                ? Icon(
                                                                    Icons
                                                                        .warning_amber_rounded,
                                                                    size: 34,
                                                                    color: Colors
                                                                        .yellow,
                                                                  )
                                                                : Icon(
                                                                    Icons.check,
                                                                    size: 34,
                                                                    color: Colors
                                                                        .green,
                                                                  ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          e == "2"
                                                              ? "PROCCESSING"
                                                              : "SUCCESS",
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Divider(
                                                          height: 20,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "widraw key",
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                ": " + a,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
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
                                                              "nominal",
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                ": " + b,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
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
                                                              "payment",
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                ": " + c,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
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
                                                              "payment name",
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                ": " + d,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
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
                                                              "created_at",
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                ": " + f,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
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
                                                          "Back",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                          context,
                                                        ),
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            2,
                                                      )
                                                    ],
                                                  ).show(),
                                                  child: Container(
                                                    height: 20,
                                                    width: 70,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      color: Colors.indigo
                                                          .withOpacity(0.8),
                                                    ),
                                                    child: const Center(
                                                      child: Text(
                                                        "detail",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
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
                              ),
                            ],
                          );
                        }
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showsheet(int income) {
    var sisa = income - 1;
    showModalBottomSheet(
      isDismissible: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      context: context,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          builder: (_, controller) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.all(10),
            child: Form(
              key: _key,
              child: ListView(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Widraw",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "You have a residual income of $income you can withdraw $sisa !!!",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Divider(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.person,
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
                          hintText: "Nominal",
                          hintStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        onSaved: (e) => nominal = e!,
                        // controller: txtusername,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Field is required";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.person,
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
                          hintText: "payment",
                          hintStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onSaved: (e) => payment = e!,
                        // controller: txtusername,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Field is required";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.person,
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
                          hintText: "payment name",
                          hintStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onSaved: (e) => payment_name = e!,
                        // controller: txtusername,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Field is required";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ButtonTheme(
                        minWidth: double.infinity,
                        child: RaisedButton(
                          child: const Text(
                            "Widraw",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            _validation();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class PieData {
  PieData(this.xData, this.yData);
  final String xData;
  final int yData;
}
