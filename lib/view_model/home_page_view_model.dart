import 'package:membo/exceptions/app_exception.dart';
import 'package:membo/models/board/board_model.dart';
import 'package:membo/models/board/board_permission.dart';
import 'package:membo/models/board/linked_board_model.dart';
import 'package:membo/models/view_model_state/home_page_state.dart';
import 'package:membo/repositories/shared_preferences/shared_preferences_key.dart';
import 'package:membo/repositories/shared_preferences/shared_preferences_repository.dart';
import 'package:membo/repositories/supabase/auth/supabase_auth_repository.dart';
import 'package:membo/repositories/supabase/db/supabase_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

part 'home_page_view_model.g.dart';

@Riverpod(keepAlive: true)
class HomePageViewModel extends _$HomePageViewModel {
  @override
  HomePageState build() => const HomePageState();

  /// TODO:user dataのselectを指定してソートして取得した方が良いかも
  Future<void> initialize() async {
    final user = ref.read(userStateProvider);

    final userData = await ref
        .read(supabaseRepositoryProvider)
        .fetchUserData(user?.id ?? '')
        .catchError((e) {
      throw AppException.error('${e.title}');
    });

    if (userData == null) {
      throw AppException.notFound();
    }

    var tempOwnedCardBoardList = <CardBoardModel>[];
    var tempLinkedCardBoardList = <CardBoardModel>[];
    var tempCarouselImageUrls = <String>[];

    /// カルーセルの最大数
    const carouselLimit = 5;

    /// owned board
    for (String boardId in userData.ownedBoardIds) {
      try {
        final board =
            await ref.read(supabaseRepositoryProvider).getBoardById(boardId);

        final boardForCard = BoardModel(
          boardId: boardId,
          boardName: board.boardName,
          ownerId: board.ownerId,
          thatDay: board.thatDay,
          editableUserIds: board.editableUserIds,
          createdAt: board.createdAt,
          thumbnailUrl: board.thumbnailUrl,
        );

        tempOwnedCardBoardList.add(CardBoardModel(
            board: boardForCard, permission: BoardPermission.owner));

        /// カルーセルの画像URLを追加
        if (board.thumbnailUrl != null &&
            tempCarouselImageUrls.length < carouselLimit) {
          tempCarouselImageUrls.add(board.thumbnailUrl!);
        }
      } on AppException catch (e) {
        if (e.type == AppExceptionType.notFound) {
          print('owned board not found');
        }
      } catch (e) {
        //
      }
    }

    /// linked board
    // final result = await ref.read(sqfliteRepositoryProvider).loadLinkedBoards();
    final result = userData.linkedBoards;

    for (LinkedBoardModel linkedBoard in result) {
      BoardModel? boardForCard;
      try {
        try {
          /// ボードデータを取得できるか試す
          final board = await ref
              .read(supabaseRepositoryProvider)
              .getBoardById(linkedBoard.boardId);
          boardForCard = BoardModel(
            boardId: board.boardId,
            boardName: board.boardName,
            ownerId: board.ownerId,
            thatDay: board.thatDay,
            editableUserIds: board.editableUserIds,
            createdAt: board.createdAt,
            thumbnailUrl: board.thumbnailUrl,
          );
        } catch (e) {
          /// ボードデータを取得できない場合
          /// ローカルデータ以外は仮のデータ
          boardForCard = BoardModel(
            boardId: linkedBoard.boardId,
            boardName: linkedBoard.boardName,
            ownerId: '',
            thatDay: DateTime.now(),
            createdAt: DateTime.now(),
            thumbnailUrl: linkedBoard.thumbnailUrl,
          );
        }

        var editableUserIds = <String>[];

        try {
          editableUserIds = await ref
              .read(supabaseRepositoryProvider)
              .getEditableUserIds(linkedBoard.boardId);
        } catch (e) {
          // 権限がない場合
        }

        /// permission check
        final permission = editableUserIds.contains(userData.userId)
            ? BoardPermission.editor
            : BoardPermission.viewer;
        tempLinkedCardBoardList = [
          ...tempLinkedCardBoardList,
          CardBoardModel(board: boardForCard, permission: permission)
        ];

        /// カルーセルの画像URLを追加
        if (linkedBoard.thumbnailUrl != null &&
            tempCarouselImageUrls.length < carouselLimit) {
          tempCarouselImageUrls.add(linkedBoard.thumbnailUrl!);
        }
      } on AppException catch (e) {
        if (e.type == AppExceptionType.notFound) {
          print('linked board not found');
        }
      } catch (e) {
        //
      }
    }

    state = state.copyWith(
      userModel: userData,
      allCardBoardList: [
        ...tempOwnedCardBoardList.reversed,
        ...tempLinkedCardBoardList.reversed
      ],
      ownedCardBoardList: tempOwnedCardBoardList.reversed.toList(),
      linkedCardBoardList: tempLinkedCardBoardList.reversed.toList(),
      carouselImageUrls: tempCarouselImageUrls,
    );
  }

