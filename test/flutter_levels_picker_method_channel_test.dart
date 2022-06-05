import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_levels_picker/flutter_levels_picker_method_channel.dart';

void main() {
  MethodChannelFlutterLevelsPicker platform = MethodChannelFlutterLevelsPicker();
  const MethodChannel channel = MethodChannel('flutter_levels_picker');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
