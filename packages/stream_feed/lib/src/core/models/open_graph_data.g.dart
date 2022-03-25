// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_graph_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpenGraphData _$OpenGraphDataFromJson(Map json) => OpenGraphData(
      title: json['title'] as String?,
      type: json['type'] as String?,
      url: json['url'] as String?,
      site: json['site'] as String?,
      siteName: json['site_name'] as String?,
      description: json['description'] as String?,
      determiner: json['determiner'] as String?,
      locale: json['locale'] as String?,
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => OgImage.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      videos: (json['videos'] as List<dynamic>?)
          ?.map((e) => OgVideo.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      audios: (json['audios'] as List<dynamic>?)
          ?.map((e) => OgAudio.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$OpenGraphDataToJson(OpenGraphData instance) =>
    <String, dynamic>{
      'title': instance.title,
      'type': instance.type,
      'url': instance.url,
      'site': instance.site,
      'site_name': instance.siteName,
      'description': instance.description,
      'determiner': instance.determiner,
      'locale': instance.locale,
      'images': instance.images?.map((e) => e.toJson()).toList(),
      'videos': instance.videos?.map((e) => e.toJson()).toList(),
      'audios': instance.audios?.map((e) => e.toJson()).toList(),
    };

OgImage _$OgImageFromJson(Map json) => OgImage(
      image: json['image'] as String?,
      url: json['url'] as String?,
      secureUrl: json['secure_url'] as String?,
      width: json['width'] as String?,
      height: json['height'] as String?,
      type: json['type'] as String?,
      alt: json['alt'] as String?,
    );

Map<String, dynamic> _$OgImageToJson(OgImage instance) => <String, dynamic>{
      'image': instance.image,
      'url': instance.url,
      'secure_url': instance.secureUrl,
      'width': instance.width,
      'height': instance.height,
      'type': instance.type,
      'alt': instance.alt,
    };

OgVideo _$OgVideoFromJson(Map json) => OgVideo(
      image: json['image'] as String?,
      url: json['url'] as String?,
      secureUrl: json['secure_url'] as String?,
      width: json['width'] as String?,
      height: json['height'] as String?,
      type: json['type'] as String?,
      alt: json['alt'] as String?,
    );

Map<String, dynamic> _$OgVideoToJson(OgVideo instance) => <String, dynamic>{
      'image': instance.image,
      'url': instance.url,
      'secure_url': instance.secureUrl,
      'width': instance.width,
      'height': instance.height,
      'type': instance.type,
      'alt': instance.alt,
    };

OgAudio _$OgAudioFromJson(Map json) => OgAudio(
      audio: json['audio'] as String?,
      url: json['url'] as String?,
      secureUrl: json['secure_url'] as String?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$OgAudioToJson(OgAudio instance) => <String, dynamic>{
      'audio': instance.audio,
      'url': instance.url,
      'secure_url': instance.secureUrl,
      'type': instance.type,
    };
