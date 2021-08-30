import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:info_plist/info_plist.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _message = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String message = '';

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      if (Platform.isIOS || Platform.isMacOS) {
        final infoPlist = await InfoPlist.getInfoPlistContents();
        message = JsonEncoder.withIndent('  ').convert(infoPlist);
      } else {
        message = 'Unsupported platform: ${Platform.operatingSystem}';
      }
    } on PlatformException catch (err) {
      message = 'Failed to get Info.plist contents: ${err.message}.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _message = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(_message),
          ),
        ),
      ),
    );
  }
}
