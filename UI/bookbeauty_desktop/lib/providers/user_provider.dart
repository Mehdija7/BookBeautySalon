import 'package:bookbeauty_desktop/models/user.dart';
import 'package:bookbeauty_desktop/providers/base_provider.dart';

class UserProvider extends BaseProvider<User> {
  UserProvider() : super("User");

  @override
  User fromJson(data) {
    return User.fromJson(data);
  }
}
