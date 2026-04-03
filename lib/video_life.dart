
import 'video_life_platform_interface.dart';

class VideoLife {
  Future<String?> getPlatformVersion() {
    return VideoLifePlatform.instance.getPlatformVersion();
  }

  //开始保活
  Future startLife() async {
    return VideoLifePlatform.instance.startLife();
  }

  //结束保活
  Future closeLife() async {
    return VideoLifePlatform.instance.closeLife();
  }

}
