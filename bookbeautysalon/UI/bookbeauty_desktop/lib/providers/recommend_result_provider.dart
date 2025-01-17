import 'package:bookbeauty_desktop/models/recommend_result.dart';
import 'package:bookbeauty_desktop/providers/base_provider.dart';

class RecommendResultProvider extends BaseProvider<RecommendResult> {
  RecommendResultProvider() : super("RecommendResult");

  @override
  RecommendResult fromJson(data) {
    return RecommendResult.fromJson(data);
  }
}
