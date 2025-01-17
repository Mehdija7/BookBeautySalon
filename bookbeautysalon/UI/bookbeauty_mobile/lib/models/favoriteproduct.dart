import 'package:book_beauty/models/product.dart';
import 'package:json_annotation/json_annotation.dart';

part 'favoriteproduct.g.dart';

@JsonSerializable()
class FavoriteProduct {
  int? favoriteProductsId;
  int? userId;
  int? productId;
  DateTime? addingDate;
  Product? product;

  FavoriteProduct(
      {this.favoriteProductsId,
      this.userId,
      this.productId,
      this.addingDate,
      this.product});

  factory FavoriteProduct.fromJson(Map<String, dynamic> json) =>
      _$FavoriteProductFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteProductToJson(this);
}
