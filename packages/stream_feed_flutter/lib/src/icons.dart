import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Icon set of stream chat
class StreamSvgIcon extends StatelessWidget {
  /// Constructor for creating a [StreamSvgIcon]
  const StreamSvgIcon({
    Key? key,
    this.assetName,
    this.color,
    this.width = 24,
    this.height = 24,
  }) : super(key: key);

  /// Name of icon asset
  final String? assetName;

  /// Width of icon
  final double? width;

  /// Height of icon
  final double? height;

  /// Color of icon
  final Color? color;

  /// [StreamSvgIcon] type
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

  /// [StreamSvgIcon] type
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

  /// [StreamSvgIcon] type
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

  /// [StreamSvgIcon] type
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

  /// [StreamSvgIcon] type
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

  /// [StreamSvgIcon] type
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

  /// [StreamSvgIcon] type
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

  /// [StreamSvgIcon] type
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
  @override
  Widget build(BuildContext context) {
    final key = Key('StreamSvgIcon-$assetName');
    return SvgPicture.asset(
      'lib/svgs/$assetName',
      package: 'stream_feed_flutter',
      key: key,
      width: width,
      height: height,
      color: color,
    );
  }
}
