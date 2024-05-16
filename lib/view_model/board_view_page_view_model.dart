import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:membo/exceptions/app_exception.dart';
import 'package:membo/models/board/board_model.dart';
import 'package:membo/models/request/edit_request_model.dart';
import 'package:membo/models/view_model_state/board_view_page_state.dart';
import 'package:membo/repositories/supabase/auth/supabase_auth_repository.dart';
import 'package:membo/repositories/supabase/db/supabase_repository.dart';
import 'package:membo/state/stream_board_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'board_view_page_view_model.g.dart';

@riverpod
class BoardViewPageViewModel extends _$BoardViewPageViewModel {
  @override
  BoardViewPageState build() => BoardViewPageState();

  Matrix4 calcInitialTransform(BoardModel board, double w, double h) {
    final scaleW = w / board.width;
    final scaleH = h / board.height;
    final scale = scaleW < scaleH ? scaleW : scaleH;

    /// 横長の画面の場合
    if (scaleW > scaleH) {
      final addX = (w - board.width * scale) / 2 / scale;
      final translateX = (board.width - w) / 2 * 1 + addX;
      final translateY = (board.height - h) / 2 * 1;
      final matrix = Matrix4.identity()
        ..scale(scale)
        ..translate(translateX, translateY, 0);
      return matrix;

      /// 縦長の画面の場合
    } else {
      final addY = (h - board.height * scale) / 2 / scale;
      final translateX = (board.width - w) / 2 * 1;
      final translateY = (board.height - h) / 2 * 1 + addY;
      final matrix = Matrix4.identity()
        ..scale(scale)
        ..translate(translateX, translateY, 0);
      return matrix;
    }
  }

  Future<ViewPageUserTypes> checkUserType(String boardId) async {
    final user = ref.read(userStateProvider);
    if (user == null) {
      throw Exception('User is not loaded');
    }
    final userData =
        await ref.read(supabaseRepositoryProvider).fetchUserData(user.id);
    if (userData == null) {
      throw Exception('User is not loaded');
    }

    /// owner
    if (userData.ownedBoardIds.contains(boardId)) {
      return ViewPageUserTypes.owner;
    }

    final board =
        await ref.read(supabaseRepositoryProvider).getBoardById(boardId);

    /// editor
    if (board.editableUserIds.contains(userData.userId)) {
      return ViewPageUserTypes.editor;
    }

    if (userData.linkedBoardIds.contains(boardId)) {
      /// edit request check
      final existEditRequest = await ref
          .read(supabaseRepositoryProvider)
          .fetchEditRequestForRequestor(user.id, boardId);

      if (existEditRequest != null) {
        /// requestor
        return ViewPageUserTypes.requestedUser;
      } else {
        /// linked user
        return ViewPageUserTypes.linkedUser;
      }
    }

    /// visitor
    return ViewPageUserTypes.visitor;
  }

  Future<void> initialize(String boardId, double w, double h) async {
    final board =
        await ref.read(supabaseRepositoryProvider).getBoardById(boardId);

    /// streamをセット
    ref.read(streamBoardIdProvider.notifier).setStreamBoardId(boardId);

    final matrix = calcInitialTransform(board, w, h);

    final userType = await checkUserType(boardId);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      state = state.copyWith(
        transformationMatrix: matrix,
        userType: userType,
      );
    });
  }

  Future<void> addLinkedBoardId(String newBoardId) async {
    final user = ref.read(userStateProvider);
    if (user == null) {
      throw Exception('User is not loaded');
    }
    final userData = await ref
        .read(supabaseRepositoryProvider)
        .fetchUserData(user.id)
        .catchError((e) {
      print('error: $e');
      return null;
    });

    /// すでにlinkedBoardが存在するか確認
    if ((userData!.linkedBoardIds).contains(newBoardId)) {
      throw Exception('Exist linked board');
    }
    final newLinkedBoardIds = [...(userData.linkedBoardIds), newBoardId];
    ref
        .read(supabaseRepositoryProvider)
        .updateLinkedBoardIds(userData.userId, newLinkedBoardIds);

    state = state.copyWith(
      userType: ViewPageUserTypes.linkedUser,
    );
  }

  Future<void> sendEditRequest(String boardId) async {
    final user = ref.read(userStateProvider);
    if (user == null) {
      throw Exception('User is not loaded');
    }

    /// exist check
    try {
      final existEditRequest = await ref
          .read(supabaseRepositoryProvider)
          .fetchEditRequestForRequestor(user.id, boardId);
      if (existEditRequest != null) {
        throw AppException.exist();
      }
    } catch (e) {
      rethrow;
    }

    final board =
        await ref.read(supabaseRepositoryProvider).getBoardById(boardId);

    final newRequest = EditRequestModel(
      editRequestId: const Uuid().v4(),
      boardId: boardId,
      ownerId: board.ownerId,
      requestorId: user.id,
      createdAt: DateTime.now(),
    );
    await ref.read(supabaseRepositoryProvider).insertEditRequest(newRequest);
    state = state.copyWith(
      userType: ViewPageUserTypes.requestedUser,
    );
  }

  Future<void> cancelRequest(String boardId) async {
    final user = ref.read(userStateProvider);
    if (user == null) {
      throw Exception('User is not loaded');
    }
    final userData =
        await ref.read(supabaseRepositoryProvider).fetchUserData(user.id);
    if (userData == null) {
      throw Exception('User is not loaded');
    }

    final existEditRequest = await ref
        .read(supabaseRepositoryProvider)
        .fetchEditRequestForRequestor(user.id, boardId);
    if (existEditRequest == null) {
      throw AppException.notFound();
    }
    await ref
        .read(supabaseRepositoryProvider)
        .deleteEditRequest(existEditRequest.editRequestId);
    state = state.copyWith(userType: ViewPageUserTypes.linkedUser);
  }
}
