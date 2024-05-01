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
  EditPageState({
    this.selectedObject,
    this.boardModel,
  });
}

@Riverpod(keepAlive: true)
class EditPageViewModel extends _$EditPageViewModel {
  @override
  EditPageState build() => EditPageState();

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

  void selectObject(ObjectModel object) {
    state = EditPageState(
      selectedObject: object,
      boardModel: state.boardModel,
    );
  }

  void clearSelectedObject() {
    state = EditPageState(
      selectedObject: null,
      boardModel: state.boardModel,
    );
  }

  void setBoardModel(BoardModel board) {
    state = EditPageState(
      selectedObject: state.selectedObject,
      boardModel: board,
    );
  }

  void clearBoardModel() {
    state = EditPageState(
      selectedObject: state.selectedObject,
      boardModel: null,
    );
  }
}
