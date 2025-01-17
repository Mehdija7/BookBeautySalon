import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  int? productId;
  String? name;
  double? price;
  String? description;
  int? categoryId;
  String? stateMachine;
  String? image;

  Product(
      {this.productId,
      this.name,
      this.price,
      this.description,
      this.categoryId,
      this.stateMachine,
      this.image});

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
