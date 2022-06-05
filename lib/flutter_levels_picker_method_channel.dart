import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_levels_picker_platform_interface.dart';

/// An implementation of [FlutterLevelsPickerPlatform] that uses method channels.
class MethodChannelFlutterLevelsPicker extends FlutterLevelsPickerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_levels_picker');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
