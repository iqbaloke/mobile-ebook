// ignore_for_file: non_constant_identifier_names

class IncomeModel {
  final String orders;
  final String income_total;
  final String residual_income;
  final String expenditure;
  final String book_count;

  IncomeModel({
    required this.orders,
    required this.income_total,
    required this.residual_income,
    required this.expenditure,
    required this.book_count,
  });
  factory IncomeModel.fromJson(Map<String, dynamic> json) {
    return IncomeModel(
      income_total: json["income_total"].toString(),
      residual_income: json["residual_income"].toString(),
      expenditure: json["expenditure"].toString(),
      orders: json["orders"].toString(),
      book_count: json["book_count"].toString(),
    );
  }
}
