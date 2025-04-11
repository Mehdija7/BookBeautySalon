import 'package:bookbeauty_desktop/models/user_roles.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  int? userId;
  String? firstName;
  String? lastName;
  String? username;
  String? email;
  String? phone;
  String? address;
  List<UserRoles>? userroles;
  String? password;
  String? passwordConfirmed;
  String? userImage;
  User(
      {this.userId,
      this.firstName,
      this.lastName,
      this.username,
      this.email,
      this.phone,
      this.address,
      this.userroles,
      this.password,
      this.passwordConfirmed,
      this.userImage});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
