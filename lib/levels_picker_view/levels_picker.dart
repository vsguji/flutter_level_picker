/*
 * @Author: qian suo
 * @Date: 2021-07-14 14:52:55
 * @LastEditTime: 2022-06-06 09:44:39
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /SRetailGoods/lib/src/common/bottom_city_picker_view/city_picker.dart
 */
import 'package:flutter/material.dart';
import 'levels_base_model.dart';
import 'style.dart';

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

typedef PickerSelectedCallback = void Function(
    LevelsPicker picker, int index, List<dynamic> selected);

typedef PickerConfirmCallback = void Function(
    LevelsPicker picker, List<dynamic> selected);

typedef PickerConfirmBeforeCallback = Future<bool> Function(
    LevelsPicker picker, List<dynamic> selected);

class LevelsPicker<T extends LevelsBaseModel> extends StatefulWidget {
  LevelsPicker(
      {Key? key,
      this.items = const [],
      this.height = 320,
      this.headerHeight = 48,
      this.sectionHeight = 44,
      this.pageHeight = 200,
      this.levelStepStype = ShowLevelType.showLevels,
      this.levelExtendsUI = ShowPickExtendsUI.extendsNone,
      this.maxLevel = 0,
      this.callBack,
      this.warningCallBack,
      this.warningStr = '',
      this.editStatus = false,
      this.cacheItems = const [],
      this.cachePageItems = const [],
      this.isAutoClose = true,
      this.builderHeader,
      this.hideHeader = false,
      this.headerDecoration,
      this.title,
      this.cancel,
      this.cancelText = '',
      this.cancelTextStyle,
      this.confirm,
      this.confirmText = '',
      this.confirmTextStyle,
      this.headerColor,
      this.itemExtent = 0.0,
      this.textStyle,
      this.selectedTextStyle,
      this.onCancel,
      this.onConfirm,
      this.onConfirmBefore,
      this.onSelect,
      this.builderFooter,
      this.hideFooter = true,
      this.isCircleCorner = false,
      required this.adapter})
      : super(key: key);
  //
  final List<T> items;
  //
  final double height;
  //
  final double headerHeight;
  //
  final double sectionHeight;
  //
  final double pageHeight;
  // 逐级,展示方式
  final ShowLevelType levelStepStype;
  // 逐级扩展UI,展示方式
  final ShowPickExtendsUI levelExtendsUI;
  //
  final int maxLevel;
  //
  final ValueChanged? callBack;
  //
  final VoidCallback? warningCallBack;
  //
  final String warningStr;
  //
  final bool editStatus;
  //
  final List<T> cacheItems;
  //
  final List<List<T>> cachePageItems;
  // 是否末级选完后,0.3s后自动关闭
  final bool isAutoClose;
  // 顶部
  final WidgetBuilder? builderHeader;
  //
  final bool hideHeader;
  //
  final Decoration? headerDecoration;
  //
  final Color? headerColor;

  final Widget? title;
  //
  final Widget? cancel;
  //
  final Widget? confirm;
  //
  final String cancelText;
  //
  final String confirmText;

  /// Height of list item
  final double itemExtent;
  //
  final TextStyle? textStyle,
      cancelTextStyle,
      confirmTextStyle,
      selectedTextStyle;

  final VoidCallback? onCancel;
  final PickerSelectedCallback? onSelect;
  final PickerConfirmCallback? onConfirm;
  final PickerConfirmBeforeCallback? onConfirmBefore;

  // 底部
  final Widget? builderFooter;
  //
  final bool hideFooter;

  final bool isCircleCorner;

  final PickerLevelAdapter<T> adapter;

  @override
  _CityPickerState<T> createState() => _CityPickerState<T>();
}

