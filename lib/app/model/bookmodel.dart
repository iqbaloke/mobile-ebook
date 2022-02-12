// ignore_for_file: non_constant_identifier_names

class BookModel {
  final String book_key;
  final int publish;
  final User user_id;
  final Category category_id;
  final Tag tag_id;
  final String title;
  final String slug;
  final String price;
  final String thumbnail;
  final String book_file;
  final FileModel file_id;
  final String approved;
  final String year;
  final String page;
  final String payament;
  final String description;
  final String created_at;
  final String discon;
  final String sale;
  final String comment;
  final String book_count;
  final int status_purchased;

  BookModel({
    required this.book_key,
    required this.publish,
    required this.user_id,
    required this.category_id,
    required this.tag_id,
    required this.title,
    required this.slug,
    required this.price,
    required this.thumbnail,
    required this.book_file,
    required this.file_id,
    required this.approved,
    required this.year,
    required this.page,
    required this.payament,
    required this.description,
    required this.created_at,
    required this.discon,
    required this.sale,
    required this.comment,
    required this.book_count,
    required this.status_purchased,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      book_key: json["book_key"].toString(),
      publish: json["publish"],
      user_id: User.fromJson(json["user_id"]),
      category_id: Category.fromJson(json["category_id"]),
      tag_id: Tag.fromJson(json["tag_id"]),
      title: json["title"].toString(),
      slug: json["slug"].toString(),
      price: json["price"].toString(),
      thumbnail: json["thumbnail"].toString(),
      book_file: json["book_file"].toString(),
      file_id: FileModel.fromJson(json["file_id"]),
      approved: json["approved"].toString(),
      year: json["year"].toString(),
      page: json["page"].toString(),
      payament: json["payament"].toString(),
      description: json["description"].toString(),
      created_at: json["created_at"].toString(),
      discon: json["discon"].toString(),
      sale: json["sale"].toString(),
      comment: json["comment"].toString(),
      book_count: json["book_count"].toString(),
      status_purchased: json["status_purchased"],
    );
  }
}

class User {
  final String name;
  final String email;
  final String country;
  final String thumbnail;
  final String phone;
  final String status;
  final String last_education;
  final String major;
  final String location_of_education;
  final String description;
  final String city;
  final String address;

  User({
    required this.name,
    required this.email,
    required this.country,
    required this.thumbnail,
    required this.phone,
    required this.status,
    required this.last_education,
    required this.major,
    required this.location_of_education,
    required this.description,
    required this.city,
    required this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json["name"].toString(),
      email: json["email"].toString(),
      country: json["country"].toString(),
      thumbnail: json["thumbnail"].toString(),
      phone: json["phone"].toString(),
      status: json["status"].toString(),
      last_education: json["last_education"].toString(),
      major: json["major"].toString(),
      location_of_education: json["location_of_education"].toString(),
      description: json["description"].toString(),
      city: json["city"].toString(),
      address: json["address"].toString(),
    );
  }
}

class Category {
  final String category_name;
  final String picture;
  final String slug;
  final String book_count;
  final String tag_count;

  Category({
    required this.category_name,
    required this.picture,
    required this.slug,
    required this.book_count,
    required this.tag_count,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      category_name: json["category_name"].toString(),
      picture: json["picture"].toString(),
      slug: json["slug"].toString(),
      book_count: json["book_count"].toString(),
      tag_count: json["tag_count"].toString(),
    );
  }
}

class Tag {
  final String tag_name;
  final String slug;

  Tag({
    required this.tag_name,
    required this.slug,
  });
  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      tag_name: json["tag_name"].toString(),
      slug: json["slug"].toString(),
    );
  }
}

class FileModel {
  final String name;
  final String slug;

  FileModel({
    required this.name,
    required this.slug,
  });
  factory FileModel.fromJson(Map<String, dynamic> json) {
    return FileModel(
      name: json["name"].toString(),
      slug: json["slug"].toString(),
    );
  }
}
