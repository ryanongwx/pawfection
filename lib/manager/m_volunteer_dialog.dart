import 'package:flutter/material.dart';
import 'package:pawfection/models/user.dart';
import 'package:pawfection/service/task_service.dart';
import 'package:pawfection/service/user_service.dart';
import '../models/task.dart';

Future<void> displayVolunteersDialog(BuildContext context, Task task) async {
  final taskService = TaskService();
  final userService = UserService(true);

  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: FutureBuilder<List<User>>(
            future: userService.getUserList(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // While waiting for the future to complete, show a loading indicator
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                // If an error occurs while fetching the user, display an error message
                return Text('Error: ${snapshot.error}');
              } else {
                // The future completed successfully
                final userList = snapshot.data;
                List<String?> filteredUserList = userList
                        ?.where((user) => (user.role.toLowerCase() ==
                                "volunteer" &&
                            // For now time is abstracted out and only date will be compared
                            taskService.isAvailableWithinDeadline(user, task)))
                        .map((user) => user.username)
                        .toList() ??
                    [];
                filteredUserList.insert(0, "<No volunteer assigned>");
                List<String> newNameList =
                    filteredUserList.map((e) => e!).toList();
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: filteredUserList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(newNameList[index]),
                        onTap: () {
                          task.assignedto = newNameList[index];
                          if (newNameList[index] != "<No volunteer assigned>") {
                            task.status = "Pending";
                          }
                          taskService.updateTask(task);
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  ),
                );
              }
            },
          ));
    },
  );
}
