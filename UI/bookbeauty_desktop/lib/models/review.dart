import 'package:json_annotation/json_annotation.dart';

part 'review.g.dart';

@JsonSerializable()
class Review {
  int? reviewId;
  int? mark;
  int? productId;
  int? userId;
  DateTime? date;

  Review({this.reviewId, this.mark, this.productId, this.userId, this.date});

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewToJson(this);
}
