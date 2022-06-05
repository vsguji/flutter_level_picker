/*
 * @Author: your name
 * @Date: 2021-07-26 10:12:21
 * @LastEditTime: 2022-06-05 22:21:52
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /SRetailGoods/lib/src/common/bottom_levels_picker_view/levels_category_model.dart
 */

import 'dart:convert';

import 'levels_base_model.dart';

class LevelItemItem extends LevelsBaseModel {
  late String belongId;
  late int id;
  late String image;
  late int isShow;
  late String name;
  late int parentId;
  late String parentIds;
  late int productCount;
  late int rank;
  late String tenantId;
  late List<LevelItemItem> children;

  // 逻辑值
  bool _isSelected = false;

  LevelItemItem.fromParams(
      {this.belongId = '',
      this.id = 0,
      this.isShow = 0,
      this.name = '',
      this.parentId = 0,
      this.parentIds = '',
      this.productCount = 0,
      this.image = '',
      this.rank = 0,
      this.tenantId = '',
      this.children = const []});

  factory LevelItemItem(jsonStr) => jsonStr is String
      ? LevelItemItem.fromJson(json.decode(jsonStr))
      : LevelItemItem.fromJson(jsonStr);

  LevelItemItem.fromJson(json) {
    belongId = json["belongId"].toString();
    id = json["id"];
    image = json["image"];
    isShow = json["isShow"];
    name = json["name"];
    parentId = json["parentId"];
    parentIds = json["parentIds"];
    productCount = json["productCount"];
    rank = json["rank"];
    tenantId = json["tenantId"];
    children = json["children"] ?? [];

    for (var listItem in json["children"] ?? []) {
      children.add(LevelItemItem.fromJson(listItem));
    }
  }

  bool get getIsShow => isShow == 1;

  // 存在子分类
  bool get getHasChildren => children != null && children.isNotEmpty;
  // 商品数量不为0,分类正在使用
  bool get getIsUsing => productCount > 0;

  String get warning01 => "分类下存在子级分类,当前分类不可删除";

  String get warning02 => "分类正在使用中";

  @override
  String toString() {
    return '{"belongId":$belongId,"id":$id,"image":$image,"isShow":$isShow,"name":$name,"parentId":$parentId,"parentIds":$parentIds,"productCount":$productCount,"rank":$rank,"tenantId":$tenantId}';
  }

  @override
  String get levelName => name;
  @override
  Object get itemId => id;

  @override
  bool get isVisible => isShow == 1;

  @override
  List get childrenItems => children;

  @override
  Object get extra => '';

  @override
  Object fromBaseParams() => LevelItemItem.fromParams();

  @override
  bool get selected => _isSelected;

  void setSelected(bool status) {
    _isSelected = status;
  }

  String get itemUrl => image;

  int get count => productCount;

  int get itemRank => rank;

  @override
  bool get hasChildren => children != null && children.isNotEmpty;

  @override
  String get parentsLevel => parentIds;
}
