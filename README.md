# flutter_levels_picker

适用于ios，android插件

## 开始

这个项目是一个
[插件包](https://flutter.dev/developing-packages/),
的特定平台实现代码的专用包
Android和iOS。

要获得关于插件包开发的帮助，请查看
[在线文档](https://flutter.dev/docs)，提供教程，
示例，移动开发指南，以及完整的API参考。



### 案例1

省、市、区选择，json字符串倒入 

<img src="https://github.com/vsguji/flutter_level_picker/blob/main/example/assets/city_levels_picker.gif" width="320" height="480">

```
 final _jsonStr = await DefaultAssetBundle.of(context)
                      .loadString('assets/area.json');
 CityRecursiveModel cityModel = CityRecursiveModel(_jsonStr);

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

```

### 案例2

选择分类


```

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


```

