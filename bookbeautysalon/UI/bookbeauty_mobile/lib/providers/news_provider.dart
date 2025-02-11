import 'package:book_beauty/models/news.dart';
import 'package:book_beauty/providers/base_provider.dart';

class NewsProvider extends BaseProvider<News> {
  NewsProvider() : super("News");

  @override
  News fromJson(data) {
    return News.fromJson(data);
  }
}
