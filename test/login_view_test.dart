import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pawfection/login_view.dart';
import 'package:pawfection/models/user.dart';
import 'package:flutter/material.dart';

// Create a mock UserRepository
class MockUserRepository extends Mock implements UserRepository {}

// Create a mock UserService
class MockUserService extends Mock implements UserService {}

void main() {
  group('LoginView', () {
    late LoginView loginView;
    late MockUserRepository userRepository;
    late MockUserService userService;

    setUp(() {
      userRepository = MockUserRepository();
      userService = MockUserService();
      loginView = LoginView(
        userRepository: userRepository,
        userService: userService,
      );
    });

    testWidgets('Login with valid credentials navigates to ManagerView',
        (WidgetTester tester) async {
      // Mock the UserRepository's findUserByUUID method to return a valid user
      when(userService.findUserByUUID(any))
          .thenAnswer((_) => Future.value(User(email: 'test@example.com')));

      // Mock the UserService's updateUserUid, addUserWithId, and deleteUser methods
      when(userService.updateUserUid(any, any))
          .thenAnswer((_) => Future.value());
      when(userService.addUserWithId(any)).thenAnswer((_) => Future.value());
      when(userService.deleteUser(any)).thenAnswer((_) => Future.value());

      // Build the widget
      await tester.pumpWidget(loginView);

      // Enter valid credentials and submit the login form
      await tester.enterText(find.byKey(Key('nameField')), 'test@example.com');
      await tester.enterText(find.byKey(Key('passwordField')), 'password');
      await tester.tap(find.byKey(Key('loginButton')));
      await tester.pumpAndSettle();

      // Verify that the navigation to ManagerView occurred
      expect(find.byType(ManagerView), findsOneWidget);
    });

    testWidgets('Login with invalid credentials shows error message',
        (WidgetTester tester) async {
      // Mock the FirebaseAuth's signInWithEmailAndPassword method to throw an exception
      when(userService.findUserByUUID(any)).thenThrow(Exception());

      // Build the widget
      await tester.pumpWidget(loginView);

      // Enter invalid credentials and submit the login form
      await tester.enterText(find.byKey(Key('nameField')), 'test@example.com');
      await tester.enterText(find.byKey(Key('passwordField')), 'password');
      await tester.tap(find.byKey(Key('loginButton')));
      await tester.pumpAndSettle();

      // Verify that the error message is displayed
      expect(find.text('Invalid credentials'), findsOneWidget);
    });
  });
}
