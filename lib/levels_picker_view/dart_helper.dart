/*
 * @Author: your name
 * @Date: 2021-06-15 11:11:34
 * @LastEditTime: 2021-08-18 15:21:13
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /SRetailGoods/lib/src/utils/dart_check.dart
 */
class DartHelper {
  static bool isNullOrEmpty(String value) => value == '' || value == null;

  static bool isNullOrEmptyList(List value) => value == null || value.isEmpty;
}
