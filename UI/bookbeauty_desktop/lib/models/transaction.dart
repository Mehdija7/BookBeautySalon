import 'package:json_annotation/json_annotation.dart';

part 'transaction.g.dart';

@JsonSerializable()
class Transaction {
  int? transactionId;
  String? name;
  int? orderId;
  double? price;
  String? status;

  Transaction(
      {this.transactionId, this.name, this.orderId, this.price, this.status});

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}