import 'package:flutter/material.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'board_view_page_state.freezed.dart';

@freezed
class BoardViewPageState with _$BoardViewPageState {
  factory BoardViewPageState({
    Matrix4? transformationMatrix,
    @Default(true) bool isLinked,
  }) = _EditPageState;
}
