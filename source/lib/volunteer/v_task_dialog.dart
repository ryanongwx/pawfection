import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pawfection/manager/m_pet_screen.dart';
import 'package:pawfection/models/task.dart';
import 'package:pawfection/manager/m_user_dialog.dart' as UserDialog;
import 'package:pawfection/manager/m_pet_dialog.dart' as PetDialog;
import 'package:pawfection/service/pet_service.dart';
import 'package:pawfection/service/task_service.dart';
import 'package:pawfection/service/user_service.dart';
import 'package:pawfection/volunteer/v_complete_task_dialog.dart';

Future<void> displayTaskItemDialog(BuildContext context, String id) async {
  final taskService = TaskService(FirebaseFirestore.instance);
  final userService = UserService(FirebaseFirestore.instance);
  final petService = PetService(FirebaseFirestore.instance);

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
                            task.feedback != null
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 30),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 48),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Feedback',
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(task.feedback!),
                                        ],
                                      ),
                                    ),
                                  )
                                : Column(),
                            task.pet != null
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 30),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 48),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Pet',
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          FutureBuilder(
                                            future: petService
                                                .findPetByPetID(task.pet!),
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
                                                final pet = snapshot.data;

                                                return (pet == null
                                                    ? const Text(
                                                        'No Pet Assigned')
                                                    : ListTile(
                                                        onTap: () {
                                                          PetDialog
                                                              .displayPetItemDialog(
                                                                  context,
                                                                  task.pet!);
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
                                                        leading: ClipOval(
                                                          child: Material(
                                                            color: Colors
                                                                .transparent,
                                                            child: Ink.image(
                                                              image: Image.network(
                                                                      pet.profilepicture)
                                                                  .image,
                                                              fit: BoxFit.cover,
                                                              width: 40,
                                                              height: 40,
                                                            ),
                                                          ),
                                                        ),
                                                        title: Text(
                                                          pet.name,
                                                          style:
                                                              const TextStyle(
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
                                  )
                                : Column(),
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
                                    task.resources.isEmpty
                                        ? Container(
                                            height: 20,
                                            child: Text('None'),
                                          ) // No empty space when the list is empty
                                        : Container(
                                            height:
                                                200, // Set the desired height for the scroll view
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: task.resources.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                final imageUrl =
                                                    task.resources[index];

                                                return GestureDetector(
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return Dialog(
                                                          child: Stack(
                                                            children: [
                                                              FittedBox(
                                                                fit: BoxFit
                                                                    .cover,
                                                                child: Image
                                                                    .network(
                                                                  imageUrl,
                                                                ),
                                                              ),
                                                              Positioned(
                                                                top: 10,
                                                                right: 10,
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                                  child:
                                                                      IconButton(
                                                                    icon: const Icon(
                                                                        Icons
                                                                            .close),
                                                                    color: Colors
                                                                        .white,
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 10),
                                                    child: Image.network(
                                                      imageUrl!,
                                                      width:
                                                          150, // Set the desired width for the photos
                                                      height:
                                                          200, // Set the desired height for the photos
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
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
                                                    leading: ClipOval(
                                                      child: Material(
                                                        color:
                                                            Colors.transparent,
                                                        child: Ink.image(
                                                          image: Image.network(user
                                                                  .profilepicture)
                                                              .image,
                                                          fit: BoxFit.cover,
                                                          width: 40,
                                                          height: 40,
                                                        ),
                                                      ),
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
                                                  leading: ClipOval(
                                                    child: Material(
                                                      color: Colors.transparent,
                                                      child: Ink.image(
                                                        image: Image.network(user
                                                                .profilepicture)
                                                            .image,
                                                        fit: BoxFit.cover,
                                                        width: 40,
                                                        height: 40,
                                                      ),
                                                    ),
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
                                                  leading: ClipOval(
                                                    child: Material(
                                                      color: Colors.transparent,
                                                      child: Ink.image(
                                                        image: Image.network(user
                                                                .profilepicture)
                                                            .image,
                                                        fit: BoxFit.cover,
                                                        width: 40,
                                                        height: 40,
                                                      ),
                                                    ),
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
                            task.status == 'Pending'
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        right: 30, left: 30, top: 10),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        displayCompleteTaskDialog(
                                            context, task.referenceId!);
                                      },
                                      child: const Text('Complete'),
                                    ),
                                  )
                                : const Column(),
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
                      ],
                    );
            }
          },
        ),
      );
    },
  );
}
