import 'package:bookbeauty_desktop/models/gender.dart';
import 'package:bookbeauty_desktop/providers/base_provider.dart';

class GenderProvider extends BaseProvider<Gender> {
  GenderProvider() : super("Gender");

  @override
  Gender fromJson(data) {
    return Gender.fromJson(data);
  }
}
