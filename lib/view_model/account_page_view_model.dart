import 'package:image_picker/image_picker.dart';
import 'package:membo/models/user/user_model.dart';
import 'package:membo/models/view_model_state/account_page_state.dart';
import 'package:membo/repositories/sqflite/sqflite_repository.dart';
import 'package:membo/repositories/supabase/auth/supabase_auth_repository.dart';
import 'package:membo/repositories/supabase/db/supabase_repository.dart';
import 'package:membo/repositories/supabase/storage/supabase_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'account_page_view_model.g.dart';

@riverpod
class AccountPageViewModel extends _$AccountPageViewModel {
  @override
  AccountPageState build() => const AccountPageState();

  Future<void> initializeLoad() async {
    final user = ref.read(userStateProvider);
    if (user == null) {
      throw Exception('User is not loaded');
    }
    final userData =
        await ref.read(supabaseRepositoryProvider).fetchUserData(user.id);
    if (userData == null) {
      throw Exception('User is not loaded');
    }

    state = state.copyWith(user: userData, isLoading: false);
  }

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

  Future<void> updateAvatar() async {
    const imageMaxSize = 500.0;
    const pickImageMaxDataSize = 1.0; //  MB
    final picker = ImagePicker();

    final user = ref.read(userStateProvider);
    if (user == null) {
      throw Exception('User is not loaded');
    }
    final userData =
        await ref.read(supabaseRepositoryProvider).fetchUserData(user.id);
    if (userData == null) {
      throw Exception('User is not loaded');
    }

    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: imageMaxSize,
        maxHeight: imageMaxSize,
        imageQuality: 100,
      );

      if (image == null) {
        return;
      }

      /// 画像のデータサイズチェック
      final uint8List = await image.readAsBytes();
      final imageSizeInBytes = uint8List.lengthInBytes;

      double imageSizeInMB = imageSizeInBytes / (1024 * 1024);

      if (imageSizeInMB > pickImageMaxDataSize) {
        throw Exception('Image size is too large');
      }

      /// すでにアバター画像がある場合は削除
      if (userData.avatarUrl != null) {
        await ref
            .read(supabaseStorageProvider)
            .deleteAvatarImage(userData.avatarUrl!);
      }

      final storagePath = await ref
          .read(supabaseRepositoryProvider)
          .updateAvatarImage(userData, image);

      if (storagePath == null) {
        throw Exception('Error updateAvatar(): storagePath is null');
      }

      state = state.copyWith(user: userData.copyWith(avatarUrl: storagePath));
    } catch (e) {
      throw Exception('Error updateAvatar(): $e');
    }
  }

  Future<void> deleteAccount() async {
    final userId = state.user?.userId;
    if (userId == null) {
      throw Exception('userId is not set');
    }
    final userData =
        await ref.read(supabaseRepositoryProvider).fetchUserData(userId);
    if (userData == null) {
      throw Exception('User is not loaded');
    }

    /// owned board を全て削除
    for (final boardId in userData.ownedBoardIds) {
      /// 画像の削除
      final board =
          await ref.read(supabaseRepositoryProvider).getBoardById(boardId);
      await ref.read(supabaseStorageProvider).deleteImageFolder(board);

      /// Board削除
      await ref.read(supabaseRepositoryProvider).deleteBoard(boardId);
    }

    /// Edge Function "delete-user"を呼び出す
    await ref.read(supabaseAuthRepositoryProvider).deleteAccount(userId);

    /// SQFliteのデータを全て削除
    await ref.read(sqfliteRepositoryProvider).deleteAllRows();
  }
}
