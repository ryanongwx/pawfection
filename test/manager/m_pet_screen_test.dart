import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:pawfection/manager/m_pet_screen.dart';
import 'package:searchable_listview/searchable_listview.dart';
import 'package:pawfection/models/pet.dart';

void main() {
  testWidgets(
      'Given the MPetScreen, then there will be a app bar with the pets text',
      (WidgetTester tester) async {
    // Render the widget.
    await tester.pumpWidget(MaterialApp(
        title: 'Mock Pet Screen',
        home: MPetScreen(
          firebaseFirestore: FakeFirebaseFirestore(),
        )));
    // Let the snapshots stream fire a snapshot.

    await tester.idle();
    // Re-render.
    await tester.pump();

    // // Verify the output.
    expect(find.text('Pets'), findsOneWidget);
  });

  testWidgets(
      'Given the MPetScreen, then there will be a app bar with the Icons',
      (WidgetTester tester) async {
    // Render the widget.
    await tester.pumpWidget(MaterialApp(
        title: 'Mock Pet Screen',
        home: MPetScreen(
          firebaseFirestore: FakeFirebaseFirestore(),
        )));
    // Let the snapshots stream fire a snapshot.

    await tester.idle();
    // Re-render.
    await tester.pump();

    // // Verify the output.
    expect(find.byType(Icon), findsNWidgets(3));
  });

  testWidgets('Given the MPetScreen, then there will be a search bar',
      (WidgetTester tester) async {
    // Populate the fake database.

    // Render the widget.
    await tester.pumpWidget(MaterialApp(
        title: 'Mock Pet Screen',
        home: MPetScreen(
          firebaseFirestore: FakeFirebaseFirestore(),
        )));
    // Let the snapshots stream fire a snapshot.

    await tester.idle();
    // Re-render.
    await tester.pump();

    // // Verify the output.
    expect(find.byType(SearchableList<Pet>), findsOneWidget);
  });

  testWidgets('Given the MPetScreen, then there will be search bar text',
      (WidgetTester tester) async {
    // Populate the fake database.

    // Render the widget.
    await tester.pumpWidget(MaterialApp(
        title: 'Mock Pet Screen',
        home: MPetScreen(
          firebaseFirestore: FakeFirebaseFirestore(),
        )));
    // Let the snapshots stream fire a snapshot.

    await tester.idle();
    // Re-render.
    await tester.pump();

    // // Verify the output.
    expect(find.text('Search Pet'), findsOneWidget);
  });

  testWidgets(
      'Given a petJSON when added into Firebase then the user information will be displayed on the MVolunteerListScreen',
      (WidgetTester tester) async {
    // Populate the fake database.

    FakeFirebaseFirestore fakeFirebaseFirestore = FakeFirebaseFirestore();
    await fakeFirebaseFirestore.collection('pets').add({
      'name': 'Truffle',
      'profilepicture': 'profilepicture.png',
      'referenceId': 'referenceId',
    });

    // Render the widget.
    await tester.pumpWidget(MaterialApp(
        title: 'Mock Pet Screen',
        home: MPetScreen(
          firebaseFirestore: fakeFirebaseFirestore,
        )));
    // Let the snapshots stream fire a snapshot.

    await tester.idle();
    // Re-render.
    await tester.pump();

    // // Verify the output.
    expect(find.byType(PetItem), findsOneWidget);
  });
}
