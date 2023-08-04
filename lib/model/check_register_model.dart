class CheckRegisterModel {
  final String? message;
  final int? amount;

  CheckRegisterModel({
    this.message,
    this.amount,
  });

  factory CheckRegisterModel.fromJson(Map<String, dynamic> json) {
    return CheckRegisterModel(
      message: json['Message'],
      amount: json['Amount'],
    );
  }
}
