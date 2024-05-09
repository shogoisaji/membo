// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stream_board_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$streamBoardHash() => r'7863f9e00f7ea4a872ac35c5f0e90f04390d42c0';

/// See also [streamBoard].
@ProviderFor(streamBoard)
final streamBoardProvider = StreamProvider<BoardModel?>.internal(
  streamBoard,
  name: r'streamBoardProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$streamBoardHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef StreamBoardRef = StreamProviderRef<BoardModel?>;
String _$streamBoardModelHash() => r'86c3d71e7fe77beed5695a7909c6870c506f8d2c';

/// See also [streamBoardModel].
@ProviderFor(streamBoardModel)
final streamBoardModelProvider = Provider<BoardModel?>.internal(
  streamBoardModel,
  name: r'streamBoardModelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$streamBoardModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef StreamBoardModelRef = ProviderRef<BoardModel?>;
String _$streamBoardIdHash() => r'ecd5b2eeca984b40fc6fef742f9ce53b7f884041';

/// See also [StreamBoardId].
@ProviderFor(StreamBoardId)
final streamBoardIdProvider = NotifierProvider<StreamBoardId, String>.internal(
  StreamBoardId.new,
  name: r'streamBoardIdProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$streamBoardIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$StreamBoardId = Notifier<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
