// test/widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/app.dart';

void main() {
  testWidgets('Agrotani app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: AgrotaniApp()),
    );
    // Just verify it doesn't crash
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
