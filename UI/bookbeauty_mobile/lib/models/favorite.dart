import 'package:book_beauty/models/product.dart';
import 'package:json_annotation/json_annotation.dart';

part 'favorite.g.dart';

@JsonSerializable()
class Favorite {
  int? favoriteProductsId;
  int? userId;
  int? productId;
  DateTime? addingDate;
  Product? product;

  Favorite(
      {this.favoriteProductsId,
      this.userId,
      this.productId,
      this.addingDate,
      this.product});

  factory Favorite.fromJson(Map<String, dynamic> json) =>
      _$FavoriteFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteToJson(this);
}
