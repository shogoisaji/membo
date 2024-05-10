import 'package:membo/models/user/user_model.dart';
import 'package:membo/models/view_model_state/account_page_state.dart';
import 'package:membo/repositories/supabase/db/supabase_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'account_page_view_model.g.dart';

@riverpod
class AccountPageViewModel extends _$AccountPageViewModel {
  @override
  AccountPageState build() => const AccountPageState();

  void getUser(UserModel user) {
    state = state.copyWith(user: user);
  }

  Future<void> updateUserName(String userName) async {
    final userId = state.user?.userId;
    if (userId == null) {
      throw Exception('userId is not set');
    }
    await ref
        .read(supabaseRepositoryProvider)
        .updateUserName(userId, userName)
        .catchError((e) {
      throw Exception('updateUserName error: $e');
    });

    final newUserData = state.user!.copyWith(userName: userName);
    state = state.copyWith(user: newUserData);
  }
}
