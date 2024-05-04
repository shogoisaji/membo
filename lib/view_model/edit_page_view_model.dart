import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:membo/models/board/board_model.dart';
import 'package:membo/models/board/board_settings_model.dart';
import 'package:membo/models/board/object/object_model.dart';
import 'package:membo/supabase/auth/supabase_auth_repository.dart';
import 'package:membo/supabase/db/supabase_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

part 'edit_page_view_model.g.dart';

class EditPageState {
  ObjectModel? selectedObject;
  BoardModel? boardModel;
  String? selectedBoardId;
  double viewScale;
  double viewTranslateX;
  double viewTranslateY;

  EditPageState({
    this.selectedObject,
    this.boardModel,
    this.selectedBoardId,
    this.viewScale = 1.0,
    this.viewTranslateX = 0.0,
    this.viewTranslateY = 0.0,
  });
}

@Riverpod(keepAlive: true)
class EditPageViewModel extends _$EditPageViewModel {
  @override
  EditPageState build() => EditPageState();

  void setSelectedBoardId(String boardId) {
    state = EditPageState(
      selectedObject: state.selectedObject,
      boardModel: state.boardModel,
      selectedBoardId: boardId,
    );
  }

  Map<String, double> calcInitialTransform(
      BoardModel board, double w, double h) {
    final scaleW = w / board.settings.width;
    final scaleH = (h - kToolbarHeight) / board.settings.height;
    final scale = scaleW < scaleH ? scaleW : scaleH;

    /// 横長の画面の場合
    if (scaleW > scaleH) {
      final addX = (w - board.settings.width * scale) / 2;
      final translateX = (board.settings.width - w) / 2 * scale + addX;
      final translateY = (board.settings.height - h) / 2 * scale;
      // state = EditPageState(
      //   selectedObject: state.selectedObject,
      //   boardModel: state.boardModel,
      //   viewScale: scale,
      //   viewTranslateX: translateX,
      //   viewTranslateY: translateY,
      // );
      return {
        'scale': scale,
        'translateX': translateX,
        'translateY': translateY,
      };

      /// 縦長の画面の場合
    } else {
      final addY = (h - board.settings.height * scale) / 2;
      final translateX = (board.settings.width - w) / 2 * scale;
      final translateY = (board.settings.height - h) / 2 * scale + addY;
      // state = EditPageState(
      //   selectedObject: state.selectedObject,
      //   boardModel: state.boardModel,
      //   viewScale: scale,
      //   viewTranslateX: translateX,
      //   viewTranslateY: translateY,
      // );
      return {
        'scale': scale,
        'translateX': translateX,
        'translateY': translateY,
      };
    }
  }

  Future<void> initializeLoad(double w, double h) async {
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    if (state.selectedBoardId == null) {
      await createNewBoard();
    } else {
      final board = await ref
          .read(supabaseRepositoryProvider)
          .getBoardById(state.selectedBoardId!);
      final transformMap = calcInitialTransform(board!, w, h);
      state = EditPageState(
        selectedObject: null,
        boardModel: board,
        viewScale: transformMap['scale'] as double,
        viewTranslateX: transformMap['translateX'] as double,
        viewTranslateY: transformMap['translateY'] as double,
      );
    }

    // });
    await Future.delayed(const Duration(seconds: 1), () {});
  }

