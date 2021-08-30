import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:info_plist/info_plist.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('supported platform', () {
    const MethodChannel channel = MethodChannel('info_plist');

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        if (methodCall.method == 'getInfoPlistContents') {
          return {
            'CFBundleIdentifier': 'name.avioli.info_plist',
            'CFBundleName': 'Info plist plugin',
            'CFBundleShortVersionString': '1.0',
            'CFBundleVersion': '123',
            'UIMainStoryboardFile': 'Main',
          };
        }
        return null;
      });
    });

    tearDown(() {
      channel.setMockMethodCallHandler(null);
      InfoPlist.clear();
    });

    test('getInfoPlistContents', () async {
      final infoPlist = await InfoPlist.getInfoPlistContents();

      expect(InfoPlist.bundleIdentifier, 'name.avioli.info_plist');
      expect(InfoPlist.bundleName, 'Info plist plugin');
      expect(InfoPlist.version, '1.0');
      expect(InfoPlist.build, '123');

      expect(infoPlist['UIMainStoryboardFile'], 'Main');

      expect(InfoPlist.rawData, infoPlist);
    });

    test('Data is immutable', () async {
      final infoPlist = await InfoPlist.getInfoPlistContents();

      expect(() => infoPlist['CFBundleVersion'] = '', throwsUnsupportedError);
      expect(() => infoPlist.remove('CFBundleName'), throwsUnsupportedError);
    });
  });

  group('unsupported platform', () {
    const MethodChannel channel = MethodChannel('info_plist');

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        return null;
      });
    });

    tearDown(() {
      channel.setMockMethodCallHandler(null);
      InfoPlist.clear();
    });

    test('Data is blank on unsupported platforms', () async {
      await InfoPlist.getInfoPlistContents();
      final infoPlist = InfoPlist.rawData!;
      expect(infoPlist.length, 0);
    });
  });
}
