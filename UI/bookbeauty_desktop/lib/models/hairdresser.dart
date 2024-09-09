import 'package:json_annotation/json_annotation.dart';

part 'hairdresser.g.dart';

@JsonSerializable()
class HairDresser {
  int? hairdresserId;
  DateTime? startDate;
  DateTime? endDate;

  HairDresser({this.hairdresserId, this.startDate, this.endDate});

  factory HairDresser.fromJson(Map<String, dynamic> json) =>
      _$HairDresserFromJson(json);

  Map<String, dynamic> toJson() => _$HairDresserToJson(this);
}
