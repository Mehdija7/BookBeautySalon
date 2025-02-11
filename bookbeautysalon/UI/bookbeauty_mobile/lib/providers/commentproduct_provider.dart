import 'package:book_beauty/models/commentproduct.dart';
import 'package:book_beauty/providers/base_provider.dart';

class CommentProductProvider extends BaseProvider<CommentProduct> {
  CommentProductProvider() : super("CommentProduct");

  @override
  CommentProduct fromJson(data) {
    return CommentProduct.fromJson(data);
  }
}