  Future<void> createNewBoard() async {
    /// Get the current user
    final User? user = ref.read(userStateProvider);
    if (user == null) {
      throw Exception('User is not signed in');
    }
    final newBoard = BoardModel(
      boardId: const Uuid().v4(),
      password: '',
      objects: [],
      ownerId: user.id,
      settings: const BoardSettingsModel(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await ref.read(supabaseRepositoryProvider).insertBoard(newBoard);

    state = EditPageState(
      selectedObject: null,
      boardModel: newBoard,
    );
  }

  void updateViewScale(double scale) {
    state = EditPageState(
      selectedObject: state.selectedObject,
      boardModel: state.boardModel,
      viewScale: scale,
      viewTranslateX: state.viewTranslateX,
      viewTranslateY: state.viewTranslateY,
    );
  }

  void selectObject(ObjectModel? object) {
    state = EditPageState(
      selectedObject: object,
      boardModel: state.boardModel,
    );
  }

  void moveSelectedObject(Offset offset) {
    if (state.selectedObject == null) return;
    final movedObject = state.selectedObject!.copyWith(
      positionX: state.selectedObject!.positionX + offset.dx,
      positionY: state.selectedObject!.positionY + offset.dy,
    );
    state = EditPageState(
      selectedObject: movedObject,
      boardModel: state.boardModel,
      viewScale: state.viewScale,
      viewTranslateX: state.viewTranslateX,
      viewTranslateY: state.viewTranslateY,
    );
  }

  void scaleSelectedObject(double scale) {
    if (state.selectedObject == null) return;
    final scaledObject = state.selectedObject!.copyWith(scale: scale);
    state = EditPageState(
      selectedObject: scaledObject,
      boardModel: state.boardModel,
      viewScale: state.viewScale,
      viewTranslateX: state.viewTranslateX,
      viewTranslateY: state.viewTranslateY,
    );
  }

  void rotateSelectedObject(double angle) {
    if (state.selectedObject == null) return;
    final rotatedObject = state.selectedObject!.copyWith(angle: angle);
    state = EditPageState(
      selectedObject: rotatedObject,
      boardModel: state.boardModel,
      viewScale: state.viewScale,
      viewTranslateX: state.viewTranslateX,
      viewTranslateY: state.viewTranslateY,
    );
  }

  void clearSelectedObject() {
    state = EditPageState(
      selectedObject: null,
      boardModel: state.boardModel,
      viewScale: state.viewScale,
      viewTranslateX: state.viewTranslateX,
      viewTranslateY: state.viewTranslateY,
    );
  }

  void setBoardModel(BoardModel board) {
    state = EditPageState(
      selectedObject: state.selectedObject,
      boardModel: board,
      viewScale: state.viewScale,
      viewTranslateX: state.viewTranslateX,
      viewTranslateY: state.viewTranslateY,
    );
  }

  void addObject(ObjectModel object) {
    final board = state.boardModel;
    if (board == null) {
      throw Exception('Board is not set');
    }
    final objects = List<ObjectModel>.from(board.objects);
    objects.add(object);
    final newBoard = board.copyWith(objects: objects);

    /// repository update
    try {
      ref.read(supabaseRepositoryProvider).updateBoard(board.boardId, newBoard);
    } catch (e) {
      print('Error updating board: $e');
    }

    // state = EditPageState(
    //   selectedObject: state.selectedObject,
    //   boardModel: newBoard,
    //   viewScale: state.viewScale,
    //   viewTranslateX: state.viewTranslateX,
    //   viewTranslateY: state.viewTranslateY,
    // );
  }

  void addSelectedObject() {
    if (state.selectedObject == null) return;
    addObject(state.selectedObject!);
    clearSelectedObject();
  }

  void clearBoardModel() {
    state = EditPageState(
      selectedObject: state.selectedObject,
      boardModel: null,
      viewScale: state.viewScale,
      viewTranslateX: state.viewTranslateX,
      viewTranslateY: state.viewTranslateY,
    );
  }
}

@Riverpod(keepAlive: true)
Stream<BoardModel?> boardStream(BoardStreamRef ref) {
  // final boardId = '0996ec38-d300-4dd4-9e8b-1a887954c275';
  final boardId = ref.read(editPageViewModelProvider).selectedBoardId;
  if (boardId == null) {
    return Stream.value(null);
  }
  return ref.watch(supabaseRepositoryProvider).boardStream(boardId);
}

@Riverpod(keepAlive: true)
BoardModel? boardModelState(BoardModelStateRef ref) {
  final boardStream = ref.watch(boardStreamProvider);
  return boardStream.when(
    loading: () {
      return null;
    },
    error: (e, __) {
      return null;
    },
    data: (d) {
      print('----------boardModelState: $d');
      return d;
    },
  );
}
