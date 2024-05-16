import 'package:flutter/material.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'board_view_page_state.freezed.dart';

enum ViewPageUserTypes { owner, editor, requestedUser, linkedUser, visitor }

@freezed
class BoardViewPageState with _$BoardViewPageState {
  factory BoardViewPageState({
    Matrix4? transformationMatrix,
    @Default(ViewPageUserTypes.visitor) ViewPageUserTypes userType,
  }) = _EditPageState;
}
