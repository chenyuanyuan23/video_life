import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'video_life_platform_interface.dart';

/// An implementation of [VideoLifePlatform] that uses method channels.
class MethodChannelVideoLife extends VideoLifePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('video_life');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  //开始保活
  @override
  Future startLife() async {
    await methodChannel.invokeMethod('start_life');
    return;
  }

  //结束保活
  @override
  Future closeLife() async {
    await methodChannel.invokeMethod('close_life');
    return;
  }

}
