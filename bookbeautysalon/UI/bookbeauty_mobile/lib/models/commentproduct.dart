import 'package:book_beauty/models/product.dart';
import 'package:book_beauty/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'commentproduct.g.dart';

@JsonSerializable()
class CommentProduct {
  final int? commentProductId;
  final DateTime? commentDate;
  final String? commentText;
  final int? userId;
  final int? productId;
  final Product? product;
  final User? user;

  CommentProduct({
    this.commentProductId,
    this.commentDate,
    this.commentText,
    this.userId,
    this.productId,
    this.product,
    this.user,
  });

  factory CommentProduct.fromJson(Map<String, dynamic> json) =>
      _$CommentProductFromJson(json);

  Map<String, dynamic> toJson() => _$CommentProductToJson(this);
}