class _CityPickerState<T extends LevelsBaseModel> extends State<LevelsPicker<T>>
    with TickerProviderStateMixin {
  static const double DefaultTextSize = 20.0;
  // 标题
  late List _sectionItems;
  // 导航
  late TabController _tabController;
  // 翻页
  late PageController _pageController;
  // 已选缓存
  List<dynamic> _cacheSelectedItem = [];
  // 已选层级
  List<dynamic> _cachItemId = [];
  // 翻页数据
  List<List<dynamic>> _pageItems = [];
  //
  late ThemeData theme;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    switch (widget.levelStepStype) {
      case ShowLevelType.showLevelOneByOne:
        // 非编辑状态
        _noEditDefaultDataSourceWithOutMax();
        break;
      case ShowLevelType.showLevels:
        _noEditDefaultDataSource();
        break;
      default:
    }
    // 编辑状态
    _editDefaultDataSource();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _pageController.dispose();
  }

  /// @description: 更新标题,控制器
  /// @param {length:标题数组长度}
  /// @return {*}
  void refreshTabController(int length, int index) {
    _tabController = TabController(
      initialIndex: index,
      length: length,
      vsync: this,
    );
  }

  void _translateToPageByIndex(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _refreshPageByIndex(int index) {
    _pageController = PageController(initialPage: index);
  }

  void _translateForTabByIndex(int index) {
    _tabController.animateTo(index,
        duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
  }

  void _translateForPageWithOutAnimationByIndex(int index) {
    _tabController.animateTo(index,
        duration: const Duration(milliseconds: 0), curve: Curves.easeInOut);
  }

  void _close() {
    if (widget.callBack != null && _cacheSelectedItem != null) {
      widget.callBack!(_cacheSelectedItem);
    }
    Navigator.of(context).pop();
  }

  void _refreshPageDataSource(int index, {List? children}) {
    if (children != null) {
      _pageItems[index] = children;
    } else {
      // int tag = index - 1;
      // if (tag < 0) {
      //   tag = 0;
      // }
      // LevelsBaseModel model = _cacheSelectedItem[tag];
      // if (model.selected) {
      //   List<T> items = model.childrenItems;
      //   _pageItems[index] = items;
      // }
    }
    //  setState(() {});
  }

  void _refreshSectionTitle(int index, String item) {
    _sectionItems[index] = item;
  }

  /// @description: 设置级别标题
  /// @param {*}
  /// @return {*}
  void _resetSectionTitles() {
    _sectionItems = [];
    for (var i = 0; i < _pageItems.length; i++) {
      _sectionTitleAppendItem();
    }
  }

  /// @description: 追加标题
  /// @param {*}
  /// @return {*}
  void _sectionTitleAppendItem() {
    if (_sectionItems != null) {
      _sectionItems.add("请选择");
    }
  }

  // 检查是否可切换
  bool _checkIsCanToPage(int index) {
    if (_cacheSelectedItem.isEmpty || _cacheSelectedItem.length <= index) {
      return false;
    }
    bool nextPage = true;
    dynamic item = _cacheSelectedItem[index];
    if (item is String) {
      // nextPage = false;
    }
    return nextPage;
  }

  // 非编辑状态(携带最大级别)
  void _noEditDefaultDataSource() {
    _cachItemId = [];
    if (!widget.editStatus) {
      // 预初始化页面数据
      _pageItems = [];
      for (var i = 0; i < widget.maxLevel; i++) {
        _pageItems.add(List<dynamic>.empty());
      }
      // 预初始化选中缓存
      _cacheSelectedItem = [];
      // for (var i = 0; i < widget.maxLevel; i++) {
      //   _cacheSelectedItem.add([]);
      // }
      // 根
      _pageItems[0] = widget.items;
      // 预先初始化标题
      _resetSectionTitles();
      // 设置顶部菜单
      refreshTabController(_pageItems.length, 0);
    }
  }

  // 非编辑状态(无最大级别)
  void _noEditDefaultDataSourceWithOutMax() {
    if (!widget.editStatus) {
      // 预初始化页面数据
      _pageItems = [[]];
      // 一级菜单
      _pageItems[0] = widget.items;
      // 预先初始化标题
      _resetSectionTitles();
      // 设置顶部菜单
      refreshTabController(_pageItems.length, 0);
    }
  }

  // 编辑状态
  void _editDefaultDataSource() {
    if (widget.editStatus) {
      // 预初始化标题控制器
      refreshTabController(widget.maxLevel, 0);
      // 预初始化页面数据
      _pageItems = widget.cachePageItems;
      _cacheSelectedItem = widget.cacheItems;
      // 预初始化标题
      _sectionItems = [];
      for (var cacheItem in _cacheSelectedItem) {
        _sectionItems.add(cacheItem.levelName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    final _body = <Widget>[];
    // 头部布局
    if (!widget.hideHeader) {
      if (widget.builderHeader != null) {
        // 圆角
        if (widget.isCircleCorner) {
          _body.add(getCircleCorner(widget.headerDecoration == null
              ? widget.builderHeader!(context)
              : DecoratedBox(
                  child: widget.builderHeader!(context),
                  decoration: widget.headerDecoration!)));
        } else {
          _body.add(widget.headerDecoration == null
              ? widget.builderHeader!(context)
              : DecoratedBox(
                  child: widget.builderHeader!(context),
                  decoration: widget.headerDecoration!));
        }
      } else {
        // 圆角
        if (widget.isCircleCorner) {
          _body.add(getCircleCorner(Row(
            children: _buildHeaderViews(context),
          )));
        } else {
          _body.add(DecoratedBox(
            child: Row(
              children: _buildHeaderViews(context),
            ),
            decoration: widget.headerDecoration ??
                BoxDecoration(
                  border: Border(
                    top: BorderSide(color: theme.dividerColor, width: 0.5),
                    bottom: BorderSide(color: theme.dividerColor, width: 0.5),
                  ),
                  color: widget.headerColor == null
                      ? (theme.bottomAppBarColor)
                      : widget.headerColor,
                ),
          ));
        }
      }
    }
    //
    _body.add(_buildHeaderTabBar());
    //
    _body.add(_buildPageView());
    // 底部
    if (!widget.hideFooter) {
      if (widget.builderFooter != null) {
        _body.add(widget.builderFooter!);
      } else {
        _body.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.only(left: 8)),
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16), color: Colors.blue),
              child: TextButton(
                  onPressed: () {},
                  child: Text(
                    '确定',
                    style: TextStyle(
                        color: Colors.white, fontSize: DefaultTextSize),
                  )),
            )),
            Padding(padding: EdgeInsets.only(right: 8)),
          ],
        ));
      }
    }

    return Container(
      height: widget.height + (widget.hideHeader ? 0 : 30),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: _body,
      ),
    );
  }

  List<Widget>? _headerItems;
  List<Widget> _buildHeaderViews(BuildContext context) {
    if (_headerItems != null) return _headerItems!;
    if (theme == null) theme = Theme.of(context);
    List<Widget> items = [];

    if (widget.cancel != null) {
      items.add(DefaultTextStyle(
          style: widget.cancelTextStyle ??
              theme.textTheme.button!.copyWith(
                  color: theme.colorScheme.secondary,
                  fontSize: DefaultTextSize),
          child: widget.cancel!));
    } else {
      String _cancelText = '取消';
      // picker.cancelText ?? PickerLocalizations.of(context).cancelText;
      if (_cancelText != null || _cancelText != "") {
        items.add(_buildHeaderButton(context,
            text: _cancelText,
            style: widget.cancelTextStyle ??
                theme.textTheme.button!.copyWith(
                    color: theme.colorScheme.secondary,
                    fontSize: DefaultTextSize), onPressed: () {
          doCancel(context);
        }));
      }
    }

    items.add(Expanded(
        child: Center(
      child: widget.title == null
          ? widget.title
          : DefaultTextStyle(
              style: theme.textTheme.headline6!.copyWith(
                fontSize: DefaultTextSize,
              ),
              child: widget.title!),
    )));

    if (widget.confirm != null) {
      items.add(DefaultTextStyle(
          style: widget.confirmTextStyle ??
              theme.textTheme.button!.copyWith(
                  color: theme.colorScheme.secondary,
                  fontSize: DefaultTextSize),
          child: widget.confirm!));
    } else {
      String _confirmText = '确定';
      // picker.confirmText ?? PickerLocalizations.of(context).confirmText;
      if (_confirmText != null || _confirmText != "") {
        items.add(_buildHeaderButton(context,
            text: _confirmText,
            style: widget.confirmTextStyle ??
                theme.textTheme.button!.copyWith(
                    color: theme.colorScheme.secondary,
                    fontSize: DefaultTextSize), onPressed: () {
          doConfirm(context);
        }));
      }
    }

    _headerItems = items;
    return items;
  }

  Widget _buildHeaderButton(BuildContext context,
      {required String text,
      required VoidCallback onPressed,
      TextStyle? style}) {
    return TextButton(
        style: _getButtonStyle(ButtonTheme.of(context)),
        onPressed: onPressed,
        child: Text(text,
            overflow: TextOverflow.ellipsis,
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            style: style ??
                theme.textTheme.button!.copyWith(
                    color: theme.colorScheme.secondary,
                    fontSize: DefaultTextSize)));
  }

  Widget _buildHeaderTabBar() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 0.0,
      ),
      height: widget.sectionHeight,
      child: TabBar(
        isScrollable: true,
        indicatorColor: kAppBarColor,
        indicatorSize: TabBarIndicatorSize.label,
        controller: _tabController,
        tabs: [
          for (var item in _sectionItems)
            Text(
              item,
              style: TextStyle(color: Colors.black),
            ),
        ],
        onTap: (value) {
          switch (widget.levelStepStype) {
            case ShowLevelType.showLevelOneByOne:
              // 底部翻页
              _translateToPageByIndex(value);
              break;
            case ShowLevelType.showLevels:
              {
                // 当前页面,检查是否有选中项目
                if (_checkIsCanToPage(value)) {
                  // 初始化下一页数据
                  _refreshPageDataSource(value);
                  // 页面转化动画
                  _translateToPageByIndex(value);
                }
              }
              break;
            default:
          }
        },
      ),
    );
  }

  Widget _buildPageView() {
    return Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: widget.pageHeight),
        child: PageView(
            controller: _pageController,
            children: [
              for (var i = 0; i < _pageItems.length; i++)
                ListView.separated(
                  cacheExtent: 30,
                  shrinkWrap: true,
                  itemCount: _pageItems[i].length,
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(),
                  itemBuilder: (BuildContext context, int index) {
                    T item = _pageItems[i][index];
                    Widget itemWidget =
                        widget.adapter.buildItem(context, index, item);
                    widget.adapter.callBack = (model, adapter) {
                      if (!model.isVisible) {
                        // 不可用
                        return;
                      }
                      switch (widget.levelStepStype) {
                        case ShowLevelType.showLevelOneByOne:
                          {
                            // 选择
                            if (_cacheSelectedItem != null &&
                                _cacheSelectedItem.length > i &&
                                _cacheSelectedItem[i].selected) {
                              // 重置之前选择状态
                              _cacheSelectedItem[i].setSelected(false);
                              // 重置,切换之后的部分:
                              // 1.如果是后面已有内容
                              // 2.如果是后面暂无内容
                              int index = i;
                              if (i == 0) {
                                index = -1;
                              }
                              List<dynamic> items = _cacheSelectedItem.sublist(
                                  index + 1, _cacheSelectedItem.length);
                              items.forEach((element) {
                                element.setSelected(false);
                              });
                              _cacheSelectedItem.removeRange(
                                  index + 1, _cacheSelectedItem.length);
                              _pageItems.removeRange(i + 1, _pageItems.length);
                              _sectionItems.removeRange(
                                  i + 1, _sectionItems.length);
                              refreshTabController(_pageItems.length, i);
                            }
                            // 标题更新
                            _refreshSectionTitle(i, model.levelName);
                            model.setSelected(!model.selected);
                            // 缓存选中项目
                            if (_cacheSelectedItem == null) {
                              _cacheSelectedItem = [];
                            }
                            if (_cacheSelectedItem.length > i) {
                              _cacheSelectedItem[i] = model;
                            } else {
                              _cacheSelectedItem.add(model);
                            }
                            // 追加下级
                            if (model.childrenItems != null &&
                                (model.childrenItems as List).isNotEmpty) {
                              _sectionTitleAppendItem();
                              List items = model.childrenItems;
                              _pageItems.add(items);
                              refreshTabController(_pageItems.length, i + 1);
                              _translateForPageWithOutAnimationByIndex(i + 1);
                              _translateToPageByIndex(i + 1);
                            } else {
                              // 最末级
                              if (widget.callBack != null &&
                                  _cacheSelectedItem != null) {
                                widget.callBack!(_cacheSelectedItem);
                              }
                              if (widget.isAutoClose) {
                                Future.delayed(
                                    Duration(milliseconds: 300), _close);
                              }
                            }
                            setState(() {});
                          }
                          break;
                        case ShowLevelType.showLevels:
                          {
                            // 查找上级,并设置选择状态
                            // 选择非链路选项,清空缓存
                            if (model.parentsLevel != null) {
                              String levels = model.parentsLevel;
                              if (levels.isNotEmpty) {
                                List<String> parentIds = levels.split(',');
                                bool isok = parentIds.any((e) => _cachItemId
                                    .where((element) => element == e)
                                    .isNotEmpty);
                                if (!isok && _cacheSelectedItem.isNotEmpty) {
                                  _cacheSelectedItem.forEach((element) {
                                    if (element is LevelsBaseModel) {
                                      element.setSelected(false);
                                    }
                                  });
                                  _cacheSelectedItem.clear();
                                  _cachItemId.clear();
                                }
                              }
                            }
                            model.setSelected(model.selected);
                            if (model.selected) {
                              // 已选id
                              _cacheSelectedItem.forEach((element) {
                                if (element is LevelsBaseModel) {
                                  element.setSelected(true);
                                }
                              });
                            }
                            if (_cacheSelectedItem.isEmpty) {
                              _cacheSelectedItem.add(model);
                            } else {
                              _cacheSelectedItem[i] = model;
                            }
                            _cachItemId.add(model.itemId.toString());
                            // 标题更新
                            _refreshSectionTitle(i, model.levelName);

                            // 初始化下一页数据
                            int nextPage = i + 1;
                            bool isLast = false;
                            if (nextPage == widget.maxLevel) {
                              isLast = true;
                              nextPage -= 1;
                            }
                            _refreshPageDataSource(nextPage,
                                children: model.childrenItems);
                            _cacheSelectedItem.add('');
                            setState(() {});
                            _translateForTabByIndex(nextPage);
                            _translateToPageByIndex(nextPage);
                            if (isLast && widget.isAutoClose) {
                              Future.delayed(
                                  Duration(milliseconds: 300), _close);
                            }
                          }
                          break;
                        default:
                      }
                    };
                    return itemWidget;
                  },
                )
            ],
            onPageChanged: (value) {
              switch (widget.levelStepStype) {
                case ShowLevelType.showLevelOneByOne:
                  // 顶部切换
                  _translateForTabByIndex(value);
                  break;
                case ShowLevelType.showLevels:
                  {
                    // 当前页面,检查是否有选中项目
                    if (_checkIsCanToPage(value)) {
                      // 初始化下一页数据
                      _refreshPageDataSource(value);
                      // 页面转化动画
                      _translateForTabByIndex(value);
                    }
                  }
                  break;
                default:
              }
            }));
  }

  /// 取消
  void doCancel(BuildContext context) {
    Navigator.of(context).pop<List<int>>(null);
    if (widget.onCancel != null) widget.onCancel!();
  }

  /// 确定
  void doConfirm(BuildContext context) async {
    if (widget.onConfirmBefore != null &&
        !(await widget.onConfirmBefore!(widget, _cacheSelectedItem))) {
      return; // Cancel;
    }
    Navigator.of(context).pop<List<dynamic>>(_cacheSelectedItem);
    if (widget.onConfirm != null) widget.onConfirm!(widget, [1, 2, 3]);
  }

  ///
  static ButtonStyle _getButtonStyle(ButtonThemeData theme) => ButtonStyle(
      minimumSize: MaterialStateProperty.all(Size(theme.minWidth, 42)),
      padding: MaterialStateProperty.all(theme.padding));

  /// 圆角
  Widget getCircleCorner(Widget child) {
    return Container(
      color: Colors.black54,
      height: 44,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16), topRight: Radius.circular(16)),
        child: Container(
          decoration: widget.headerDecoration ??
              BoxDecoration(
                border: Border(
                  top: BorderSide(color: theme.dividerColor, width: 0.5),
                  bottom: BorderSide(color: theme.dividerColor, width: 0.5),
                ),
                color: widget.headerColor == null
                    ? (theme.bottomAppBarColor)
                    : widget.headerColor,
              ),
          height: 44,
          child: child,
        ),
      ),
    );
  }
}

