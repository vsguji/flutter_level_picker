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

```

### 案例2

选择分类

<img src="https://github.com/vsguji/flutter_level_picker/blob/main/example/assets/category_one_picker.gif" width="320" height="480">


<img src="https://github.com/vsguji/flutter_level_picker/blob/main/example/assets/category_two_picker.gif" width="320" height="480">



<img src="https://github.com/vsguji/flutter_level_picker/blob/main/example/assets/category_three_picker.gif" width="320" height="480">

```

/// 展示方式
enum ShowLevelType {
  showLevelOneByOne, // 逐层显示
  showLevels, //< 显示要求层级,需设置maxLevel
}

/// 选择处理方式
enum ShowPickExtendsUI {
  extendsLabel, // 选择最末级,文字显示
  extendsIcon, // 选择任意级,图标
  extendsNone // 无
}

```

