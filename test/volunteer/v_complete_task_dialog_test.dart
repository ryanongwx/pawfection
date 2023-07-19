import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawfection/volunteer/v_complete_task_dialog.dart';
import 'package:pawfection/voluteer_view.dart';

void main() {
  testWidgets('displayCompleteTaskDialog displays dialog and completes task',
      (WidgetTester tester) async {
    // Build the widget under test
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: Builder(
      builder: (BuildContext context) {
        return ElevatedButton(
          onPressed: () {
            displayCompleteTaskDialog(context, 'task_id');
          },
          child: const Text('Open Dialog'),
        );
      },
    ))));

    // Tap the button to open the dialog
    await tester.tap(find.text('Open Dialog'));
    await tester.pumpAndSettle();

    // Verify the dialog is displayed
    expect(find.byType(Dialog), findsOneWidget);

    // Verify loading indicator is displayed while waiting for task
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Simulate the completion of the future and display the task details
    await tester.pumpAndSettle();

    // Verify task details are displayed
    expect(find.text('Task Name'), findsOneWidget);
    expect(find.text('Task Deadline'), findsOneWidget);
    expect(find.text('Task Description'), findsOneWidget);
    expect(find.text('Task Feedback'), findsOneWidget);

    // Enter feedback text in the text field
    await tester.enterText(
        find.byType(TextField), 'Task completed successfully');
    await tester.pumpAndSettle();

    // Tap the 'Complete' button
    await tester.tap(find.text('Complete'));
    await tester.pumpAndSettle();

    // Verify task is updated and user is navigated to VolunteerView
    expect(find.byType(VolunteerView), findsOneWidget);
  });

  testWidgets(
      'displayCompleteTaskDialog displays error when task retrieval fails',
      (WidgetTester tester) async {
    // Build the widget under test
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: Builder(
      builder: (BuildContext context) {
        return ElevatedButton(
          onPressed: () {
            displayCompleteTaskDialog(context, 'task_id');
          },
          child: const Text('Open Dialog'),
        );
      },
    ))));

    // Tap the button to open the dialog
    await tester.tap(find.text('Open Dialog'));
    await tester.pumpAndSettle();

    // Simulate an error during task retrieval
    // Replace `taskService.findTaskByTaskID(id)` with `throw Exception('Task retrieval error')`
    await tester.pumpAndSettle();

    // Verify error message is displayed
    expect(find.text('Error: Task retrieval error'), findsOneWidget);
  });

  testWidgets(
      'displayCompleteTaskDialog closes dialog when "Return" button is pressed',
      (WidgetTester tester) async {
    // Build the widget under test
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: Builder(
      builder: (BuildContext context) {
        return ElevatedButton(
          onPressed: () {
            displayCompleteTaskDialog(context, 'task_id');
          },
          child: const Text('Open Dialog'),
        );
      },
    ))));

    // Tap the button to open the dialog
    await tester.tap(find.text('Open Dialog'));
    await tester.pumpAndSettle();

    // Tap the "Return" button
    await tester.tap(find.text('Return'));
    await tester.pumpAndSettle();

    // Verify the dialog is closed
    expect(find.byType(Dialog), findsNothing);
  });
}
