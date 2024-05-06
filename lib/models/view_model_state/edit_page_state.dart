import 'package:image_picker/image_picker.dart';
import 'package:membo/models/board/board_model.dart';
import 'package:membo/models/board/object/object_model.dart';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:membo/models/board/board_model.dart';
import 'package:membo/models/board/object/object_model.dart';

part 'edit_page_state.freezed.dart';

@freezed
class EditPageState with _$EditPageState {
  factory EditPageState({
    ObjectModel? selectedObject,
    BoardModel? boardModel,
    String? selectedBoardId,
    @Default(1.0) double viewScale,
    @Default(0.0) double viewTranslateX,
    @Default(0.0) double viewTranslateY,
    XFile? selectedImageFile,
    @Default(false) bool showTextInput,
    @Default(false) bool showInputMenu,
  }) = _EditPageState;
}
