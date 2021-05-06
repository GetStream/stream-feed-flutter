import 'package:equatable/equatable.dart';

class Message with EquatableMixin {
  String? id;
  final String channel;
  String? clientId;
  String? connectionType;
  String? version;
  String? minimumVersion;
  List<String>? supportedConnectionTypes;
  Advice? advice;
  bool? successful;
  String? subscription;
  Map<String, dynamic>? data;
  Map<String, Object>? ext;
  String? error;

  Message(
    this.channel, {
    this.clientId,
    this.version,
    this.minimumVersion,
    this.connectionType,
    this.supportedConnectionTypes,
    this.advice,
    this.successful,
    this.subscription,
    this.ext,
    this.data,
    this.error,
  });

  Map<String, Object?> toJson() {
    final result = <String, Object?>{};
    if (id != null) result['id'] = id;
    if (clientId != null) result['clientId'] = clientId;
    if (data != null) result['data'] = data;
    result['channel'] = channel;
    if (connectionType != null) result['connectionType'] = connectionType;
    if (version != null) result['version'] = version;
    if (minimumVersion != null) result['minimumVersion'] = minimumVersion;
    if (supportedConnectionTypes != null)
      result['supportedConnectionTypes'] = supportedConnectionTypes;
    if (advice != null) result['advice'] = advice;
    if (successful != null) result['successful'] = successful;
    if (subscription != null) result['subscription'] = subscription;
    if (ext != null) result['ext'] = ext;
    if (version != null) result['error'] = error;
    return result;
  }

  factory Message.fromJson(Map<String, Object?> json) {
    final advice = json['advice'] as Map<String, dynamic>?;
    final message = Message(
      json['channel'] as String,
      clientId: json['clientId'] as String?,
      connectionType: json['connectionType'] as String?,
      version: json['version'] as String?,
      minimumVersion: json['minimumVersion'] as String?,
      supportedConnectionTypes: (json['supportedConnectionTypes'] as List?)
          ?.map((e) => e as String)
          .toList(),
      advice: advice == null ? null : Advice.fromJson(advice),
      successful: json['successful'] as bool?,
      subscription: json['subscription'] as String?,
      ext: json['ext'] as Map<String, Object>?,
      data: json['data'] as Map<String, dynamic>?,
      error: json['error'] as String?,
    )..id = json['id'] as String?;
    return message;
  }

  @override
  List<Object?> get props => [id, channel, clientId];

  @override
  toString() => '${toJson()}';
}

class Advice extends Equatable {
  const Advice({
    required this.reconnect,
    required this.interval,
    this.timeout,
  });

  final String reconnect;
  final int interval;
  final int? timeout;

  static const none = 'none';
  static const handshake = 'handshake';
  static const retry = 'retry';

  factory Advice.fromJson(Map<String, dynamic> json) => Advice(
        reconnect: json["reconnect"] == null ? null : json["reconnect"],
        interval: json["interval"] == null ? null : json["interval"],
        timeout: json["timeout"] == null ? null : json["timeout"],
      );

  Map<String, Object?> toJson() => {
        "reconnect": reconnect,
        "interval": interval,
        "timeout": timeout,
      };

  @override
  List<Object?> get props => [
        reconnect,
        interval,
        timeout,
      ];
}
