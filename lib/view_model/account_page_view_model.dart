import 'package:membo/models/user/user_model.dart';
import 'package:membo/models/view_model_state/account_page_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'account_page_view_model.g.dart';

@Riverpod(keepAlive: true)
class AccountPageViewModel extends _$AccountPageViewModel {
  @override
  AccountPageState build() => const AccountPageState();

  void getUser(UserModel user) {
    state = state.copyWith(user: user);
  }
}
