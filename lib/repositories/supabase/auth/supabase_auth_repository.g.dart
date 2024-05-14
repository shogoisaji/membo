// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supabase_auth_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$supabaseAuthRepositoryHash() =>
    r'9a3eaef2981bb21de115a6349c7becaed3127d78';

/// See also [supabaseAuthRepository].
@ProviderFor(supabaseAuthRepository)
final supabaseAuthRepositoryProvider =
    Provider<SupabaseAuthRepository>.internal(
  supabaseAuthRepository,
  name: r'supabaseAuthRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$supabaseAuthRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SupabaseAuthRepositoryRef = ProviderRef<SupabaseAuthRepository>;
String _$sessionStateStreamHash() =>
    r'd7513e96c8dbabac12782c8a9b11935291a47c7c';

/// See also [sessionStateStream].
@ProviderFor(sessionStateStream)
final sessionStateStreamProvider = AutoDisposeStreamProvider<Session?>.internal(
  sessionStateStream,
  name: r'sessionStateStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sessionStateStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SessionStateStreamRef = AutoDisposeStreamProviderRef<Session?>;
String _$sessionStateHash() => r'1e9f5c2d9e4eef8796010596efad180bfc41ed15';

/// See also [sessionState].
@ProviderFor(sessionState)
final sessionStateProvider = AutoDisposeProvider<Session?>.internal(
  sessionState,
  name: r'sessionStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$sessionStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SessionStateRef = AutoDisposeProviderRef<Session?>;
String _$userStateHash() => r'af4cc4e4d9a50be490c8cde413efb263b0bcf9c8';

/// See also [userState].
@ProviderFor(userState)
final userStateProvider = AutoDisposeProvider<User?>.internal(
  userState,
  name: r'userStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UserStateRef = AutoDisposeProviderRef<User?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
