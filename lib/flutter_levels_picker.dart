
import 'flutter_levels_picker_platform_interface.dart';

class FlutterLevelsPicker {
  Future<String?> getPlatformVersion() {
    return FlutterLevelsPickerPlatform.instance.getPlatformVersion();
  }
}
