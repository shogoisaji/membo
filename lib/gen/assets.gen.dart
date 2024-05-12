/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/icon.png
  AssetGenImage get icon => const AssetGenImage('assets/images/icon.png');

  $AssetsImagesIconsGen get icons => const $AssetsImagesIconsGen();

  /// File path: assets/images/sky.jpg
  AssetGenImage get sky => const AssetGenImage('assets/images/sky.jpg');

  $AssetsImagesSvgGen get svg => const $AssetsImagesSvgGen();

  /// File path: assets/images/title.png
  AssetGenImage get title => const AssetGenImage('assets/images/title.png');

  /// List of all assets
  List<AssetGenImage> get values => [icon, sky, title];
}

class $AssetsLottiesGen {
  const $AssetsLottiesGen();

  /// File path: assets/lotties/hello.json
  String get hello => 'assets/lotties/hello.json';

  /// List of all assets
  List<String> get values => [hello];
}

class $AssetsImagesIconsGen {
  const $AssetsImagesIconsGen();

  /// File path: assets/images/icons/apple_official.png
  AssetGenImage get appleOfficialPng =>
      const AssetGenImage('assets/images/icons/apple_official.png');

  /// File path: assets/images/icons/apple_official.svg
  String get appleOfficialSvg => 'assets/images/icons/apple_official.svg';

  /// File path: assets/images/icons/google_official.png
  AssetGenImage get googleOfficialPng =>
      const AssetGenImage('assets/images/icons/google_official.png');

  /// File path: assets/images/icons/google_official.svg
  String get googleOfficialSvg => 'assets/images/icons/google_official.svg';

  /// List of all assets
  List<dynamic> get values => [
        appleOfficialPng,
        appleOfficialSvg,
        googleOfficialPng,
        googleOfficialSvg
      ];
}

class $AssetsImagesSvgGen {
  const $AssetsImagesSvgGen();

  /// File path: assets/images/svg/elephant.svg
  String get elephant => 'assets/images/svg/elephant.svg';

  /// File path: assets/images/svg/rabbit.svg
  String get rabbit => 'assets/images/svg/rabbit.svg';

  /// File path: assets/images/svg/turtle.svg
  String get turtle => 'assets/images/svg/turtle.svg';

  /// List of all assets
  List<String> get values => [elephant, rabbit, turtle];
}

class Assets {
  Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsLottiesGen lotties = $AssetsLottiesGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
