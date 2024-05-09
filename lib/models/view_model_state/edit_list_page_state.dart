import 'package:image_picker/image_picker.dart';
import 'package:membo/models/board/board_model.dart';
import 'package:membo/models/board/object/object_model.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'edit_list_page_state.freezed.dart';

@freezed
class EditListPageState with _$EditListPageState {
  factory EditListPageState({
    @Default([]) List<BoardModel> boardModels,
  }) = _EditListPageState;
}
