import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ignore_for_file: cascade_invocations

/// Icon set of stream feed
class StreamSvgIcon extends StatelessWidget {
  /// Builds a [StreamSvgIcon]
  const StreamSvgIcon({
    Key? key,
    required this.assetName,
    this.color,
    this.width = 14,
    this.height = 14,
  }) : super(key: key);

  /// [StreamSvgIcon] loveActive icon
  factory StreamSvgIcon.loveActive({
    double? size,
    Color? color,
  }) =>
      StreamSvgIcon(
        assetName: 'love_active.svg',
        color: color,
        width: size,
        height: size,
      );

  /// [StreamSvgIcon] loveInactive icon
  factory StreamSvgIcon.loveInactive({
    double? size,
    Color? color,
  }) =>
      StreamSvgIcon(
        assetName: 'love_inactive.svg',
        color: color,
        width: size,
        height: size,
      );

  /// [StreamSvgIcon] repost icon
  factory StreamSvgIcon.repost({
    double? size,
    Color? color,
  }) =>
      StreamSvgIcon(
        assetName: 'repost.svg',
        color: color,
        width: size,
        height: size,
      );

  /// [StreamSvgIcon] reply icon
  factory StreamSvgIcon.reply({
    double? size,
    Color? color,
  }) =>
      StreamSvgIcon(
        assetName: 'reply.svg',
        color: color,
        width: size,
        height: size,
      );

  /// [StreamSvgIcon] share icon
  factory StreamSvgIcon.share({
    double? size,
    Color? color,
  }) =>
      StreamSvgIcon(
        assetName: 'share.svg',
        color: color,
        width: size,
        height: size,
      );

  /// [StreamSvgIcon] post icon
  factory StreamSvgIcon.post({
    double? size,
    Color? color,
  }) =>
      StreamSvgIcon(
        assetName: 'post.svg',
        color: color,
        width: size,
        height: size,
      );

  /// [StreamSvgIcon] categories icon
  factory StreamSvgIcon.categories({
    double? size,
    Color? color,
  }) =>
      StreamSvgIcon(
        assetName: 'categories.svg',
        color: color,
        width: size,
        height: size,
      );

  /// [StreamSvgIcon] gear icon
  factory StreamSvgIcon.gear({
    double? size,
    Color? color,
  }) =>
      StreamSvgIcon(
        assetName: 'gear.svg',
        color: color,
        width: size,
        height: size,
      );

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.avatar({
    double? size,
    Color? color,
  }) =>
      StreamSvgIcon(
        assetName: 'avatar.svg',
        color: color,
        width: size,
        height: size,
      );

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.close({
    double? size,
    Color? color,
  }) =>
      StreamSvgIcon(
        assetName: 'close.svg',
        color: color,
        width: size,
        height: size,
      );

  /// The name of the icon asset
  final String assetName;

  /// The width of the icon
  final double? width;

  /// The height of the icon
  final double? height;

  /// The color of the icon
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final key = Key('StreamSvgIcon-$assetName');
    return SvgPicture.asset(
      'lib/svgs/$assetName', //TODO: allow to load via url for ReactionIcon
      package: 'stream_feed_flutter',
      key: key,
      width: width,
      height: height,
      color: color,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('assetName', assetName));
    properties.add(DoubleProperty('width', width));
    properties.add(DoubleProperty('height', height));
    properties.add(ColorProperty('color', color));
  }
}
