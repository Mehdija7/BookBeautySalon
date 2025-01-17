import 'package:book_beauty/models/gender.dart';
import 'package:book_beauty/providers/base_provider.dart';

class GenderProvider extends BaseProvider<Gender> {
  GenderProvider() : super("Gender");

  @override
  Gender fromJson(data) {
    return Gender.fromJson(data);
  }
}
