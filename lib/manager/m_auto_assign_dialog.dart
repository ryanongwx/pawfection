import 'package:flutter/material.dart';
import 'package:pawfection/service/functions_service.dart';

class AutoAssignDialog extends StatefulWidget {
  final BuildContext parentContext;

  const AutoAssignDialog({Key? key, required this.parentContext}) : super(key: key);

  @override
  _AutoAssignDialogState createState() => _AutoAssignDialogState();
}

class _AutoAssignDialogState extends State<AutoAssignDialog> {
  final functionService = FunctionService();
  Map<String, String> selectedVolunteers = {};

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: functionService.autoAssign(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While waiting for the future to complete, show a loading indicator
          return const Padding(
            padding: EdgeInsets.all(20.0),
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          // If an error occurs while fetching the tasks, display an error message
          debugPrint('Error: ${snapshot.error}');
          return Text('Error: ${snapshot.error}');
        } else {
          // The future completed successfully
          final tasks = snapshot.data!['tasks'];
          final volunteers = snapshot.data!['volunteers'];
          if (tasks!.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text('No tasks available.'),
            );
          } else {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                final volunteerIds = volunteers[task.referenceId];
                final assignedTo = task.assignedto;

                if (!selectedVolunteers.containsKey(task.referenceId)) {
                  selectedVolunteers[task.referenceId] = assignedTo;
                }

                return Column(
                  children: [
                    Text('${task.name}:'),
                    if (volunteerIds.isNotEmpty)
                      DropdownButton<String>(
                        value: selectedVolunteers[task.referenceId],
                        icon: const Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedVolunteers[task.referenceId] = newValue!;
                          });
                        },
                        items: volunteerIds.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                  ],
                );
              },
            );
          }
        }
      },
    );
  }
}


Future<void> displayAutoAssignDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: AutoAssignDialog(parentContext: context),
      );
    },
  );
}