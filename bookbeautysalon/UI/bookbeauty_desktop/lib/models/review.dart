import 'package:bookbeauty_desktop/models/product.dart';
import 'package:bookbeauty_desktop/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'review.g.dart';

@JsonSerializable()
class Review {
  int? reviewId;
  int? mark;
  int? productId;
  int? userId;
  User? user;
  Product? product;

  Review(
      {this.reviewId,
      this.mark,
      this.productId,
      this.userId,
      this.user,
      this.product});

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewToJson(this);
}
