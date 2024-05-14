import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:membo/models/user/user_model.dart';

part 'account_page_state.freezed.dart';

@freezed
class AccountPageState with _$AccountPageState {
  const factory AccountPageState({
    @Default(true) bool isLoading,
    UserModel? user,
  }) = _AccountPageState;
}
