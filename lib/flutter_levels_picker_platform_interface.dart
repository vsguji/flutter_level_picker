import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_levels_picker_method_channel.dart';

abstract class FlutterLevelsPickerPlatform extends PlatformInterface {
  /// Constructs a FlutterLevelsPickerPlatform.
  FlutterLevelsPickerPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterLevelsPickerPlatform _instance = MethodChannelFlutterLevelsPicker();

  /// The default instance of [FlutterLevelsPickerPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterLevelsPicker].
  static FlutterLevelsPickerPlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterLevelsPickerPlatform] when
  /// they register themselves.
  static set instance(FlutterLevelsPickerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
