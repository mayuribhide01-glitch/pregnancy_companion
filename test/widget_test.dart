import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pregnancy_companion/app.dart';
import 'package:pregnancy_companion/core/routes.dart';

void main() {
  testWidgets('Home renders and bottom nav switches to Tools',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(402, 874));
    await tester
        .pumpWidget(const PregnancyCompanionApp(initialRoute: Routes.shell));
    await tester.pumpAndSettle();

    expect(find.text('Ananya'), findsOneWidget);
    expect(find.text('1 weeks'), findsOneWidget);

    await tester.tap(find.text('Tools'));
    await tester.pumpAndSettle();
    expect(find.text('TOOLS'), findsOneWidget);
  });

  testWidgets('Splash moves on to Login', (tester) async {
    await tester.binding.setSurfaceSize(const Size(402, 874));
    await tester.pumpWidget(const PregnancyCompanionApp());
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
  });
}
