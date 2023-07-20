import 'package:flutter_test/flutter_test.dart';
import 'package:pawfection/manager/m_volunteerlist_screen.dart';
import 'package:pawfection/models/user.dart';
import 'package:pawfection/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:pawfection/service/user_service.dart';
import 'dart:io';

void main() {
  testWidgets('shows users', (WidgetTester tester) async {
    // Populate the fake database.
    UserRepository userRepository = UserRepository(false);
    UserService userService = UserService(false);

    userService.addFakeUser(User("email",
        referenceId: "referenceId",
        username: "username",
        role: "role",
        availabledates: [],
        preferences: ["preferences"],
        experiences: ["experiences"],
        profilepicture: "profilepicture",
        contactnumber: "contactnumber",
        bio: "bio",
        taskcount: 0));

    // Render the widget.
    await tester.pumpWidget(MaterialApp(
        title: 'Firestore Example',
        home: MVolunteerListScreen(
          userService: false,
          userRepository: false,
        )));
    // Let the snapshots stream fire a snapshot.

    // // Verify the output.
    expect(find.text('username'), findsOneWidget);
  });
}
