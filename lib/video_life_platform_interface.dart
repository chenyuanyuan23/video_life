import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'video_life_method_channel.dart';

abstract class VideoLifePlatform extends PlatformInterface {
  /// Constructs a VideoLifePlatform.
  VideoLifePlatform() : super(token: _token);

  static final Object _token = Object();

  static VideoLifePlatform _instance = MethodChannelVideoLife();

  /// The default instance of [VideoLifePlatform] to use.
  ///
  /// Defaults to [MethodChannelVideoLife].
  static VideoLifePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [VideoLifePlatform] when
  /// they register themselves.
  static set instance(VideoLifePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  //开始保活
  Future startLife() async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  //结束保活
  Future closeLife() async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

}
