import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:membo/env/env.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'supabase_auth_repository.g.dart';

@Riverpod(keepAlive: true)
SupabaseAuthRepository supabaseAuthRepository(SupabaseAuthRepositoryRef ref) {
  return SupabaseAuthRepository(Supabase.instance.client);
}

class SupabaseAuthRepository {
  SupabaseAuthRepository(this._client);

  final SupabaseClient _client;

  User? get authUser => _client.auth.currentUser;

  Stream<Session?> streamSession() {
    StreamController<Session?> sessionController = StreamController<Session?>();
    _client.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      sessionController.add(session);
    });
    return sessionController.stream;
  }

// Google login
  Future<void> signInWithGoogle() async {
    try {
      if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
        /// Web Client ID that you registered with Google Cloud.
        final webClientId = Env.googleWebClientId;

        /// iOS Client ID that you registered with Google Cloud.
        final iosClientId = Env.googleIosClientId;

        final GoogleSignIn googleSignIn = GoogleSignIn(
          clientId: iosClientId,
          serverClientId: webClientId,
        );
        final googleUser = await googleSignIn.signIn();
        if (googleUser == null) {
          return;
        }
        final googleAuth = await googleUser.authentication;
        final accessToken = googleAuth.accessToken;
        final idToken = googleAuth.idToken;

        if (accessToken == null) {
          throw 'No Access Token found.';
        }
        if (idToken == null) {
          throw 'No ID Token found.';
        }

        await _client.auth.signInWithIdToken(
          provider: OAuthProvider.google,
          idToken: idToken,
          accessToken: accessToken,
        );
      } else {
        /// Web Client ID that you registered with Google Cloud.
        await _client.auth.signInWithOAuth(
          OAuthProvider.google,
        );
      }
    } on AuthException catch (_) {
      rethrow;
    } on Exception catch (_) {
      rethrow;
    }

    return;
  }

  // Apple login
  Future<AuthResponse> signInWithApple() async {
    if (!Platform.isIOS) {
      throw const AuthException(
          'Apple Sign In is only available on iOS devices.');
    }

    final rawNonce = _client.auth.generateRawNonce();
    final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: hashedNonce,
    );

    final idToken = credential.identityToken;
    if (idToken == null) {
      throw const AuthException(
          'Could not find ID Token from generated credential.');
    }

    return _client.auth.signInWithIdToken(
      provider: OAuthProvider.apple,
      idToken: idToken,
      nonce: rawNonce,
    );
  }

  /// Sign out
  void signOut() async {
    await _client.auth.signOut();
  }

  /// Delete account
  Future<void> deleteAccount(String userId) async {
    /// Edge Function "delete-user"を呼び出す
    await _client.functions.invoke("delete-user");
    signOut();
  }

  /// sign in with email
  Future<void> signInWithEmail(String email, String password) async {
    await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// sign up with email magic link
  Future<void> signUpWithEmailMagicLink(String email) async {
    await _client.auth.signInWithOtp(
      email: email,
      emailRedirectTo: 'io.supabase.flutterquickstart://login-callback/',
      data: {'name': 'test', 'password': 'password'},
    );
  }

  /// sign up with email
  Future<void> signUpWithEmail(String email, String password) async {
    try {
      await _client.auth.signUp(
        email: email,
        password: password,
      );
    } on AuthException catch (e) {
      throw AuthApiException(e.message);
    } catch (e) {
      throw AuthApiException(e.toString());
    }
  }
}

// sessionを監視する
@riverpod
Stream<Session?> sessionStateStream(SessionStateStreamRef ref) {
  final sessionStream =
      ref.watch(supabaseAuthRepositoryProvider).streamSession();
  return sessionStream;
}

@riverpod
Session? sessionState(SessionStateRef ref) {
  final sessionStreamData = ref.watch(sessionStateStreamProvider);
  return sessionStreamData.when(
    loading: () => null,
    error: (e, __) {
      return null;
    },
    data: (d) {
      return d;
    },
  );
}

@riverpod
User? userState(UserStateRef ref) {
  final session = ref.watch(sessionStateProvider);
  return session?.user;
}
