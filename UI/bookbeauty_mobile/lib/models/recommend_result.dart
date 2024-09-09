import 'package:json_annotation/json_annotation.dart';

part 'recommend_result.g.dart';

@JsonSerializable()
class RecommendResult {
  int? recommendId;
  int? firstproductId;
  int? secondproductId;
  int? thirdproductId;

  RecommendResult(
      {this.recommendId,
      this.firstproductId,
      this.secondproductId,
      this.thirdproductId});

  factory RecommendResult.fromJson(Map<String, dynamic> json) =>
      _$RecommendResultFromJson(json);

  Map<String, dynamic> toJson() => _$RecommendResultToJson(this);
}
