import 'package:membo/exceptions/app_exception.dart';
import 'package:membo/models/board/board_permission.dart';
import 'package:membo/models/view_model_state/home_page_state.dart';
import 'package:membo/repositories/supabase/auth/supabase_auth_repository.dart';
import 'package:membo/repositories/supabase/db/supabase_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_page_view_model.g.dart';

@riverpod
class HomePageViewModel extends _$HomePageViewModel {
  @override
  HomePageState build() => const HomePageState();

  void initialize() async {
    final user = ref.read(userStateProvider);

    final userData = await ref
        .read(supabaseRepositoryProvider)
        .fetchUserData(user?.id ?? '')
        .catchError((e) {
      print('error: $e');
      return null;
    });

    if (userData == null) {
      print('userData is null');
      return;
    }

    final tempCardBoardList = <CardBoardModel>[];
    final tempThumbnailUrls = <String>[];

    /// 同じ要素を排除するために、集合にしてからリストに戻す
    final linkAndOwnBoards =
        {...userData.linkedBoardIds, ...userData.ownedBoardIds}.toList();

    for (String boardId in linkAndOwnBoards) {
      try {
        final board =
            await ref.read(supabaseRepositoryProvider).getBoardById(boardId);

        /// boardがnullの場合
        if (board == null) {
          continue;
        }

        if (board.thumbnailUrl != null) {
          tempThumbnailUrls.add(board.thumbnailUrl!);
        }

        /// permission check
        final permission = board.ownerId == userData.userId
            ? BoardPermission.owner
            : board.editableUserIds.contains(userData.userId)
                ? BoardPermission.editor
                : BoardPermission.viewer;
        tempCardBoardList
            .add(CardBoardModel(board: board, permission: permission));
      } catch (e) {
        print('error: $e');
      }
    }
    state = state.copyWith(
      isLoading: false,
      userModel: userData,
      cardBoardList: tempCardBoardList,
      carouselImageUrls: tempThumbnailUrls,
    );
  }

  Future<void> deleteBoardFromCard(String boardId) async {
    final user = ref.read(userStateProvider);
    if (user == null) {
      throw Exception('User is not loaded');
    }
    final userData =
        await ref.read(supabaseRepositoryProvider).fetchUserData(user.id);
    if (userData == null) {
      throw Exception('User data is not loaded');
    }

    if (userData.ownedBoardIds.contains(boardId)) {
      try {
        /// boardの削除
        await ref.read(supabaseRepositoryProvider).deleteBoard(boardId);
        final newOwnedBoardIds = userData.ownedBoardIds
            .where((element) => element != boardId)
            .toList();

        /// ownedBoardIdsの更新
        await ref
            .read(supabaseRepositoryProvider)
            .updateOwnedBoardIds(userData.userId, newOwnedBoardIds);

        /// stateの更新
        state = state.copyWith(
          cardBoardList: state.cardBoardList
              .where((element) => element.board.boardId != boardId)
              .toList(),
        );
      } catch (e) {
        throw AppException.error('board delete failed',
            detail: 'owned board delete failed : $e');
      }
    }

    if (userData.linkedBoardIds.contains(boardId)) {
      try {
        final newLinkedBoardIds = userData.linkedBoardIds
            .where((element) => element != boardId)
            .toList();

        /// linkedBoardIdsの更新
        await ref
            .read(supabaseRepositoryProvider)
            .updateLinkedBoardIds(userData.userId, newLinkedBoardIds);

        /// stateの更新
        state = state.copyWith(
          cardBoardList: state.cardBoardList
              .where((element) => element.board.boardId != boardId)
              .toList(),
        );
      } catch (e) {
        throw AppException.error('board delete failed',
            detail: 'linked board delete failed : $e');
      }
    }
  }
}
