import 'dart:async';

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

  // User? get authUser => _client.auth.currentUser;

// Email and password sign up
  Future<String?> signUp(String email, String password, String username, String? phoneNumber) async {
    try {
      await _client.auth
          .signUp(email: email, password: password, data: {"user_name": username, "phone_number": phoneNumber});
      return null;
    } on AuthException catch (er) {
      print(er.message);
      return er.message;
    } catch (err) {
      // return ErrorHandler.handleError(err);
    }
    return null;
  }

// Email and password login
  Future<String?> signIn(String email, String password) async {
    try {
      await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return null;
    } on AuthException catch (er) {
      print(er.message);
      return '${er.statusCode}:${er.message}';
    } catch (err) {
      // return ErrorHandler.handleError(err);
    }
    return null;
  }

// Sign out
  void signOut() async {
    await _client.auth.signOut();
  }

// reset password
  Future<void> resetPassword() async {
    await _client.auth.reauthenticate();
  }

  Stream<Session?> streamSession() {
    StreamController<Session?> sessionController = StreamController<Session?>();
    _client.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      sessionController.add(session);
    });
    return sessionController.stream;
  }
}

// sessionを監視する
@Riverpod(keepAlive: true)
Stream<Session?> sessionStateStream(SessionStateStreamRef ref) {
  final session = ref.watch(supabaseAuthRepositoryProvider).streamSession();
  return session;
}

@Riverpod(keepAlive: true)
Session? sessionState(SessionStateRef ref) {
  final session = ref.watch(sessionStateStreamProvider);
  return session.when(
    loading: () => null,
    error: (e, __) {
      print("error: $e");
      return null;
    },
    data: (d) {
      return d;
    },
  );
}
