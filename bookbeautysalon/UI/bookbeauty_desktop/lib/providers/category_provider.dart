import 'package:bookbeauty_desktop/models/category.dart';
import 'package:bookbeauty_desktop/providers/base_provider.dart';

class CategoryProvider extends BaseProvider<Category> {
  CategoryProvider() : super("Category");

  @override
  Category fromJson(data) {
    return Category.fromJson(data);
  }
}
