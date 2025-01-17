// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) => ProfileModel(
      (json['theme'] as num).toInt(),
      (json['jsonData'] as List<dynamic>?)?.map((e) => e as String).toList(),
      json['appName'] as String?,
      json['selectedItem'] as String?,
    );

Map<String, dynamic> _$ProfileModelToJson(ProfileModel instance) =>
    <String, dynamic>{
      'theme': instance.theme,
      'jsonData': instance.jsonData,
      'appName': instance.appName,
      'selectedItem': instance.selectedItem,
    };
