import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawfection/volunteer/v_dashboard_screen.dart';
import 'package:pawfection/volunteer/v_profile_screen.dart';
import 'package:pawfection/voluteer_view.dart';

void main() {
  testWidgets('VolunteerView displays dashboard screen by default',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: VolunteerView(tab: 0)));

    // Verify that VDashboardScreen is displayed by default
    expect(find.text('Tasks'), findsOneWidget);
    expect(find.byType(VProfileScreen), findsNothing);
  });

  testWidgets(
      'VolunteerView displays profile screen when navigating to Profile tab',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: VolunteerView(tab: 0)));

    // Tap on the Profile tab
    await tester.tap(find.byIcon(Icons.account_circle));
    await tester.pumpAndSettle();

    // Verify that VProfileScreen is displayed after tapping the Profile tab
    expect(find.byType(VDashboardScreen), findsNothing);
    expect(find.byType(VProfileScreen), findsOneWidget);
  });

  testWidgets('VolunteerView switches between screens on bottom bar tap',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: VolunteerView(tab: 0)));

    // Tap on the Profile tab
    await tester.tap(find.byIcon(Icons.account_circle));
    await tester.pumpAndSettle();

    // Verify that VProfileScreen is displayed after tapping the Profile tab
    expect(find.byType(VDashboardScreen), findsNothing);
    expect(find.byType(VProfileScreen), findsOneWidget);

    // Tap on the Dashboard tab
    await tester.tap(find.byIcon(Icons.dashboard));
    await tester.pumpAndSettle();

    // Verify that VDashboardScreen is displayed after tapping the Dashboard tab
    expect(find.byType(VDashboardScreen), findsOneWidget);
    expect(find.byType(VProfileScreen), findsNothing);
  });
}
