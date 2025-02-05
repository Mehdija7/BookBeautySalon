import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:book_beauty/models/review.dart';
import 'package:book_beauty/providers/base_provider.dart';

class ReviewProvider extends BaseProvider<Review> {
  ReviewProvider() : super("Review");

  @override
  Review fromJson(data) {
    return Review.fromJson(data);
  }

  Future<double> getAverageRating(int productId) async {
    try {
      var uri =
          Uri.parse('${BaseProvider.baseUrl}GetAverage?productId=$productId');
      var headers = createHeaders();

      var response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        return double.parse(response.body);
      } else {
        throw Exception('Failed to load average rating');
      }
    } catch (e) {
      print('Error in getAverageRating: $e');
      return 0.0;
    }
  }
}
