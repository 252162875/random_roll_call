import 'package:json_annotation/json_annotation.dart';
part 'profile_model.g.dart';

@JsonSerializable()
class ProfileModel extends Object {
  @JsonKey(name: 'theme')
  int theme;

  @JsonKey(name: 'jsonData')
  List<String>? jsonData;

  @JsonKey(name: 'appName')
  String? appName;

  @JsonKey(name: 'selectedItem')
  String? selectedItem;


  ProfileModel(
    this.theme,
    this.jsonData,
    this.appName,
    this.selectedItem,
  );

  factory ProfileModel.fromJson(Map<String, dynamic> srcJson) =>
      _$ProfileModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);
}
