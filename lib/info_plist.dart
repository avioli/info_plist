import 'dart:async';
import 'dart:collection';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

typedef ImmutableMap = UnmodifiableMapView<String, Object?>;

/// A namespace to get iOS and macOS bundle information from the `info.plist`
/// file
///
/// To read the data you need to call [getInfoPlistContents] at least once,
/// then await it to finish.
class InfoPlist {
  static const MethodChannel _channel = const MethodChannel('info_plist');

  /// Returns a [Future] that will contain the `info.plist` [Map]
  ///
  /// This method will only ever make a read once and cache the resulting data.
  /// Subsequent calls will simply return the same [Map] instance.
  ///
  /// NOTE: The [Map] is actually an `[UnmodifiableMapView<String, Object?>]`.
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

  /// Returns the `CFBundleIdentifier` value
  ///
  /// NOTE: Must await the [getInfoPlistContents]
  static String? get bundleIdentifier => _data?['CFBundleIdentifier'] as String;

  /// Returns the `CFBundleName` value
  ///
  /// NOTE: Must await the [getInfoPlistContents]
  static String? get bundleName => _data?['CFBundleName'] as String;

  /// Returns the `CFBundleShortVersionString` value
  ///
  /// NOTE: Must await the [getInfoPlistContents]
  static String? get version => _data?['CFBundleShortVersionString'] as String;

  /// Returns the `CFBundleVersion` value
  ///
  /// NOTE: Must await the [getInfoPlistContents]
  static String? get build => _data?['CFBundleVersion'] as String;

  /// Returns the raw data as an unmodifiable [Map]
  ///
  /// NOTE: Must await the [getInfoPlistContents]
  static ImmutableMap? get rawData => _data;

  static Completer<void>? _completer;
  static ImmutableMap? _data;

  @visibleForTesting
  static clear() {
    _data = null;
    _completer = null;
  }
}
