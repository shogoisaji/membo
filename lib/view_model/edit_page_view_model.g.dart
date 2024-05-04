// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_page_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$boardStreamHash() => r'4b24cf4fb6d57d470ce631f323145d6c4daa1f5c';

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
String _$boardModelStateHash() => r'cf66a311a7cddc2d70a7199a89da2bd008f33068';

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
String _$editPageViewModelHash() => r'359a6875126416d845d42ac1d92bcedc2037fbea';

/// See also [EditPageViewModel].
@ProviderFor(EditPageViewModel)
final editPageViewModelProvider =
    NotifierProvider<EditPageViewModel, EditPageState>.internal(
  EditPageViewModel.new,
  name: r'editPageViewModelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$editPageViewModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$EditPageViewModel = Notifier<EditPageState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
