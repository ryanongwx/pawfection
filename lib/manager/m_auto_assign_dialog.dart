import 'package:flutter/material.dart';
import 'package:pawfection/service/functions_service.dart';
import '../models/task.dart';

Future<void> displayAutoAssignDialog(BuildContext context) async {
  final functionService = FunctionService();

  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: FutureBuilder<Map<String, dynamic>>(
          future: functionService.autoAssign(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // While waiting for the future to complete, show a loading indicator
              return const Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text("Loading..."),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              // If an error occurs while fetching the tasks, display an error message
              debugPrint('Error: ${snapshot.error}');
              return Text('Error: ${snapshot.error}');
            } else {
              // The future completed successfully
              final tasks = snapshot.data!['tasks'];
              final volunteers = snapshot.data!['volunteers'];
              // Create a map of referenceId to volunteer object
              final volunteersMap = {
                for (var volunteer in volunteers)
                  volunteer.referenceId: volunteer
              };
              if (tasks!.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'No tasks available.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Tasks:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          if (task!.assignedto == null) {
                            return const SizedBox
                                .shrink(); // Return an empty SizedBox for tasks with assignedto == null
                          } else {
                            final volunteer = volunteersMap[task.assignedto];
                            return Text('${task.name} is assigned to ${volunteer.username}');
                          }
                        },
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          if (task!.assignedto == null) {
                            return Text('${task.name} (null)');
                          } else {
                            return const SizedBox
                                .shrink(); // Return an empty SizedBox for tasks with assignedto != null
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          // Update the task in the database
                          for (final task in tasks) {
                            if (task!.assignedto != null) {
                              taskService.updateTask(task);
                            }
                          }
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: const Text('Confirm'),
                      ),
                    ],
                  ),
                );
              }
            }
          },
        ),
      );
    },
  );
}
