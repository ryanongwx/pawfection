import 'package:flutter/material.dart';
import 'package:pawfection/volunteer/v_complete_task_dialog.dart';
import 'package:pawfection/models/task.dart';
import 'package:pawfection/repository/task_repository.dart';
import 'package:pawfection/repository/user_repository.dart';
import 'package:pawfection/manager/m_user_dialog.dart' as UserDialog;

Future<void> displayTaskItemDialog(BuildContext context, String id) async {
  final taskRepository = TaskRepository();
  final userRepository = UserRepository();
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: FutureBuilder<Task?>(
          future: taskRepository.findTaskByTaskID(id),
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
                              Center(
                                  child: Text(
                                task.status,
                                style: TextStyle(
                                  color: task.status == 'Pending'
                                      ? const Color.fromARGB(255, 194, 173, 77)
                                      : task.status == 'Open'
                                          ? Colors.grey[400]
                                          : Colors.green,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                            ],
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
                                  style: const TextStyle(fontSize: 16, height: 1.4),
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
                                  'Resources',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "${task.resources}",
                                  style: const TextStyle(fontSize: 16, height: 1.4),
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
                                  'Assigned to',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                FutureBuilder(
                                  future: task.assignedto != null
                                      ? userRepository
                                          .findUserByUUID(task.assignedto!)
                                      : null,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      // While waiting for the future to complete, show a loading indicator
                                      return const CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      // If an error occurs while fetching the user, display an error message
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      // The future completed successfully
                                      final user = snapshot.data;

                                      return (user == null
                                          ? const Text('Task not assigned to any volunteers')
                                          : ListTile(
                                              onTap: () {
                                                UserDialog
                                                    .displayUserItemDialog(
                                                        context,
                                                        task.assignedto!);
                                              },
                                              tileColor: Colors.grey[200],
                                              shape: RoundedRectangleBorder(
                                                  side: const BorderSide(width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              leading: const Icon(
                                                Icons.account_circle,
                                                color: Colors.black,
                                              ),
                                              title: Text(
                                                user.username,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ));
                                    }
                                  },
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
                                  'Created By',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                FutureBuilder(
                                  future: userRepository
                                          .findUserByUUID(task.createdby),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      // While waiting for the future to complete, show a loading indicator
                                      return const CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      // If an error occurs while fetching the user, display an error message
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      // The future completed successfully
                                      final user = snapshot.data;

                                      return (user == null
                                          ? const Text('User not logged in')
                                          : ListTile(
                                              onTap: () {
                                                UserDialog
                                                    .displayUserItemDialog(
                                                        context,
                                                        task.createdby);
                                              },
                                              tileColor: Colors.grey[200],
                                              shape: RoundedRectangleBorder(
                                                  side: const BorderSide(width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              leading: const Icon(
                                                Icons.account_circle,
                                                color: Colors.black,
                                              ),
                                              title: Text(
                                                user.username,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ));
                                    }
                                  },
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
                                  'Contact Person',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                FutureBuilder(
                                  future: userRepository
                                          .findUserByUUID(task.contactperson),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      // While waiting for the future to complete, show a loading indicator
                                      return const CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      // If an error occurs while fetching the user, display an error message
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      // The future completed successfully
                                      final user = snapshot.data;

                                      return (user == null
                                          ? const Text('User not logged in')
                                          : ListTile(
                                              onTap: () {
                                                UserDialog
                                                    .displayUserItemDialog(
                                                        context,
                                                        task.contactperson);
                                              },
                                              tileColor: Colors.grey[200],
                                              shape: RoundedRectangleBorder(
                                                  side: const BorderSide(width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              leading: const Icon(
                                                Icons.account_circle,
                                                color: Colors.black,
                                              ),
                                              title: Text(
                                                user.username,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ));
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(right: 30, left: 30, top: 10),
                          child: ElevatedButton(
                            onPressed: () {
                              displayCompleteTaskDialog(
                                  context, task.referenceId!);
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
