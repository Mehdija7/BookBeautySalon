// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_roles.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRoles _$UserRolesFromJson(Map<String, dynamic> json) => UserRoles(
      userRoleId: (json['userRoleId'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      roleId: (json['roleId'] as num?)?.toInt(),
      changedDate: json['changedDate'] == null
          ? null
          : DateTime.parse(json['changedDate'] as String),
    );

Map<String, dynamic> _$UserRolesToJson(UserRoles instance) => <String, dynamic>{
      'userRoleId': instance.userRoleId,
      'userId': instance.userId,
      'roleId': instance.roleId,
      'changedDate': instance.changedDate?.toIso8601String(),
    };
