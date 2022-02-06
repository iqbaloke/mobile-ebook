// ignore_for_file: non_constant_identifier_names

class CheckMe {
  final String name;
  final String email;
  final String country;
  final String thumbnail;
  final String phone;
  final String status;
  final String last_education;
  final String major;
  final String city;
  final String location_of_education;
  final String description;
  final String address;
  final String book_sale;
  final String facebook;
  final String instagram;
  final String twitter;
  final String github;
  final String linkdin;

  CheckMe({
    required this.name,
    required this.email,
    required this.country,
    required this.thumbnail,
    required this.phone,
    required this.status,
    required this.last_education,
    required this.major,
    required this.city,
    required this.location_of_education,
    required this.description,
    required this.address,
    required this.book_sale,
    required this.facebook,
    required this.instagram,
    required this.twitter,
    required this.github,
    required this.linkdin,
  });
  factory CheckMe.fromJson(Map<String, dynamic> json) {
    return CheckMe(
      name: json["name"].toString(),
      email: json["email"].toString(),
      country: json["country"].toString(),
      thumbnail: json["thumbnail"].toString(),
      phone: json["phone"].toString(),
      status: json["status"].toString(),
      last_education: json["last_education"].toString(),
      major: json["major"].toString(),
      city: json["city"].toString(),
      location_of_education: json["location_of_education"].toString(),
      description: json["description"].toString(),
      address: json["address"].toString(),
      book_sale: json["book_sale"].toString(),
      facebook: json["facebook"].toString(),
      instagram: json["instagram"].toString(),
      twitter: json["twitter"].toString(),
      github: json["github"].toString(),
      linkdin: json["linkdin"].toString(),
    );
  }
}
