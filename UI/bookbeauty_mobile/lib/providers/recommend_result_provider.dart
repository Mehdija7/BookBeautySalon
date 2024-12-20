import 'package:book_beauty/models/recommend_result.dart';
import 'package:book_beauty/providers/base_provider.dart';

class RecommendResultProvider extends BaseProvider<RecommendResult> {
  RecommendResultProvider() : super("RecommendResult");

  @override
  RecommendResult fromJson(data) {
    return RecommendResult.fromJson(data);
  }
}
