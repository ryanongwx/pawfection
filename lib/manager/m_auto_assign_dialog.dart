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
        child: FutureBuilder<List<Task?>>(
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
              final tasks = snapshot.data;
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
                          return Text(task!.name);
                        },
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
