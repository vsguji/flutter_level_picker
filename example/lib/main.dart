/*
 * @Author: your name
 * @Date: 2022-06-05 23:30:36
 * @LastEditTime: 2022-06-06 08:28:27
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /flutter_levels_picker/example/lib/main.dart
 */
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_levels_picker/flutter_levels_picker.dart';
import 'package:flutter_levels_picker/levels_picker_view/levels_category_model.dart';
import 'package:flutter_levels_picker/levels_picker_view/levels_city_model.dart';
import 'package:flutter_levels_picker/levels_picker_view/levels_picker.dart';

void main() {
  runApp(const TestAPP());
}

class TestAPP extends StatelessWidget {
  const TestAPP({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: MyApp()),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _flutterLevelsPickerPlugin = FlutterLevelsPicker();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _flutterLevelsPickerPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(children: [
            Text('Running on: $_platformVersion\n'),
            Padding(padding: EdgeInsets.only(top: 100)),
            TextButton(
                onPressed: () async {
                  final _jsonStr = await DefaultAssetBundle.of(context)
                      .loadString('assets/area.json');
                  CityRecursiveModel cityModel = CityRecursiveModel(_jsonStr);

                  String belongId;
                  int id;
                  String image;
                  int isShow;
                  String name;
                  int parentId;
                  String parentIds;
                  int productCount;
                  int rank;
                  String tenantId;
                  List<LevelItemItem> children;

                  LevelItemItem items = LevelItemItem.fromParams(
                      belongId: '001',
                      id: 1,
                      isShow: 1,
                      name: '001',
                      children: [
                        LevelItemItem.fromParams(
                            belongId: '001',
                            id: 11,
                            isShow: 1,
                            name: '001',
                            parentIds: '1',
                            children: [
                              LevelItemItem.fromParams(
                                  belongId: '1001',
                                  id: 12,
                                  isShow: 1,
                                  name: '1001',
                                  parentIds: '1,11',
                                  children: [
                                    LevelItemItem.fromParams(
                                        belongId: '1101',
                                        id: 1,
                                        isShow: 1,
                                        name: '111',
                                        parentIds: '1,11,12'),
                                  ]),
                            ]),
                        LevelItemItem.fromParams(
                            belongId: '002',
                            id: 12,
                            isShow: 1,
                            name: '002',
                            parentIds: '1',
                            children: [
                              LevelItemItem.fromParams(
                                  belongId: '1002',
                                  id: 2,
                                  isShow: 1,
                                  name: '1002',
                                  parentIds: '1,12'),
                            ])
                      ]);

                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return LevelsPicker<CityModel>(
                          items: cityModel.records,
                          adapter: PickerAnyAdapter<CityModel>(
                              levelExtendsUI: ShowPickExtendsUI.extendsNone),
                          maxLevel: 3,
                          levelStepStype: ShowLevelType.showLevelOneByOne,
                          isCircleCorner: true,
                          title: Text('请选择所在地区'),
                          hideHeader: false,
                          hideFooter: false,
                          // builderHeader: (context) {
                          //   return Container(
                          //     color: Colors.black54,
                          //     height: 44,
                          //     child: ClipRRect(
                          //       borderRadius: BorderRadius.only(
                          //           topLeft: Radius.circular(16),
                          //           topRight: Radius.circular(16)),
                          //       child: Container(
                          //         color: Colors.white,
                          //         height: 44,
                          //       ),
                          //     ),
                          //   );
                          // },
                        );
                      });
                },
                child: Text('点击'))
          ]),
        ),
      ),
    );
  }
}
