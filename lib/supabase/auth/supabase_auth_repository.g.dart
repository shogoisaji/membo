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
    r'd104c3b81ecd968a8aaf437032dab468084f8269';

/// See also [sessionStateStream].
@ProviderFor(sessionStateStream)
final sessionStateStreamProvider = StreamProvider<Session?>.internal(
  sessionStateStream,
  name: r'sessionStateStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sessionStateStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SessionStateStreamRef = StreamProviderRef<Session?>;
String _$sessionStateHash() => r'c907b006ce0217e9c0ae3bfb99e7fbb3bf8b66d4';

/// See also [sessionState].
@ProviderFor(sessionState)
final sessionStateProvider = Provider<Session?>.internal(
  sessionState,
  name: r'sessionStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$sessionStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SessionStateRef = ProviderRef<Session?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
