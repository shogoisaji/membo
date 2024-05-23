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

  /// File path: assets/images/hint1.png
  AssetGenImage get hint1 => const AssetGenImage('assets/images/hint1.png');

  /// File path: assets/images/hint2.png
  AssetGenImage get hint2 => const AssetGenImage('assets/images/hint2.png');

  /// File path: assets/images/hint3.png
  AssetGenImage get hint3 => const AssetGenImage('assets/images/hint3.png');

  /// File path: assets/images/hint4.png
  AssetGenImage get hint4 => const AssetGenImage('assets/images/hint4.png');

  /// File path: assets/images/hint5.png
  AssetGenImage get hint5 => const AssetGenImage('assets/images/hint5.png');

  /// File path: assets/images/hint6.png
  AssetGenImage get hint6 => const AssetGenImage('assets/images/hint6.png');

  /// File path: assets/images/icon.png
  AssetGenImage get icon => const AssetGenImage('assets/images/icon.png');

  /// Directory path: assets/images/icons
  $AssetsImagesIconsGen get icons => const $AssetsImagesIconsGen();

  /// File path: assets/images/splash.png
  AssetGenImage get splash => const AssetGenImage('assets/images/splash.png');

  /// Directory path: assets/images/svg
  $AssetsImagesSvgGen get svg => const $AssetsImagesSvgGen();

  /// File path: assets/images/title.png
  AssetGenImage get title => const AssetGenImage('assets/images/title.png');

  /// List of all assets
  List<AssetGenImage> get values =>
      [hint1, hint2, hint3, hint4, hint5, hint6, icon, splash, title];
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

  /// File path: assets/images/svg/circle-exclamation.svg
  String get circleExclamation => 'assets/images/svg/circle-exclamation.svg';

  /// File path: assets/images/svg/circle-question.svg
  String get circleQuestion => 'assets/images/svg/circle-question.svg';

  /// File path: assets/images/svg/connect.svg
  String get connect => 'assets/images/svg/connect.svg';

  /// File path: assets/images/svg/cutting.svg
  String get cutting => 'assets/images/svg/cutting.svg';

  /// File path: assets/images/svg/dustbox.svg
  String get dustbox => 'assets/images/svg/dustbox.svg';

  /// File path: assets/images/svg/edit.svg
  String get edit => 'assets/images/svg/edit.svg';

  /// File path: assets/images/svg/editor.svg
  String get editor => 'assets/images/svg/editor.svg';

  /// File path: assets/images/svg/elephant.svg
  String get elephant => 'assets/images/svg/elephant.svg';

  /// File path: assets/images/svg/email.svg
  String get email => 'assets/images/svg/email.svg';

  /// File path: assets/images/svg/qr.svg
  String get qr => 'assets/images/svg/qr.svg';

  /// File path: assets/images/svg/rabbit.svg
  String get rabbit => 'assets/images/svg/rabbit.svg';

  /// File path: assets/images/svg/request.svg
  String get request => 'assets/images/svg/request.svg';

  /// File path: assets/images/svg/rotate.svg
  String get rotate => 'assets/images/svg/rotate.svg';

  /// File path: assets/images/svg/scale.svg
  String get scale => 'assets/images/svg/scale.svg';

  /// File path: assets/images/svg/title.svg
  String get title => 'assets/images/svg/title.svg';

  /// File path: assets/images/svg/turtle.svg
  String get turtle => 'assets/images/svg/turtle.svg';

  /// File path: assets/images/svg/unlink.svg
  String get unlink => 'assets/images/svg/unlink.svg';

  /// File path: assets/images/svg/vertical.svg
  String get vertical => 'assets/images/svg/vertical.svg';

  /// File path: assets/images/svg/view.svg
  String get view => 'assets/images/svg/view.svg';

  /// File path: assets/images/svg/view1.svg
  String get view1 => 'assets/images/svg/view1.svg';

  /// List of all assets
  List<String> get values => [
        circleExclamation,
        circleQuestion,
        connect,
        cutting,
        dustbox,
        edit,
        editor,
        elephant,
        email,
        qr,
        rabbit,
        request,
        rotate,
        scale,
        title,
        turtle,
        unlink,
        vertical,
        view,
        view1
      ];
}

class Assets {
  Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsLottiesGen lotties = $AssetsLottiesGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName, {this.size = null});

  final String _assetName;

  final Size? size;

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
