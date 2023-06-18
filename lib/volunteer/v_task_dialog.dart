import 'package:flutter/material.dart';
import 'package:pawfection/volunteer/v_complete_task_dialog.dart';
import 'package:pawfection/manager/m_update_task_screen.dart';
import 'package:pawfection/models/task.dart';
import 'package:pawfection/models/user.dart';
import 'package:pawfection/repository/task_repository.dart';
import 'package:pawfection/repository/user_repository.dart';
import 'package:pawfection/volunteer/widgets/profile_widget.dart';
import 'package:pawfection/manager/m_user_dialog.dart' as UserDialog;
import 'package:pawfection/manager/m_pet_dialog.dart' as PetDialog;

Future<void> displayTaskItemDialog(BuildContext context, String id) async {
  final taskRepository = TaskRepository();
  final userRepository = UserRepository();
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: FutureBuilder<Task?>(
          future: taskRepository.findTaskByTaskID(id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // While waiting for the future to complete, show a loading indicator
              return CircularProgressIndicator();
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
                      physics: BouncingScrollPhysics(),
                      children: [
                        Padding(
                          padding: EdgeInsets.all(30),
                          child: Center(
                            child: Text(
                              "${task.name}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 48),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                  child: Text(
                                '${task.status}',
                                style: TextStyle(
                                  color: task.status == 'Pending'
                                      ? Color.fromARGB(255, 194, 173, 77)
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
                          padding: EdgeInsets.symmetric(horizontal: 48),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${task.deadline.map((timestamp) => DateTime.fromMicrosecondsSinceEpoch(timestamp!.microsecondsSinceEpoch)).elementAt(0)} - ${task.deadline.map((timestamp) => DateTime.fromMicrosecondsSinceEpoch(timestamp!.microsecondsSinceEpoch)).elementAt(1)}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 48),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Description',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "${task.description}",
                                  style: TextStyle(fontSize: 16, height: 1.4),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 48),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Resources',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "${task.resources}",
                                  style: TextStyle(fontSize: 16, height: 1.4),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 48),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Assigned to',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                FutureBuilder(
                                  future: task != null
                                      ? userRepository
                                          .findUserByUUID(task.assignedto)
                                      : null,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      // While waiting for the future to complete, show a loading indicator
                                      return CircularProgressIndicator();
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
                                                        task.assignedto);
                                              },
                                              tileColor: Colors.grey[200],
                                              shape: RoundedRectangleBorder(
                                                  side: BorderSide(width: 2),
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
                          padding: EdgeInsets.only(top: 30),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 48),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Created By',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                FutureBuilder(
                                  future: task != null
                                      ? userRepository
                                          .findUserByUUID(task.createdby)
                                      : null,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      // While waiting for the future to complete, show a loading indicator
                                      return CircularProgressIndicator();
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
                                                  side: BorderSide(width: 2),
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
                          padding: EdgeInsets.only(top: 30),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 48),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Contact Person',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                FutureBuilder(
                                  future: task != null
                                      ? userRepository
                                          .findUserByUUID(task.contactperson)
                                      : null,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      // While waiting for the future to complete, show a loading indicator
                                      return CircularProgressIndicator();
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
                                                  side: BorderSide(width: 2),
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
                              EdgeInsets.only(right: 30, left: 30, top: 10),
                          child: ElevatedButton(
                            onPressed: () {
                              displayCompleteTaskDialog(
                                  context, task.referenceId!);
                            },
                            child: Text('Complete'),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              right: 30, left: 30, top: 10, bottom: 30),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Return'),
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