typedef AdapterItemCallBack = void Function(
    LevelsBaseModel item, PickerLevelAdapter adapter);

abstract class PickerLevelAdapter<T> {
  int getLength();
  int getMaxLevel();
  AdapterItemCallBack? callBack;
  Widget buildItem(BuildContext context, int index, LevelsBaseModel item);
}

// 地区选择
class PickerCityAdapter<T> extends PickerLevelAdapter<T> {
  PickerCityAdapter(
      {this.title = '',
      this.icon,
      this.items = const [],
      this.levelExtendsUI = ShowPickExtendsUI.extendsNone});
  final String title;
  final Image? icon;
  final List<T> items;
  // 逐级扩展UI,展示方式
  final ShowPickExtendsUI levelExtendsUI;
  @override
  Widget buildItem(BuildContext context, int index, LevelsBaseModel item) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        vertical: 0,
      ),
      title: Text(
        item.levelName,
        style: TextStyle(
            color: item.isVisible
                ? item.selected
                    ? kAppBarColor
                    : kCustomBlackColor
                : kCustomGrayColor.withAlpha(100),
            fontSize: kMiddleFontSize),
      ),
      onTap: () => callBack?.call(item, this),
    );
  }

  @override
  int getLength() {
    return items.length;
  }

  @override
  int getMaxLevel() {
    return 0;
  }
}

