import 'dart:async';
import 'dart:collection';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

typedef ImmutableMap = UnmodifiableMapView<String, Object?>;

class InfoPlist {
  static const MethodChannel _channel = const MethodChannel('info_plist');

  static Future<ImmutableMap> getInfoPlistContents() {
    if (_completer == null) {
      final completer = Completer<void>();
      _completer = completer;
      _channel.invokeMethod('getInfoPlistContents').then((Object? data) {
        if (data is Map) {
          final typed = Map<String, Object?>.from(data);
          _data = ImmutableMap(typed);
        } else {
          _data = ImmutableMap({});
        }
        completer.complete();
      }).catchError((Object err) {
        completer.completeError(err);
      });
    }
    return _completer!.future.then((_) => _data!);
  }

  static String? get bundleIdentifier => _data?['CFBundleIdentifier'] as String;
  static String? get bundleName => _data?['CFBundleName'] as String;
  static String? get version => _data?['CFBundleShortVersionString'] as String;
  static String? get build => _data?['CFBundleVersion'] as String;

  static ImmutableMap? get rawData => _data;

  static Completer<void>? _completer;
  static ImmutableMap? _data;

  @visibleForTesting
  static clear() {
    _data = null;
    _completer = null;
  }
}
