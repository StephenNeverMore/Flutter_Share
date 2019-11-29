import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';

class FlutterShare {
  static const MethodChannel _channel = const MethodChannel('flutter_share');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static void share(String title, String url,
      {String src, Uint8List image}) async {
    await _channel.invokeMethod('share', <String, dynamic>{
      "title": title,
      "url": url,
      "src": src,
      "image": image
    });
  }
}
