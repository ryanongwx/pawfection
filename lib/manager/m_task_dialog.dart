import 'package:flutter/material.dart';
import 'package:pawfection/manager/m_update_task_screen.dart';
import 'package:pawfection/manager_view.dart';
import 'package:pawfection/models/task.dart';
import 'package:pawfection/models/user.dart';
import 'package:pawfection/manager/m_user_dialog.dart' as UserDialog;
import 'package:pawfection/service/task_service.dart';
import 'package:pawfection/service/user_service.dart';

Future<void> displayTaskItemDialog(BuildContext context, String id) async {
  final taskService = TaskService();
  final userService = UserService();

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
                  ? const Text('Error task details')
                  : Stack(
                      alignment: Alignment.topRight,
                      children: [
                        ListView(
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 48),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                      child: Text(
                                    task.status,
                                    style: TextStyle(
                                      color: task.status == 'Pending'
                                          ? const Color.fromARGB(
                                              255, 194, 173, 77)
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 48),
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 48),
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 48),
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 48),
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
                                    if (task.assignedto != null)
                                      FutureBuilder(
                                        future: userService
                                            .findUserByUUID(task.assignedto!),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            // While waiting for the future to complete, show a loading indicator
                                            return const CircularProgressIndicator();
                                          } else if (snapshot.hasError) {
                                            // If an error occurs while fetching the user, display an error message
                                            return Text(
                                                'Error: ${snapshot.error}');
                                          } else {
                                            // The future completed successfully
                                            final user = snapshot.data;

                                            return (user == null
                                                ? const Text(
                                                    'Task not assigned to any volunteers')
                                                : ListTile(
                                                    onTap: () {
                                                      UserDialog
                                                          .displayUserItemDialog(
                                                              context,
                                                              task.assignedto!);
                                                    },
                                                    tileColor: Colors.grey[200],
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            side:
                                                                const BorderSide(
                                                                    width: 2),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                    leading: const Icon(
                                                      Icons.account_circle,
                                                      color: Colors.black,
                                                    ),
                                                    title: Text(
                                                      user.username,
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 48),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'User Requests',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    FutureBuilder(
                                      future: userService
                                          .findUserByUUIDs(task.requests),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          // While waiting for the future to complete, show a loading indicator
                                          return const CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          // If an error occurs while fetching the user, display an error message
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        } else {
                                          // The future completed successfully
                                          final users = snapshot.data;

                                          return ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: users!.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              User? user = users[index];
                                              debugPrint(
                                                  users[index].toString());
                                              return (user == null
                                                  ? const Text(
                                                      'User not logged in')
                                                  // Can add this logic if need to cancel the assigned person with the cross
                                                  // : user.referenceId ==
                                                  //         task.assignedto
                                                  //     ? ListTile(
                                                  //         onTap: () {
                                                  //           UserDialog
                                                  //               .displayUserItemDialog(
                                                  //                   context,
                                                  //                   task.createdby);
                                                  //         },
                                                  //         tileColor:
                                                  //             Colors.grey[200],
                                                  //         shape: RoundedRectangleBorder(
                                                  //             side:
                                                  //                 const BorderSide(
                                                  //                     width: 2),
                                                  //             borderRadius:
                                                  //                 BorderRadius
                                                  //                     .circular(
                                                  //                         20)),
                                                  //         leading: const Icon(
                                                  //           Icons
                                                  //               .account_circle,
                                                  //           color: Colors.black,
                                                  //         ),
                                                  //         title: Text(
                                                  //           user.username,
                                                  //           style:
                                                  //               const TextStyle(
                                                  //             color:
                                                  //                 Colors.black,
                                                  //             fontWeight:
                                                  //                 FontWeight
                                                  //                     .bold,
                                                  //           ),
                                                  //         ),
                                                  //         trailing: IconButton(
                                                  //           icon: Icon(
                                                  //               Icons.close),
                                                  //           onPressed: () {
                                                  //             task.assignedto =
                                                  //                 '';
                                                  //             task.status =
                                                  //                 'Open';
                                                  //             taskRepository
                                                  //                 .updateTask(
                                                  //                     task);
                                                  //           },
                                                  //         ),
                                                  //       )
                                                  : ListTile(
                                                      onTap: () {
                                                        UserDialog
                                                            .displayUserItemDialog(
                                                                context,
                                                                task.createdby);
                                                      },
                                                      tileColor:
                                                          Colors.grey[200],
                                                      shape: RoundedRectangleBorder(
                                                          side:
                                                              const BorderSide(
                                                                  width: 2),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20)),
                                                      leading: const Icon(
                                                        Icons.account_circle,
                                                        color: Colors.black,
                                                      ),
                                                      title: Text(
                                                        user.username,
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      trailing: IconButton(
                                                        icon: const Icon(
                                                            Icons.check),
                                                        onPressed: () {
                                                          showDialog<String>(
                                                              context: context,
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  AlertDialog(
                                                                    title: const Text(
                                                                        'Assign Task'),
                                                                    content: Text(
                                                                        'Assign Task to ${user.username}?'),
                                                                    actions: <Widget>[
                                                                      TextButton(
                                                                        onPressed: () => Navigator.pop(
                                                                            context,
                                                                            'Cancel'),
                                                                        child: const Text(
                                                                            'Cancel'),
                                                                      ),
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context,
                                                                              'OK');
                                                                          task.assignedto =
                                                                              user.referenceId;
                                                                          task.status =
                                                                              'Pending';
                                                                          taskService
                                                                              .updateTask(task);
                                                                          Navigator.of(context)
                                                                              .pushReplacement(
                                                                            MaterialPageRoute(
                                                                                builder: (context) => const ManagerView(
                                                                                      tab: 1,
                                                                                    )),
                                                                          );
                                                                        },
                                                                        child: const Text(
                                                                            'OK'),
                                                                      ),
                                                                    ],
                                                                  ));
                                                        },
                                                      ),
                                                    ));
                                            },
                                          );
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 48),
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
                                      future: userService
                                          .findUserByUUID(task.createdby),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          // While waiting for the future to complete, show a loading indicator
                                          return const CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          // If an error occurs while fetching the user, display an error message
                                          return Text(
                                              'Error: ${snapshot.error}');
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
                                                      side: const BorderSide(
                                                          width: 2),
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
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 48),
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
                                      future: userService
                                          .findUserByUUID(task.contactperson),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          // While waiting for the future to complete, show a loading indicator
                                          return const CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          // If an error occurs while fetching the user, display an error message
                                          return Text(
                                              'Error: ${snapshot.error}');
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
                                                      side: const BorderSide(
                                                          width: 2),
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
                                                      fontWeight:
                                                          FontWeight.bold,
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
                              padding: const EdgeInsets.only(
                                  right: 30, left: 30, top: 20),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => MUpdateTaskScreen(
                                              task: task,
                                            )),
                                  );
                                },
                                child: const Text('Edit'),
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
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Confirm Delete"),
                                  content: const Text(
                                      "Are you sure you want to delete this user?"),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text("Cancel"),
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                    ),
                                    TextButton(
                                      child: const Text("Delete"),
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      },
                                    ),
                                  ],
                                ),
                              );

                              if (confirmed ?? false) {
                                taskService.deleteTask(task);
                                Navigator.of(context).pop();
                              }
                            },
                          ),
                        ),
                      ],
                    );
            }
          },
        ),
      );
    },
  );
}
