///
///
/// These tests must be run via:
///  - [iOS/Android] connect a device, then `flutter run test/widget_test.dart`
///  - [iOS/Android] start a simulator/emulator, then `flutter run test/widget_test.dart`
///  - [macOS] when host is a Mac - `flutter run -d macos test/widget_test.dart`
///
///

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:info_plist_example/main.dart';
// import 'package:info_plist/info_plist.dart';

void main() {
  // testWidgets('Ensure tests run on device/simulator/emulator',
  //     (WidgetTester tester) async {
  //   await InfoPlist.getInfoPlistContents();
  // }, timeout: Timeout(Duration(milliseconds: 300)));

  testWidgets('Verify message is shown', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.text('Unknown'), findsOneWidget);

    await tester.pump(Duration(milliseconds: 300));

    if (Platform.isIOS || Platform.isMacOS) {
      expect(find.textContaining('CFBundleName'), findsOneWidget);
    } else {
      expect(
        find.text('Unsupported platform: ${Platform.operatingSystem}'),
        findsOneWidget,
      );
    }
  });
}
