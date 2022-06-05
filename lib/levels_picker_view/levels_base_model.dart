/*
 * @Author: your name
 * @Date: 2021-12-08 09:41:16
 * @LastEditTime: 2022-06-05 19:07:48
 * @LastEditors: your name
 * @Description: In User Settings Edit
 * @FilePath: /flutter_quick_views/lib/levels_picker_view/levels_base_model.dart
 */
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract class LevelsBaseModel {
  @mustCallSuper
  String get levelName => "";

  @mustCallSuper
  Object get itemId;

  @mustCallSuper
  String get parentsLevel => "";

  @mustCallSuper
  List get childrenItems;

  bool get isVisible => false;

  Object get extra;

  bool get selected;

  void setSelected(bool staus) {}

  String get itemUrl => "";

  int get count => 0;

  int get itemRank => 0;

  bool get hasChildren;
}
