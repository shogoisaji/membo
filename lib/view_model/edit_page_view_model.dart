import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:membo/models/board/board_model.dart';
import 'package:membo/models/board/board_settings_model.dart';
import 'package:membo/models/board/object/object_model.dart';
import 'package:membo/models/view_model_state/edit_page_state.dart';
import 'package:membo/repositories/supabase/auth/supabase_auth_repository.dart';
import 'package:membo/repositories/supabase/db/supabase_repository.dart';
import 'package:membo/repositories/supabase/storage/supabase_storage.dart';
import 'package:membo/state/stream_board_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'edit_page_view_model.g.dart';

@riverpod
class EditPageViewModel extends _$EditPageViewModel {
  @override
  EditPageState build() => EditPageState();

  void setSelectedBoardId(String boardId) {
    state = state.copyWith(selectedBoardId: boardId);
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
    );

    await ref.read(supabaseRepositoryProvider).insertBoard(newBoard);

    state = state.copyWith(boardModel: newBoard);
  }

  Matrix4 calcInitialTransform(BoardModel board, double w, double h) {
    final scaleW = w / board.settings.width;
    final scaleH = h / board.settings.height;
    final scale = scaleW < scaleH ? scaleW : scaleH;

    /// 横長の画面の場合
    if (scaleW > scaleH) {
      final addX = (w - board.settings.width * scale) / 2 / scale;
      final translateX = (board.settings.width - w) / 2 * 1 + addX;
      final translateY = (board.settings.height - h) / 2 * 1;
      final matrix = Matrix4.identity()
        ..scale(scale)
        ..translate(translateX, translateY, 0);
      return matrix;

      /// 縦長の画面の場合
    } else {
      final addY = (h - board.settings.height * scale) / 2 / scale;
      final translateX = (board.settings.width - w) / 2 * 1;
      final translateY = (board.settings.height - h) / 2 * 1 + addY;
      final matrix = Matrix4.identity()
        ..scale(scale)
        ..translate(translateX, translateY, 0);
      return matrix;
    }
  }

  Future<void> initialize(String boardId, double w, double h) async {
    final board =
        await ref.read(supabaseRepositoryProvider).getBoardById(boardId);

    if (board == null) return;

    ref.read(streamBoardIdProvider.notifier).setStreamBoardId(boardId);

    final matrix = calcInitialTransform(board, w, h);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      state = state.copyWith(
        boardModel: board,
        transformationMatrix: matrix,
      );
    });
  }

  void selectObject(ObjectModel? object, XFile? file) {
    /// select object reset
    if (object == null) {
      state = state.copyWith(selectedObject: null);

      /// select image object
    } else if (object.type == ObjectType.localImage) {
      if (file == null) {
        throw Exception('selectObject() : selectedImageFile is null');
      }
      state = state.copyWith(
        selectedImageFile: file,
        selectedObject: object,
      );

      /// select text object
    } else if (object.type == ObjectType.text) {
      state = state.copyWith(selectedObject: object);
    }
    hideInputMenu();
  }

  void moveSelectedObject(Offset offset) {
    if (state.selectedObject == null) return;
    final movedObject = state.selectedObject!.copyWith(
      positionX: state.selectedObject!.positionX + offset.dx,
      positionY: state.selectedObject!.positionY + offset.dy,
    );
    state = state.copyWith(selectedObject: movedObject);
  }

  void scaleSelectedObject(double scale) {
    if (state.selectedObject == null) return;
    final scaledObject = state.selectedObject!.copyWith(scale: scale);
    state = state.copyWith(selectedObject: scaledObject);
  }

  void rotateSelectedObject(double angle) {
    if (state.selectedObject == null) return;
    final rotatedObject = state.selectedObject!.copyWith(angle: angle);
    state = state.copyWith(selectedObject: rotatedObject);
  }

  void clearSelectedObject() {
    state = state.copyWith(selectedObject: null, selectedImageFile: null);
  }

  void setBoardModel(BoardModel board) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      state = state.copyWith(boardModel: board);
    });
  }

  void insertSelectedObject() {
    if (state.selectedObject == null) {
      return;
    }

    final board = state.boardModel;
    if (board == null) {
      throw Exception('Board is not set');
    }

    /// typeに合わせてrepositoryのメソッドを呼び出し、insert
    try {
      switch (state.selectedObject!.type) {
        /// 画像の場合
        case ObjectType.localImage:
          if (state.selectedImageFile == null) {
            throw Exception('select local image is null');
          }
          ref.read(supabaseRepositoryProvider).addImageObject(
              board, state.selectedObject!, state.selectedImageFile!);

        /// テキストの場合
        case ObjectType.text:
          final currentObjects = List<ObjectModel>.from(board.objects);
          currentObjects.add(state.selectedObject!);
          final newBoard = board.copyWith(objects: currentObjects);
          ref
              .read(supabaseRepositoryProvider)
              .addTextObject(newBoard, state.selectedObject!);
        default:
      }
    } catch (e) {
      print('Error updating board: $e');
    }

    clearSelectedObject();
  }

  void clearBoardModel() {
    state = state.copyWith(boardModel: null);
  }

  void showInputMenu() {
    state = state.copyWith(showInputMenu: true);
  }

  void hideInputMenu() {
    state = state.copyWith(showInputMenu: false);
  }

  void showTextInput() {
    state = state.copyWith(showTextInput: true);
  }

  void hideTextInput() {
    state = state.copyWith(showTextInput: false);
  }

  void updateBoardSettings(BoardSettingsModel settings) {
    if (state.boardModel == null) {
      throw Exception('Board is not set');
    }
    state = state.copyWith(
        boardModel: state.boardModel!.copyWith(settings: settings));
    ref.read(supabaseRepositoryProvider).updateBoard(state.boardModel!);
  }

  Future<String> getObjectCreatorName(String id) async {
    try {
      final user = await ref.read(supabaseRepositoryProvider).fetchUserData(id);
      if (user == null) {
        return 'Unknown';
      }
      return user.userName;
    } catch (_) {
      return 'Unknown';
    }
  }

  Future<void> deleteObject(String objectId) async {
    if (state.boardModel == null) {
      throw Exception('Board is not set');
    }
    try {
      final deleteObject = state.boardModel!.objects
          .firstWhere((element) => element.objectId == objectId);
      if (deleteObject.type == ObjectType.networkImage) {
        final res = await ref
            .read(supabaseStorageProvider)
            .deleteImage(deleteObject.imageUrl!);
        if (!res) {
          throw Exception('Error delete image');
        }
      }
      final newObjects = state.boardModel!.objects
          .where((element) => element.objectId != objectId)
          .toList();
      final newBoard = state.boardModel!.copyWith(objects: newObjects);
      state = state.copyWith(boardModel: newBoard);
      ref.read(supabaseRepositoryProvider).updateBoard(newBoard);
    } catch (e) {
      throw Exception('Error delete: $e');
    }
  }
}
