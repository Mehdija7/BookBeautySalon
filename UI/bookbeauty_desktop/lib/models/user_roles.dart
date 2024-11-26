import 'package:bookbeauty_desktop/models/role.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_roles.g.dart';

@JsonSerializable()
class UserRoles {
  int? userRoleId;
  int? userId;
  int? roleId;
  DateTime? changedDate;
  Role? role;

  UserRoles(
      {this.userRoleId, this.userId, this.roleId, this.changedDate, this.role});

  factory UserRoles.fromJson(Map<String, dynamic> json) =>
      _$UserRolesFromJson(json);

  Map<String, dynamic> toJson() => _$UserRolesToJson(this);
}
