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
  int? genderId;

  User(
      {this.userId,
      this.firstName,
      this.lastName,
      this.username,
      this.email,
      this.phone,
      this.genderId,
      this.address});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
