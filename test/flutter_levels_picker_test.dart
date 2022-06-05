import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_levels_picker/flutter_levels_picker.dart';
import 'package:flutter_levels_picker/flutter_levels_picker_platform_interface.dart';
import 'package:flutter_levels_picker/flutter_levels_picker_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterLevelsPickerPlatform 
    with MockPlatformInterfaceMixin
    implements FlutterLevelsPickerPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterLevelsPickerPlatform initialPlatform = FlutterLevelsPickerPlatform.instance;

  test('$MethodChannelFlutterLevelsPicker is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterLevelsPicker>());
  });

  test('getPlatformVersion', () async {
    FlutterLevelsPicker flutterLevelsPickerPlugin = FlutterLevelsPicker();
    MockFlutterLevelsPickerPlatform fakePlatform = MockFlutterLevelsPickerPlatform();
    FlutterLevelsPickerPlatform.instance = fakePlatform;
  
    expect(await flutterLevelsPickerPlugin.getPlatformVersion(), '42');
  });
}
