// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, deprecated_member_use, unnecessary_null_comparison, unused_element, unnecessary_string_interpolations, avoid_print, unnecessary_this, prefer_void_to_null, unused_local_variable

import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend1/app/config/api.dart';
import 'package:frontend1/app/config/network.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path;

class CreateBook extends StatefulWidget {
  final String tokenuser;
  const CreateBook({Key? key, required this.tokenuser}) : super(key: key);

  @override
  _CreateBookState createState() => _CreateBookState();
}

class _CreateBookState extends State<CreateBook> {
  final _key = GlobalKey<FormState>();
  String? category, tag, title, price, file, year, page, description;
  File? image, book_file;
  bool? publish = false;
  DateTime _date = DateTime.now();
  Future<Null> _selectdate(BuildContext context) async {
    DateTime? year = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(1947),
      lastDate: DateTime(2030),
    );
    if (year != null && year != _date) {
      setState(() {
        _date = year;
      });
    }
    // print(_date);
  }

  Future _pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) {
        return;
      }
      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      print('Faild to pick Image: $e');
    }
  }

  // var _openResult = '';
  Future getFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc'],
    );
    if (result != null) {
      File bookfile = File(result.files.single.path!);
      setState(() {
        this.book_file = bookfile;
      });
    } else {
      print("error");
    }
  }

  List? filebook;
  Future<String> getFilebook() async {
    final response = await http.get(
      Uri.parse(ApiConfig.apiUrl() + "file/all-file"),
      headers: {'Authorization': 'Bearer ${widget.tokenuser}'},
    );
    var data = json.decode(response.body);
    setState(() {
      filebook = data['filebook'];
    });
    return "success";
  }

  List? selectcategory;
  Future<String> _getStateList() async {
    final response = await http.get(
      Uri.parse(ApiConfig.apiUrl() + "category/all-category"),
      headers: {
        'Authorization': 'Bearer ${widget.tokenuser}',
      },
    );
    var data = json.decode(response.body);
    print(data["category"]);
    setState(() {
      selectcategory = data['category'];
    });
    return "success";
  }

  List? selecttag;
  Future<String> _getTag() async {
    final response = await http.get(
      Uri.parse(ApiConfig.apiUrl() + "category/selecttag/$category"),
      headers: {
        'Authorization': 'Bearer ${widget.tokenuser}',
      },
    );
    var data = json.decode(response.body);
    print(data);
    setState(() {
      selecttag = data;
    });
    return "success";
  }

  _createdbook() {
    final form = _key.currentState;
    if (form!.validate()) {
      form.save();
      uploadbook();
      print(
          "category : $category, tag :$tag, title : $title, price : $price, thumbnail : $image, year : $year, page : $page, file_id = $file, description : $description, book_file : $book_file");
    }
  }

  uploadbook() async {
    // try {
    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer ${widget.tokenuser}'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse(ApiConfig.apiUrl() + "book/creator/create"));
    request.fields["publish"] = publish == true ? "1" : "0";
    request.fields["category_id"] = category!;
    request.fields["tag_id"] = tag!;
    request.fields["title"] = title!;
    request.fields["price"] = price!;
    request.fields["year"] = _date.toString();
    request.fields["page"] = page!;
    request.fields["file_id"] = file!;
    request.fields["description"] = description!;
    var length = await image!.length();
    var lengthbook = await book_file!.length();
    request.files.add(http.MultipartFile(
      "thumbnail",
      http.ByteStream(DelegatingStream.typed(image!.openRead())),
      length,
      filename: path.basename(image!.path),
    ));
    request.files.add(http.MultipartFile(
      "book_file",
      http.ByteStream(DelegatingStream.typed(book_file!.openRead())),
      lengthbook,
      filename: path.basename(book_file!.path),
    ));

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
    getFilebook();
    _getStateList();
    fetchfilebook();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var placeholder = Container(
      height: 75,
      width: 75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.black,
        image: DecorationImage(
          image: AssetImage(
            "assets/images/thumbnail.jpg",
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
    return Scaffold(
      backgroundColor: Color(0xfff5f6f9),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "upload new book",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _key,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
                          if (image != null) {
                            return GestureDetector(
                              onTap: () {
                                OpenFile.open(image!.path);
                              },
                              child: Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: CircleAvatar(
                                  backgroundImage: FileImage(image!),
                                ),
                              ),
                            );
                          } else {
                            return Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(
                                  image:
                                      AssetImage("assets/images/thumbnail.jpg"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
                          if (book_file != null) {
                            return GestureDetector(
                              onTap: () {
                                OpenFile.open(book_file!.path);
                              },
                              child: Container(
                                height: 100,
                                width: 100,
                                color: Colors.white,
                                child: Icon(
                                  Icons.file_present_outlined,
                                  size: 54,
                                ),
                              ),
                            );
                          } else {
                            return Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(
                                  image:
                                      AssetImage("assets/images/notfiled.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      RaisedButton(
                        color: Colors.blue,
                        onPressed: () {
                          _pickImage();
                        },
                        child: Center(
                          child: Text(
                            "select image",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      RaisedButton(
                        color: Colors.blue,
                        onPressed: () {
                          getFile();
                        },
                        child: Center(
                          child: Text(
                            "select file",
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
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      left: 15,
                      right: 15,
                      top: 5,
                    ),
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(
                          Icons.person,
                          color: Colors.black,
                          size: 20.0,
                        ),
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: ButtonTheme(
                              alignedDropdown: true,
                              child: DropdownButton<String>(
                                value: category,
                                iconSize: 20,
                                icon: (null),
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16,
                                ),
                                hint: Text(
                                  'Select category',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    category = value;
                                    _getTag();
                                    print(category);
                                  });
                                },
                                items: selectcategory?.map((item) {
                                  return DropdownMenuItem(
                                    child: Text(
                                      item['category_name'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    value: item['id'].toString(),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(
                          Icons.person,
                          color: Colors.black,
                          size: 20.0,
                        ),
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: ButtonTheme(
                              alignedDropdown: true,
                              child: DropdownButton<String>(
                                value: tag,
                                iconSize: 20,
                                icon: (null),
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16,
                                ),
                                hint: Text(
                                  'select tag',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    tag = value;
                                    print(tag);
                                  });
                                },
                                items: selecttag?.map((item) {
                                      return DropdownMenuItem(
                                        child: Text(
                                          item['tag_name'],
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        value: item['id'].toString(),
                                      );
                                    }).toList() ??
                                    [],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(
                          Icons.person,
                          color: Colors.black,
                          size: 20.0,
                        ),
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: ButtonTheme(
                              alignedDropdown: true,
                              child: DropdownButton<String>(
                                value: file,
                                iconSize: 20,
                                icon: (null),
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16,
                                ),
                                hint: Text(
                                  'select file',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    file = value!;
                                    // file = _myState!;
                                  });
                                },
                                items: filebook?.map((item) {
                                  return DropdownMenuItem(
                                    child: Text(item['name'].toString()),
                                    value: item['id'].toString(),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.title,
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
                      fillColor: Colors.white,
                      hintText: "title",
                      hintStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onSaved: (e) => title = e!,
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
                      fillColor: Colors.white,
                      hintText: "price",
                      hintStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onSaved: (e) => price = e!,
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
                  // RaisedButton(
                  //   onPressed: () {
                  //     _selectdate(context);
                  //   },
                  //   child: Text("date"),
                  // ),
                  // Text("$_date"),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _selectdate(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          width: 45,
                          height: 45,
                          child: Center(
                            child: Icon(
                              Icons.date_range_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 285,
                        padding: EdgeInsets.only(
                          left: 15,
                          right: 15,
                          top: 15,
                        ),
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _date == null ? "Date null" : "$_date",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
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
                      fillColor: Colors.white,
                      hintText: "page",
                      hintStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onSaved: (e) => page = e!,
                    keyboardType: TextInputType.number,
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
                  Row(
                    children: [
                      Checkbox(
                          value: publish,
                          onChanged: (value) {
                            setState(() {
                              publish = value;
                            });
                          },
                          activeColor: Colors.blue,
                          checkColor: Colors.white),
                      publish == true
                          ? Text(
                              "Publish",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : Text(
                              "Not publish",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
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
                      fillColor: Colors.white,
                      hintText: "description",
                      hintStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    minLines: 6,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onSaved: (e) => description = e!,
                    // controller: txtusername,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Field is required";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ButtonTheme(
                    minWidth: double.infinity,
                    child: RaisedButton(
                      child: const Text(
                        "Create Book",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        _createdbook();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // void openFile(File? book_file) {}

  // void openFile(PlatformFile file){
  //   OpenFile.open(file.path!);
  // }
}
