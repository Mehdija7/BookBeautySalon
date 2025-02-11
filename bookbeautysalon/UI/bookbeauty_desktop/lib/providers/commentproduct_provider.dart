import 'package:bookbeauty_desktop/models/commentproduct.dart';
import 'package:bookbeauty_desktop/providers/base_provider.dart';

class CommentProductProvider extends BaseProvider<CommentProduct> {
  CommentProductProvider() : super("CommentProduct");

  @override
  CommentProduct fromJson(data) {
    return CommentProduct.fromJson(data);
  }
}
