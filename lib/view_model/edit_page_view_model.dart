import 'package:flutter/material.dart';
import 'package:membo/models/board/board_model.dart';
import 'package:membo/models/board/board_settings_model.dart';
import 'package:membo/models/board/object/object_model.dart';
import 'package:membo/supabase/auth/supabase_auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

part 'edit_page_view_model.g.dart';

class EditPageState {
  ObjectModel? selectedObject;
  BoardModel? boardModel;
  double viewScale;
  double viewTranslateX;
  double viewTranslateY;

  EditPageState({
    this.selectedObject,
    this.boardModel,
    this.viewScale = 1.0,
    this.viewTranslateX = 0.0,
    this.viewTranslateY = 0.0,
  });
}

@Riverpod(keepAlive: true)
class EditPageViewModel extends _$EditPageViewModel {
  @override
  EditPageState build() => EditPageState();

  Future<void> initializeLoad() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      createNewBoard();

      ///
      /// Test data
      ///
      // final testObject = ObjectModel(
      //     objectId: '1',
      //     type: ObjectType.localImage,
      //     positionX: 130,
      //     positionY: 1050,
      //     angle: 0.3,
      //     scale: 0.5,
      //     creatorId: '1',
      //     createdAt: DateTime.now(),
      //     bgColor: '0xFF000000');
      // addObject(testObject);
      final testObject2 = ObjectModel(
          objectId: '2',
          type: ObjectType.text,
          positionX: 900,
          positionY: 350,
          angle: -0.2,
          scale: 18.1,
          text: 'Hello',
          creatorId: '1',
          createdAt: DateTime.now(),
          bgColor: '0xFF000000');
      addObject(testObject2);
    });
    await Future.delayed(const Duration(seconds: 1), () {});
  }

  void createNewBoard() {
    /// Get the current user
    final User? user = ref.read(userStateProvider);
    if (user == null) {
      throw Exception('User is not signed in');
    }

    state = EditPageState(
      selectedObject: null,
      boardModel: BoardModel(
        boardId: const Uuid().v4(),
        password: '',
        objects: [],
        ownerId: user.id,
        settings: const BoardSettingsModel(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
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
    state = EditPageState(
      selectedObject: state.selectedObject,
      boardModel: newBoard,
      viewScale: state.viewScale,
      viewTranslateX: state.viewTranslateX,
      viewTranslateY: state.viewTranslateY,
    );
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
