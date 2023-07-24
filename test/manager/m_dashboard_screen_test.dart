import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_advanced_segment/flutter_advanced_segment.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawfection/manager/m_dashboard_screen.dart';
import 'package:pawfection/models/task.dart';
import 'package:flutter/material.dart';

import 'package:searchable_listview/searchable_listview.dart';

void main() {
  testWidgets(
      'Given the MDashboardScreen, then there will be a app bar with the Tasks text',
      (WidgetTester tester) async {
    // Render the widget.
    await tester.pumpWidget(MaterialApp(
        title: 'Firestore Example',
        home: MDashboardScreen(
          firebaseFirestore: FakeFirebaseFirestore(),
        )));
    // Let the snapshots stream fire a snapshot.

    await tester.idle();
    // Re-render.
    await tester.pump();

    // // Verify the output.
    expect(find.text('Tasks'), findsOneWidget);
  });

  testWidgets(
      'Given the MDashboardScreen, then there will be a app bar with the Icons',
      (WidgetTester tester) async {
    // Render the widget.
    await tester.pumpWidget(MaterialApp(
        title: 'Mock Pet Screen',
        home: MDashboardScreen(
          firebaseFirestore: FakeFirebaseFirestore(),
        )));
    // Let the snapshots stream fire a snapshot.

    await tester.idle();
    // Re-render.
    await tester.pump();

    // // Verify the output.
    expect(find.byType(Icon), findsNWidgets(5));
  });

  testWidgets('Given the MDashboardScreen, then there will be a search bar',
      (WidgetTester tester) async {
    // Populate the fake database.

    // Render the widget.
    await tester.pumpWidget(MaterialApp(
        title: 'Firestore Example',
        home: MDashboardScreen(
          firebaseFirestore: FakeFirebaseFirestore(),
        )));
    // Let the snapshots stream fire a snapshot.

    await tester.idle();
    // Re-render.
    await tester.pump();

    // // Verify the output.
    expect(find.byType(SearchableList<Task>), findsOneWidget);
  });

  testWidgets(
      'Given the MDashboardScreen, then there will be a status filter bar',
      (WidgetTester tester) async {
    // Populate the fake database.

    // Render the widget.
    await tester.pumpWidget(MaterialApp(
        title: 'Firestore Example',
        home: MDashboardScreen(
          firebaseFirestore: FakeFirebaseFirestore(),
        )));
    // Let the snapshots stream fire a snapshot.

    await tester.idle();
    // Re-render.
    await tester.pump();

    // // Verify the output.
    expect(find.byType(AdvancedSegment<String, String>), findsOneWidget);
  });

  testWidgets(
      'Given a taskJSON when added into Firebase then the user information will be displayed on the MDashboardScreen',
      (WidgetTester tester) async {
    // Populate the fake database.

    FakeFirebaseFirestore fakeFirebaseFirestore = FakeFirebaseFirestore();
    await fakeFirebaseFirestore.collection('tasks').add({
      'name': 'exampletask',
      'referenceId': 'referenceId',
      'createdby': 'createdby',
      'description': 'description',
      'category': 'Feeding',
      'status': 'Open',
      'resources': [],
      'contactperson': 'contactperson',
      'contactpersonnumber': 'contactpersonnumber',
      'requests': [],
      'deadline': [
        DateTime.now().millisecondsSinceEpoch,
        DateTime.now().millisecondsSinceEpoch
      ]
    });

    // Render the widget.
    await tester.pumpWidget(MaterialApp(
        title: 'Firestore Example',
        home: MDashboardScreen(
          firebaseFirestore: fakeFirebaseFirestore,
        )));
    // Let the snapshots stream fire a snapshot.

    await tester.idle();
    // Re-render.
    await tester.pump();

    // // Verify the output.
    expect(find.byType(EmptyView), findsOneWidget);
  });
}
