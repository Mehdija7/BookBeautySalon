import 'package:json_annotation/json_annotation.dart';

part 'service.g.dart';

@JsonSerializable()
class Service {
  int? serviceId;
  String? name;
  double? price;
  String? shortDescription;
  String? longDescription;
  int? duration;
  String? image;

  Service(
      {this.serviceId,
      this.name,
      this.price,
      this.shortDescription,
      this.longDescription,
      this.duration,
      this.image});

  factory Service.fromJson(Map<String, dynamic> json) =>
      _$ServiceFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceToJson(this);
}
