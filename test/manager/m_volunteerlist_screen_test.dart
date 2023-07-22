import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawfection/manager/m_volunteerlist_screen.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets(
      'Given the MVolunteerListScreen, then there will be a app bar with the volunteer text',
      (WidgetTester tester) async {
    // Render the widget.
    await tester.pumpWidget(MaterialApp(
        title: 'Firestore Example',
        home: MVolunteerListScreen(
          firebaseFirestore: FakeFirebaseFirestore(),
        )));
    // Let the snapshots stream fire a snapshot.

    await tester.idle();
    // Re-render.
    await tester.pump();

    // // Verify the output.
    expect(find.text('Volunteers'), findsOneWidget);
  });

  testWidgets('Given the MVolunteerListScreen, then there will be a search bar',
      (WidgetTester tester) async {
    // Populate the fake database.

    // Render the widget.
    await tester.pumpWidget(MaterialApp(
        title: 'Firestore Example',
        home: MVolunteerListScreen(
          firebaseFirestore: FakeFirebaseFirestore(),
        )));
    // Let the snapshots stream fire a snapshot.

    await tester.idle();
    // Re-render.
    await tester.pump();

    // // Verify the output.
    expect(find.text('Volunteers'), findsOneWidget);
  });

  testWidgets(
      'Given a userJSON when added into Firebase then the user information will be displayed on the MVolunteerListScreen',
      (WidgetTester tester) async {
    // Populate the fake database.

    FakeFirebaseFirestore fakeFirebaseFirestore = FakeFirebaseFirestore();
    await fakeFirebaseFirestore.collection('users').add({
      'email': 'rayn@gmail.com',
      'referenceId': "referenceId",
      'username': "username",
      'role': "role",
      'availabledates': [
        DateTime.now().millisecondsSinceEpoch,
        DateTime.now().millisecondsSinceEpoch
      ],
      'preferences': ["preferences"],
      'experiences': ["experiences"],
      'profilepicture': "profilepicture",
      'contactnumber': "contactnumber",
      'bio': "bio",
      'taskcount': 0
    });

    // Render the widget.
    await tester.pumpWidget(MaterialApp(
        title: 'Firestore Example',
        home: MVolunteerListScreen(
          firebaseFirestore: fakeFirebaseFirestore,
        )));
    // Let the snapshots stream fire a snapshot.

    await tester.idle();
    // Re-render.
    await tester.pump();

    // // Verify the output.
    expect(find.text('username'), findsOneWidget);
  });
}
