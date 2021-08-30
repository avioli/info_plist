// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:info_plist_example/main.dart';

void main() {
  testWidgets('Verify message is shown', (WidgetTester tester) async {
    // Build our app and trigger a frame.
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
