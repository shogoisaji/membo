import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:membo/exceptions/app_exception.dart';
import 'package:membo/models/board/board_model.dart';
import 'package:membo/models/board/object/object_model.dart';
import 'package:membo/models/view_model_state/edit_page_state.dart';
import 'package:membo/repositories/supabase/auth/supabase_auth_repository.dart';
import 'package:membo/repositories/supabase/db/supabase_repository.dart';
import 'package:membo/repositories/supabase/storage/supabase_storage.dart';
import 'package:membo/state/stream_board_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'edit_page_view_model.g.dart';

@riverpod
class EditPageViewModel extends _$EditPageViewModel {
  @override
  EditPageState build() => EditPageState();

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

  int checkImageCount(BoardModel board) {
    final imageCount = board.objects
        .where((element) => element.type == ObjectType.networkImage)
        .length;
    return imageCount;
  }

  void updateImageCount() {
    final imageCount = state.boardModel!.objects
        .where((element) => element.type == ObjectType.networkImage)
        .length;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      state = state.copyWith(currentImageCount: imageCount);
    });
  }

  Future<void> initialize(String boardId, double w, double h) async {
    final board =
        await ref.read(supabaseRepositoryProvider).getBoardById(boardId);

    ref.read(streamBoardIdProvider.notifier).setStreamBoardId(boardId);

    final imageCount = checkImageCount(board);

    final matrix = calcInitialTransform(board, w, h);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      state = state.copyWith(
        boardModel: board,
        currentImageCount: imageCount,
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

    /// out range check

    /// 左端の場合
    if (movedObject.positionX < -state.boardModel!.width / 2) return;

    /// 右端の場合
    if (movedObject.positionX > state.boardModel!.width / 2) return;

    /// 上端の場合
    if (movedObject.positionY < -state.boardModel!.height / 2) return;

    /// 下端の場合
    if (movedObject.positionY > state.boardModel!.height / 2) return;

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

  /// stream の board を state にセット
  void setBoardModel(BoardModel board) {
    /// 画像の数をカウント
    final imageCount = board.objects
        .where((element) => element.type == ObjectType.networkImage)
        .length;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      state = state.copyWith(boardModel: board, currentImageCount: imageCount);
    });
  }

  Future<void> saveSelectedObject() async {
    if (state.selectedObject == null) {
      return;
    }

    final board = state.boardModel;
    if (board == null) {
      throw Exception('Board is not set');
    }

    /// typeに合わせてrepositoryのメソッドを呼び出し、insert
    try {
      /// 権限をチェック
      final user = ref.read(userStateProvider);
      if (user == null) {
        throw Exception('User is not signed in');
      }

      ///　所有者、または編集権限を持っているユーザーのみ書き込み可能
      if (!board.editableUserIds.contains(user.id) &&
          board.ownerId != user.id) {
        throw AppException.error('書き込み権限がありません');
      }

      switch (state.selectedObject!.type) {
        /// 画像の場合
        case ObjectType.localImage:
          if (state.selectedImageFile == null) {
            throw AppException.error('select local image is null');
          }

          /// 画像枚数のチェック
          if (state.currentImageCount >= state.boardModel!.maxImageCount) {
            throw AppException.error('画像の枚数上限です');
          }
          await ref.read(supabaseRepositoryProvider).addImageObject(
              board, state.selectedObject!, state.selectedImageFile!);

        /// テキストの場合
        case ObjectType.text:
          final currentObjects = List<ObjectModel>.from(board.objects);
          currentObjects.add(state.selectedObject!);

          final newBoard = board.copyWith(objects: currentObjects);

          await ref.read(supabaseRepositoryProvider).updateBoard(newBoard);
        default:
      }
    } catch (e) {
      clearSelectedObject();
      rethrow;
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

  // void updateBoardSettings(BoardSettingsModel settings) {
  //   if (state.boardModel == null) {
  //     throw Exception('Board is not set');
  //   }
  //   state = state.copyWith(
  //       boardModel: state.boardModel!.copyWith(settings: settings));
  //   ref.read(supabaseRepositoryProvider).updateBoard(state.boardModel!);
  // }

  Future<String> getObjectCreatorName(String id) async {
    try {
      final user = await ref
          .read(supabaseRepositoryProvider)
          .fetchUserData(id)
          .catchError((e) {
        print('error: $e');
        return null;
      });
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
        await ref
            .read(supabaseStorageProvider)
            .deleteObjectImage(deleteObject.imageUrl!);
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
