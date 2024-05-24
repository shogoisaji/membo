import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:membo/models/board/board_model.dart';
import 'package:membo/models/board/object/object_model.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'edit_page_state.freezed.dart';

@freezed
class EditPageState with _$EditPageState {
  factory EditPageState({
    String? userId,
    ObjectModel? selectedObject,
    BoardModel? boardModel,
    @Default(0) int currentImageCount,
    XFile? selectedImageFile,
    @Default(false) bool showTextInput,
    @Default(false) bool showInputMenu,
    @Default(false) bool isOwner,
    Matrix4? transformationMatrix,
  }) = _EditPageState;
}
