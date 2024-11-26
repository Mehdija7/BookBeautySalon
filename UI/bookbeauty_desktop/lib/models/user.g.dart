// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      userId: (json['userId'] as num?)?.toInt(),
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      genderId: (json['genderId'] as num?)?.toInt(),
      address: json['address'] as String?,
      userroles: (json['userroles'] as List<dynamic>?)
          ?.map((e) => UserRoles.fromJson(e as Map<String, dynamic>))
          .toList(),
      password: json['password'] as String?,
      passwordConfirmed: json['passwordConfirmed'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'userId': instance.userId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'username': instance.username,
      'email': instance.email,
      'phone': instance.phone,
      'address': instance.address,
      'genderId': instance.genderId,
      'userroles': instance.userroles,
      'password': instance.password,
      'passwordConfirmed': instance.passwordConfirmed,
    };
