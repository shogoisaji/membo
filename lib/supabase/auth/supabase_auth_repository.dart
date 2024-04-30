import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

// Email and password sign up
  // Future<String?> signUp(
  //   String email,
  //   String password,
  //   String username,
  // ) async {
  //   try {
  //     await _client.auth.signUp(
  //         email: email, password: password, data: {"user_name": username});
  //     return null;
  //   } on AuthException catch (er) {
  //     debugPrint(er.message);
  //     return er.message;
  //   }
  // }

// Email and password login
  // Future<String?> signIn(String email, String password) async {
  //   try {
  //     await _client.auth.signInWithPassword(
  //       email: email,
  //       password: password,
  //     );
  //     return null;
  //   } on AuthException catch (er) {
  //     debugPrint(er.message);
  //     return '${er.statusCode}:${er.message}';
  //   }
  // }

// Google login
  Future<void> signInWithGoogle() async {
    try {
      if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
        /// Web Client ID that you registered with Google Cloud.
        const webClientId =
            '1060492417369-64g5v64ihohj67s5hlnvc6a1dttmukvr.apps.googleusercontent.com';

        /// iOS Client ID that you registered with Google Cloud.
        const iosClientId =
            '1060492417369-q13g6qkj44ovnt3llapv2nph7ie6ak05.apps.googleusercontent.com';

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
  Future<void> signInWithApple() async {
    if (!Platform.isIOS) {
      throw const AuthException(
          'Apple Sign In is only available on iOS devices.');
    }
    final rawNonce = _client.auth.generateRawNonce();
    final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

    AuthorizationCredentialAppleID? credential;
    try {
      credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );
    } catch (e) {
      return;
    }

    final idToken = credential.identityToken;
    if (idToken == null) {
      throw const AuthException(
          'Could not find ID Token from generated credential.');
    }

    _client.auth.signInWithIdToken(
      provider: OAuthProvider.apple,
      idToken: idToken,
      nonce: rawNonce,
    );
  }

// Sign out
  void signOut() async {
    await _client.auth.signOut();
  }

// reset password
  Future<void> resetPassword() async {
    await _client.auth.reauthenticate();
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
      debugPrint("error: $e");
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
