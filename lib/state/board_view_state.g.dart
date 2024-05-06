// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_view_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$boardStreamHash() => r'0c74800b91dabb3a67b44544d505f761e3acc4b3';

/// See also [boardStream].
@ProviderFor(boardStream)
final boardStreamProvider = StreamProvider<BoardModel?>.internal(
  boardStream,
  name: r'boardStreamProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$boardStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef BoardStreamRef = StreamProviderRef<BoardModel?>;
String _$boardModelStateHash() => r'e072f9b5b6526531b8b05cd9cde3673b6b66f3f3';

/// See also [boardModelState].
@ProviderFor(boardModelState)
final boardModelStateProvider = Provider<BoardModel?>.internal(
  boardModelState,
  name: r'boardModelStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$boardModelStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef BoardModelStateRef = ProviderRef<BoardModel?>;
String _$selectedBoardIdHash() => r'fd04aff0339552e48948ccb11c394807118d131b';

/// See also [SelectedBoardId].
@ProviderFor(SelectedBoardId)
final selectedBoardIdProvider =
    NotifierProvider<SelectedBoardId, String>.internal(
  SelectedBoardId.new,
  name: r'selectedBoardIdProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedBoardIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedBoardId = Notifier<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
