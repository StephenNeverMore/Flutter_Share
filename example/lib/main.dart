import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterShare.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: <Widget>[
            Text('Running on: $_platformVersion\n'),
            Image.asset("assets/images/failed.png"),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => share(),
          child: Text("share"),
        ),
      ),
    );
  }

  PlatformAssetBundle bundle = PlatformAssetBundle();

  share() async {
    String url = "https://apps.apple.com/cn/";
    String urlQQ = "https://apps.apple.com/cn/app/id444934666";
    bundle.load("assets/images/failed.png").then((result) {
      FlutterShare.share("分享的标题 \n$urlQQ", "",
          image: result.buffer.asUint8List());
    });
  }
}