  Future<bool> checkFirstLogin() async {
    final isFirst = ref
        .read(sharedPreferencesRepositoryProvider)
        .fetch<bool>(SharedPreferencesKey.isFirst);
    return isFirst ?? true;
  }

  void firstLogin() async {
    await ref
        .read(sharedPreferencesRepositoryProvider)
        .save<bool>(SharedPreferencesKey.isFirst, false);
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

    /// owned boardの場合
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
          ownedCardBoardList: state.ownedCardBoardList
              .where((element) => element.board.boardId != boardId)
              .toList(),
        );
        initialize();
        return;
      } catch (e) {
        throw AppException.error('owned board delete failed',
            detail: 'owned board delete failed : $e');
      }
    }

    /// linked boardの場合
    else {
      try {
        /// linked boardの削除
        final newLinkedBoards = userData.linkedBoards
            .where((element) => element.boardId != boardId)
            .toList();
        await ref
            .read(supabaseRepositoryProvider)
            .updateLinkedBoards(user.id, newLinkedBoards)
            .catchError((e) {
          throw Exception('update linked boards failed');
        });

        /// stateの更新
        state = state.copyWith(
          linkedCardBoardList: state.linkedCardBoardList
              .where((element) => element.board.boardId != boardId)
              .toList(),
        );
        initialize();
      } catch (e) {
        throw AppException.error('linked board delete failed',
            detail: 'linked board delete failed : $e');
      }
    }
  }

  Future<String> createNewBoard(String boardName) async {
    /// Get the current user
    final User? user = ref.read(userStateProvider);
    if (user == null) {
      throw Exception('User is not signed in');
    }
    final userData =
        await ref.read(supabaseRepositoryProvider).fetchUserData(user.id);
    if (userData == null) {
      throw Exception('User data is not loaded');
    }
    final maxImageCount = userData.membershipType.maxImageCount;
    final newBoard = BoardModel(
      boardId: const Uuid().v4(),
      boardName: boardName,
      ownerId: user.id,
      maxImageCount: maxImageCount,
      thatDay: DateTime.now(),
      createdAt: DateTime.now(),
    );

    /// tableに新しいboardを追加
    final insertedBoardId =
        await ref.read(supabaseRepositoryProvider).insertBoard(newBoard);

    /// 仮のListにboard idを追加
    final newOwnedBoardIds = [...userData.ownedBoardIds, insertedBoardId];

    /// ownedBoardIdsの更新
    await ref
        .read(supabaseRepositoryProvider)
        .updateOwnedBoardIds(userData.userId, newOwnedBoardIds);

    return insertedBoardId;
  }

  /// have the authority -> true, no authority -> false
  Future<bool> checkPermission(String boardId) async {
    final user = ref.read(userStateProvider);
    if (user == null) {
      throw Exception('User is not loaded');
    }
    final userData =
        await ref.read(supabaseRepositoryProvider).fetchUserData(user.id);
    if (userData == null) {
      throw Exception('User data is not loaded');
    }

    final board =
        await ref.read(supabaseRepositoryProvider).getBoardById(boardId);

    return board.ownerId == userData.userId ||
        board.editableUserIds.contains(userData.userId);
  }
}
