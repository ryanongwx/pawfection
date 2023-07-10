import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:pawfection/models/task.dart';
import 'package:pawfection/models/user.dart';
import 'package:pawfection/repository/task_repository.dart';
import 'package:pawfection/repository/user_repository.dart';
import 'package:pawfection/service/task_service.dart';
import 'package:pawfection/service/user_service.dart';
import 'package:pawfection/voluteer_view.dart';

Future<void> displayCompleteTaskDialog(BuildContext context, String id) async {
  final taskService = TaskService();
  final userService = UserService();

  final formKey = GlobalKey<FormState>();
  late var _form;

  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: FutureBuilder<Task?>(
          future: taskService.findTaskByTaskID(id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // While waiting for the future to complete, show a loading indicator
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              // If an error occurs while fetching the user, display an error message
              return Text('Error: ${snapshot.error}');
            } else {
              // The future completed successfully
              final task = snapshot.data;

              return (task == null)
                  ? const Text('Error retrieving pet details')
                  : ListView(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(30),
                          child: Center(
                            child: Text(
                              task.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 48),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${task.deadline.map((timestamp) => DateTime.fromMicrosecondsSinceEpoch(timestamp!.microsecondsSinceEpoch)).elementAt(0)} - ${task.deadline.map((timestamp) => DateTime.fromMicrosecondsSinceEpoch(timestamp!.microsecondsSinceEpoch)).elementAt(1)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 48),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Description',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  task.description,
                                  style: const TextStyle(
                                      fontSize: 16, height: 1.4),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 48),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Feedback',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                FastForm(
                                  formKey: formKey,
                                  onChanged: (value) {
                                    // ignore: avoid_print
                                    print('Form changed: ${value.toString()}');
                                    _form = value;
                                  },
                                  inputDecorationTheme: InputDecorationTheme(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey[700]!, width: 1),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                  children: const [
                                    FastTextField(
                                      name: 'feedback',
                                      minLines: 1,
                                      maxLines: 5,
                                      placeholder: 'Enter Task Feedback',
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 30, left: 30, top: 10),
                          child: ElevatedButton(
                            onPressed: () async {
                              task.feedback = _form['feedback'];
                              task.status = 'Completed';
                              taskService.updateTask(task);

                              // Subtract one from the taskcounter of the previous user assigned
                              User? prevassigneduser = await userService
                                  .findUserByUUID(task.assignedto!);
                              if (prevassigneduser != null) {
                                prevassigneduser.taskcount -= 1;
                                userService.updateUser(prevassigneduser);
                              }

                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => const VolunteerView(
                                          tab: 0,
                                        )),
                              );
                            },
                            child: const Text('Complete'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 30, left: 30, top: 10, bottom: 30),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Return'),
                          ),
                        )
                      ],
                    );
            }
          },
        ),
      );
    },
  );
}
