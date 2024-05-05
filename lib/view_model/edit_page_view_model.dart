import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:membo/models/board/board_model.dart';
import 'package:membo/models/board/board_settings_model.dart';
import 'package:membo/models/board/object/object_model.dart';
import 'package:membo/models/view_model_state/edit_page_state.dart';
import 'package:membo/supabase/auth/supabase_auth_repository.dart';
import 'package:membo/supabase/db/supabase_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

part 'edit_page_view_model.g.dart';

// class EditPageState {
//   ObjectModel? selectedObject;
//   BoardModel? boardModel;
//   String? selectedBoardId;
//   double viewScale;
//   double viewTranslateX;
//   double viewTranslateY;
//   XFile? selectedImageFile;
//   bool showTextInput;
//   bool showInputMenu;

//   EditPageState({
//     this.selectedObject,
//     this.boardModel,
//     this.selectedBoardId,
//     this.viewScale = 1.0,
//     this.viewTranslateX = 0.0,
//     this.viewTranslateY = 0.0,
//     this.selectedImageFile,
//     this.showTextInput = false,
//     this.showInputMenu = false,
//   });

//   EditPageState copyWith({
//     ObjectModel? selectedObject,
//     BoardModel? boardModel,
//     String? selectedBoardId,
//     double? viewScale,
//     double? viewTranslateX,
//     double? viewTranslateY,
//     XFile? selectedImageFile,
//     bool? showTextInput,
//     bool? showInputMenu,
//   }) {
//     return EditPageState(
//       selectedObject: selectedObject ?? this.selectedObject,
//       boardModel: boardModel ?? this.boardModel,
//       selectedBoardId: selectedBoardId ?? this.selectedBoardId,
//       viewScale: viewScale ?? this.viewScale,
//       viewTranslateX: viewTranslateX ?? this.viewTranslateX,
//       viewTranslateY: viewTranslateY ?? this.viewTranslateY,
//       selectedImageFile: selectedImageFile ?? this.selectedImageFile,
//       showTextInput: showTextInput ?? this.showTextInput,
//       showInputMenu: showInputMenu ?? this.showInputMenu,
//     );
//   }
// }

@Riverpod(keepAlive: true)
class EditPageViewModel extends _$EditPageViewModel {
  @override
  EditPageState build() => EditPageState();

  void setSelectedBoardId(String boardId) {
    state = state.copyWith(selectedBoardId: boardId);
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
      return {
        'scale': scale,
        'translateX': translateX,
        'translateY': translateY,
      };
    }
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

    state = state.copyWith(boardModel: newBoard);
  }

  Future<void> initializeLoad(double w, double h) async {
    if (state.selectedBoardId == null) {
      await createNewBoard();
    } else {
      final board = await ref
          .read(supabaseRepositoryProvider)
          .getBoardById(state.selectedBoardId!);
      if (board == null) {
        throw Exception('Board not found');
      }
      final transformMap = calcInitialTransform(board, w, h);
      state = state.copyWith(
        selectedObject: null,
        boardModel: board,
        viewScale: transformMap['scale'] as double,
        viewTranslateX: transformMap['translateX'] as double,
        viewTranslateY: transformMap['translateY'] as double,
        showInputMenu: false,
        showTextInput: false,
      );
    }
  }

  void updateViewScale(double scale) {
    state = state.copyWith(viewScale: scale);
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
    state = state.copyWith(selectedObject: null);
  }

  void setBoardModel(BoardModel board) {
    state = state.copyWith(boardModel: board);
  }

  void insertSelectedObject() {
    if (state.selectedObject == null) {
      print('insertObject(): Object is null');
      return;
    }

    final board = state.boardModel;
    if (board == null) {
      throw Exception('Board is not set');
    }

    final objects = List<ObjectModel>.from(board.objects);
    objects.add(state.selectedObject!);
    final newBoard = board.copyWith(objects: objects);

    /// typeに合わせてrepositoryのメソッドを呼び出し、insert
    try {
      switch (state.selectedObject!.type) {
        case ObjectType.localImage:
          if (state.selectedImageFile == null) {
            throw Exception('addObject():selectedImageFile is null');
          }
          ref.read(supabaseRepositoryProvider).addImageObject(
              newBoard, state.selectedObject!, state.selectedImageFile!);
          break;
        case ObjectType.text:
          ref
              .read(supabaseRepositoryProvider)
              .addTextObject(newBoard, state.selectedObject!);
          break;
        default:
          break;
      }
    } catch (e) {
      print('Error updating board: $e');
    }

    clearSelectedObject();
  }

  // void insertSelectedObject() {
  //   if (state.selectedObject == null) {
  //     print('insertSelectedImageObject():selectedObject is null');
  //     return;
  //   }
  //   switch (state.selectedObject!.type) {
  //     case ObjectType.localImage:
  //       insertObject(state.selectedObject!, state.selectedImageFile);
  //       break;
  //     case ObjectType.text:
  //       insertObject(state.selectedObject!, null);
  //       break;
  //     default:
  //       break;
  //   }
  //   clearSelectedObject();
  // }

  // void addSelectedObject() {
  //   if (state.selectedObject == null) return;
  //   insertObject(state.selectedObject!, null);
  //   clearSelectedObject();
  // }

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
      return d;
    },
  );
}
