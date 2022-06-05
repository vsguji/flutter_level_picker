/*
 * @Author: qian suo
 * @Date: 2021-07-14 18:27:35
 * @LastEditTime: 2022-06-05 23:46:52
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /SRetailGoods/lib/src/common/bottom_city_picker_view/city_picker_model.dart
 */
import 'dart:convert';
import 'levels_base_model.dart';
import 'dart_helper.dart';

class CityRecursiveModel {
  late List<CityModel> records;

  factory CityRecursiveModel(jsonStr) => jsonStr is String
      ? CityRecursiveModel.fromJson(json.decode(jsonStr))
      : CityRecursiveModel.fromJson(jsonStr);

  CityRecursiveModel.fromParams();

  CityRecursiveModel.fromJson(jsonRes) {
    List items = jsonRes;
    records = [];
    for (var listItem in jsonRes ?? []) {
      records.add(CityModel.fromJson(listItem));
    }
  }

  // 逻辑值
  late List<CityModel> cacheItems;
  // 逻辑值
  late List<List<CityModel>> cachePageItems;

  int level() {
    int maxLevel = 1;
    int treeDeep(List<CityModel> items) {
      int currentLevel = 1;
      for (var item in items) {
        if (item.children != null) {
          currentLevel = 1 + treeDeep(item.children);
        }
      }
      return currentLevel;
    }

    for (var item in records) {
      int level = 1 + treeDeep(item.children);
      if (level > maxLevel) {
        maxLevel = level;
      }
    }
    print("== max tree level ==" + maxLevel.toString());
    return maxLevel;
  }

  List<CityModel> children(int index) {
    return records[index].children;
  }

  String getLabels(String level0, String level1, String level2) {
    List labels = [];
    cacheItems = [];
    cachePageItems = [];
    // 省
    CityModel item0 = records.firstWhere(
      (element) => element.areaCode.toString() == level0,
      orElse: () {
        return CityModel.fromParams();
      },
    );
    if (!DartHelper.isNullOrEmpty(item0.label)) {
      cachePageItems.add(records);
      labels.add(item0.label);
      cacheItems.add(item0);
      if (item0.children != null) {
        cachePageItems.add(item0.children);
      }
    }
    // 市
    CityModel item1 = item0.children.firstWhere(
      (element) => element.areaCode.toString() == level1,
      orElse: () {
        return CityModel.fromParams();
      },
    );
    if (!DartHelper.isNullOrEmpty(item1.label)) {
      labels.add(item1.label);
      cacheItems.add(item1);
      if (item1.children != null) {
        cachePageItems.add(item1.children);
      }
    }
    // 区
    CityModel item2 = item1.children.firstWhere(
      (element) => element.areaCode.toString() == level2,
      orElse: () {
        return CityModel.fromParams();
      },
    );
    if (!DartHelper.isNullOrEmpty(item2.label)) {
      labels.add(item2.label);
      cacheItems.add(item2);
      if (item2.children != null) {
        cachePageItems.add(item2.children);
      }
    }
    return labels.join("/");
  }

  void setSelected(String level0, String level1, String level2, bool status) {
    // 省
    CityModel item0 = records.firstWhere(
      (element) => element.areaCode.toString() == level0,
      orElse: () {
        return CityModel.fromParams();
      },
    );
    if (item0.getIsExsitLabel) {
      item0.setSelected(status);
    }
    // 市
    CityModel item1 = item0.children.firstWhere(
      (element) => element.areaCode.toString() == level1,
      orElse: () {
        return CityModel.fromParams();
      },
    );
    if (item1.getIsExsitLabel) {
      item1.setSelected(status);
    }
    // 区
    CityModel item2 = item1.children.firstWhere(
      (element) => element.areaCode.toString() == level2,
      orElse: () {
        return CityModel.fromParams();
      },
    );
    if (item2.getIsExsitLabel) {
      item2.setSelected(status);
    }
  }

  void resetAll() {
    cacheItems = [];
    void treeDeep(List<CityModel> items) {
      for (var item in items) {
        item.setSelected(false);
        if (item.children != null) {
          treeDeep(item.children);
        }
      }
    }

    for (var item in records) {
      item.setSelected(false);
      if (item.children != null) {
        treeDeep(item.children);
      }
    }
  }
}

class CityModel extends LevelsBaseModel {
  late String value;
  late String areaCode;
  late String parentId;
  late String label;
  late String center;
  late List<CityModel> children;

  // 逻辑
  bool _isSelected = false;

  factory CityModel(jsonStr) => jsonStr is String
      ? CityModel.fromJson(json.decode(jsonStr))
      : CityModel.fromJson(jsonStr);

  CityModel.fromParams(
      {this.value = '',
      this.areaCode = '',
      this.parentId = '',
      this.label = '',
      this.center = '',
      this.children = const []});

  CityModel.fromJson(jsonRes) {
    value = jsonRes["value"];
    areaCode = jsonRes["areaCode"];
    parentId = jsonRes["parentId"];
    label = jsonRes["label"];
    center = jsonRes["center"];
    List items = jsonRes["children"] ?? [];
    children = [];
    for (var listItem in items) {
      children.add(CityModel.fromJson(listItem));
    }
  }

  bool get getIsExsitLabel => !DartHelper.isNullOrEmpty(label);

  @override
  Object get extra => '';

  @override
  Object get itemId => areaCode;

  @override
  String get levelName => label;

  @override
  bool get selected => _isSelected;

  void setSelected(bool status) {
    _isSelected = status;
  }

  @override
  bool get isVisible => true;

  @override
  List get childrenItems => children;

  @override
  bool get hasChildren => children != null && children.isNotEmpty;
}
