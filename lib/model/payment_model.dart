class PaymentModel {
  final String message;

  PaymentModel({required this.message});

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      message: json['Message'] as String,
    );
  }
}