// 任意级
class PickerAnyAdapter<T> extends PickerLevelAdapter<T> {
  PickerAnyAdapter(
      {this.title = '',
      this.icon,
      this.btn,
      this.items = const [],
      this.maxLevel = 0,
      this.levelExtendsUI = ShowPickExtendsUI.extendsNone,
      this.extendLabel,
      this.placeHolderText = '子分类'});
  final String title;
  final Image? icon;
  final IconButton? btn;
  final List<T> items;
  final int maxLevel;
  // 缓存
  LevelsBaseModel? _preCacheModel;
  // 逐级扩展UI,展示方式
  final ShowPickExtendsUI levelExtendsUI;
  final Text? extendLabel;
  final String placeHolderText;
  @override
  Widget buildItem(BuildContext context, int index, LevelsBaseModel item) {
    return ListTile(
        title: Text(item.levelName),
        trailing: item.childrenItems == null
            ? null
            : item.childrenItems.isEmpty
                ? null
                : getExtendUI(item),
        onTap: () => callBack?.call(item, this));
  }

  //
  Widget getExtendUI(LevelsBaseModel item) {
    late Widget extendItem;
    switch (levelExtendsUI) {
      case ShowPickExtendsUI.extendsNone:
        extendItem = Text('');
        break;
      case ShowPickExtendsUI.extendsLabel:
        extendItem = extendLabel ??
            Text(
              placeHolderText,
              style: TextStyle(color: Colors.blue, fontSize: 14),
            );
        break;
      case ShowPickExtendsUI.extendsIcon:
        {
          extendItem = IconButton(
              onPressed: () {
                if (_preCacheModel == item) {
                  item.setSelected(!item.selected);
                } else {
                  if (_preCacheModel != null) {
                    _preCacheModel?.setSelected(false);
                  }
                  item.setSelected(!item.selected);
                  if (item.selected) {
                    _preCacheModel = item;
                  }
                }
                callBack?.call(item, this);
              },
              icon: Image.asset(
                item.selected ? 'system_radio_sel.png' : 'system_radio_nor.png',
                package: 'flutter_levels_picker',
              ));
        }
        break;
      default:
    }
    return extendItem;
  }

  @override
  int getLength() {
    return items.length;
  }

  @override
  int getMaxLevel() {
    return maxLevel;
  }
}
