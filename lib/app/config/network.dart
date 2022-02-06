import 'dart:convert';
import 'package:frontend1/app/config/api.dart';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchCategory() async {
  final response = await http.get(
    Uri.parse(ApiConfig.apiUrl() + "all-category"),
  );
  return json.decode(response.body)["category"];
}

Future<List<dynamic>> fetchfilebook() async {
  final response = await http.get(
    Uri.parse(ApiConfig.apiUrl() + "file/all-file"),
    headers: {
      'Authorization': 'Bearer 2|REtIUQLUecTleqVgIuG3qFd8gVMEYjru34btOfYf',
    },
  );
  // print(json.decode(response.body)["filebook"]);
  return json.decode(response.body)["filebook"];
}

Future<List<dynamic>> fetchtag() async {
  final response = await http
      .get(Uri.parse(ApiConfig.apiUrl() + "category/all-tag"), headers: {
    'Authorization': 'Bearer 2|REtIUQLUecTleqVgIuG3qFd8gVMEYjru34btOfYf',
  });
  // print(json.decode(response.body)["tag"]);
  return json.decode(response.body)["tag"];
}

Future<List<dynamic>> fetchAuthor() async {
  final response = await http
      .get(Uri.parse(ApiConfig.apiUrl() + "book/bookauthormost"), headers: {
    'Authorization': 'Bearer 2|REtIUQLUecTleqVgIuG3qFd8gVMEYjru34btOfYf'
  });
  return json.decode(response.body)["authors"];
}

Future<List<dynamic>> fetchRecomendation() async {
  final response = await http
      .get(Uri.parse(ApiConfig.apiUrl() + "book/bookrecomendation"), headers: {
    'Authorization': 'Bearer 2|REtIUQLUecTleqVgIuG3qFd8gVMEYjru34btOfYf'
  });
  return json.decode(response.body)["recomendation"];
}

Future<List<dynamic>> fetchallbook() async {
  final response = await http
      .get(Uri.parse(ApiConfig.apiUrl() + "book/all-book"), headers: {
    'Authorization': 'Bearer 2|REtIUQLUecTleqVgIuG3qFd8gVMEYjru34btOfYf'
  });
  return json.decode(response.body)["allbook"];
}

Future<List<dynamic>> fetchallbookfree() async {
  final response = await http
      .get(Uri.parse(ApiConfig.apiUrl() + "book/all-book-free"), headers: {
    'Authorization': 'Bearer 2|REtIUQLUecTleqVgIuG3qFd8gVMEYjru34btOfYf'
  });
  return json.decode(response.body)["allbook"];
}

Future<List<dynamic>> fetchallbookpayment() async {
  final response = await http
      .get(Uri.parse(ApiConfig.apiUrl() + "book/all-book-payment"), headers: {
    'Authorization': 'Bearer 2|REtIUQLUecTleqVgIuG3qFd8gVMEYjru34btOfYf'
  });
  return json.decode(response.body)["allbook"];
}

addToCart(String slug, String id, String price, String tokendata) async {
  final response = await http.post(
    Uri.parse(ApiConfig.apiUrl() + "cart/addcart/$slug"),
    headers: {
      'Authorization': 'Bearer $tokendata',
    },
    body: {
      "book_id": id,
      "price": price,
    },
  );
  var check = json.decode(response.body);
  if (check["message"] == "success") {
    // var context;
    // Alert(
    //   context: context,
    //   title: "${check["message"]}",
    //   desc: "success add to cart",
    // ).show();
    print("add to cart");
  } else {
    print("already in cart");
    // var context;
    // Alert(
    //   context: context,
    //   title: "${check["message"]}",
    //   desc: "Book Already In the Cart",
    // ).show();
  }
}

// Future<List<dynamic>> getCart() async {
//   final response = await http.get(
//     Uri.parse(ApiConfig.apiUrl() + "cart/getcart"),
//     headers: {
//       'Authorization': 'Bearer 2|REtIUQLUecTleqVgIuG3qFd8gVMEYjru34btOfYf',
//     },
//   );
//   return json.decode(response.body)["data"];
// }

// Future<List<dynamic>> myBook() async {
//   final response = await http.get(
//     Uri.parse(ApiConfig.apiUrl() + "book/creator/my-book"),
//     headers: {
//       'Authorization': 'Bearer 2|REtIUQLUecTleqVgIuG3qFd8gVMEYjru34btOfYf',
//     },
//   );
//   // print(json.decode(response.body)["mybook"]);
//   return json.decode(response.body)["mybook"];
// }

deleteCart(int id) async {
  final response = await http.delete(
    Uri.parse(ApiConfig.apiUrl() + "cart/deletecart/$id"),
    headers: {
      'Authorization': 'Bearer 2|REtIUQLUecTleqVgIuG3qFd8gVMEYjru34btOfYf',
    },
  );
  var delete = json.decode(response.body);
}

checkout(int cart_id, String slug) async {
  final response = await http.post(
    Uri.parse(ApiConfig.apiUrl() + "order/$slug/$cart_id"),
    headers: {
      'Authorization': 'Bearer 2|REtIUQLUecTleqVgIuG3qFd8gVMEYjru34btOfYf',
    },
  );
}

// Future<IncomeModel> chekIncome() async {
//   final response = await http.get(
//     Uri.parse(ApiConfig.apiUrl() + "dashboard/income"),
//     headers: {
//       'Authorization': 'Bearer 2|REtIUQLUecTleqVgIuG3qFd8gVMEYjru34btOfYf',
//     },
//   );
//   if (response.statusCode == 200) {
//     return IncomeModel.fromJson(jsonDecode(response.body));
//   } else {
//     throw Exception('Failed to load album');
//   }
// }

// Future<List<dynamic>> fectwidraw() async {
//   final response = await http.get(
//     Uri.parse(ApiConfig.apiUrl() + "dashboard/income"),
//     headers: {
//       'Authorization': 'Bearer 2|REtIUQLUecTleqVgIuG3qFd8gVMEYjru34btOfYf',
//     },
//   );
//   // print(json.decode(response.body)["widraw"]);
//   return json.decode(response.body)["widraw"];
// }

// Future<List<dynamic>> fecttopsallingauthor() async {
//   final response = await http.get(
//     Uri.parse(ApiConfig.apiUrl() + "dashboard/book/top-book"),
//     headers: {
//       'Authorization': 'Bearer 2|REtIUQLUecTleqVgIuG3qFd8gVMEYjru34btOfYf',
//     },
//   );
//   // print(json.decode(response.body)["data"]);
//   return json.decode(response.body)["data"];
// }

Future<List<dynamic>> fecthpurchased() async {
  final response = await http.get(
    Uri.parse(ApiConfig.apiUrl() + "dashboard/purchased"),
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer 2|REtIUQLUecTleqVgIuG3qFd8gVMEYjru34btOfYf',
    },
  );
  // print(json.decode(response.body)["data"]);
  return json.decode(response.body)["data"];
}
