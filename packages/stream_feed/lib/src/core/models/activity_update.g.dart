// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityUpdate _$ActivityUpdateFromJson(Map json) => ActivityUpdate(
      set: (json['set'] as Map?)?.map(
        (k, e) => MapEntry(k as String, e as Object),
      ),
      unset:
          (json['unset'] as List<dynamic>?)?.map((e) => e as String).toList(),
      id: json['id'] as String?,
      foreignId: json['foreign_id'] as String?,
      time: const DateTimeUTCConverter().fromJson(json['time'] as String?),
    );

Map<String, dynamic> _$ActivityUpdateToJson(ActivityUpdate instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('foreign_id', instance.foreignId);
  writeNotNull('time', const DateTimeUTCConverter().toJson(instance.time));
  writeNotNull('set', instance.set);
  writeNotNull('unset', instance.unset);
  return val;
}
