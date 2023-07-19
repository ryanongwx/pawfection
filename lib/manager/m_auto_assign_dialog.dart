import 'package:flutter/material.dart';
import 'package:pawfection/models/pet.dart';
import 'package:pawfection/service/functions_service.dart';
import 'package:pawfection/service/pet_service.dart';

import '../models/user.dart';

class AutoAssignDialog extends StatefulWidget {
  final BuildContext parentContext;

  const AutoAssignDialog({Key? key, required this.parentContext})
      : super(key: key);

  @override
  _AutoAssignDialogState createState() => _AutoAssignDialogState();
}

class _AutoAssignDialogState extends State<AutoAssignDialog> {
  final functionService = FunctionService();
  final petService = PetService();

  Map<String, User?> selectedUserVolunteers = {};

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(children: [
      const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Confirmation Page',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      FutureBuilder<Map<String, dynamic>>(
        future: functionService.autoAssign(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            debugPrint('Error: ${snapshot.error}');
            return Text('Error: ${snapshot.error}');
          } else {
            final tasks = snapshot.data!['tasks'];
            final volunteers = snapshot.data!['volunteers'];

            return ListView.builder(
              shrinkWrap: true,
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                final volunteerIds =
                    ["<No volunteer assigned>"] + volunteers[task.referenceId];
                final assignedTo = task.assignedto;

                // Fetch the users for this task's volunteerIds
                return FutureBuilder<List<User>>(
                  future: userService.findUserByUUIDs(volunteerIds),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (userSnapshot.hasError) {
                      debugPrint('Error: ${userSnapshot.error}');
                      return Text('Error: ${userSnapshot.error}');
                    } else {
                      final volunteerList = userSnapshot.data!;
                      // Initialize selectedUserVolunteers for this task
                      if (!selectedUserVolunteers
                          .containsKey(task.referenceId)) {
                        final initiallyAssignedUser = volunteerList.firstWhere(
                            (user) => user.referenceId == assignedTo);
                        selectedUserVolunteers[task.referenceId] =
                            initiallyAssignedUser;
                      }

                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              if (task.pet != null)
                                FutureBuilder<Pet?>(
                                  future: petService.findPetByPetID(task.pet),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      debugPrint('Error: ${snapshot.error}');
                                      return const Icon(Icons.error);
                                    } else if (snapshot.hasData &&
                                        snapshot.data != null) {
                                      return ClipOval(
                                        child: Image.network(
                                          snapshot.data!.profilepicture,
                                          width: 30,
                                          height: 30,
                                          fit: BoxFit
                                              .cover, // Use BoxFit.cover to ensure the image fills the circle
                                        ),
                                      );
                                    } else {
                                      return const SizedBox
                                          .shrink(); // Return an empty box if no pet data
                                    }
                                  },
                                ),
                              const SizedBox(width: 10),
                              Expanded(
                                flex: 1,
                                child: Tooltip(
                                  message: '${task.name}:',
                                  child: Text(
                                    '${task.name}:',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: DropdownButton<User?>(
                                  value:
                                      selectedUserVolunteers[task.referenceId],
                                  icon: const Icon(Icons.arrow_downward),
                                  iconSize: 24,
                                  elevation: 16,
                                  onChanged: (User? newValue) {
                                    setState(() {
                                      selectedUserVolunteers[task.referenceId] =
                                          newValue!;
                                    });
                                  },
                                  items: <DropdownMenuItem<User?>>[
                                    const DropdownMenuItem<User?>(
                                      value: null,
                                      child: Text("<No volunteer assigned>"),
                                    ), ...volunteerList.map<DropdownMenuItem<User?>>((User user) {
                                    return DropdownMenuItem<User?>(
                                      value: user,
                                      child: Row(
                                        children: <Widget>[
                                          // Clip the profile picture as a circle
                                          ClipOval(
                                            child: Image.network(
                                              user.profilepicture,
                                              width: 30,
                                              height: 30,
                                              fit: BoxFit.cover, // Use BoxFit.cover to ensure the image fills the circle
                                            ),
                                          ),
                                          // Add some spacing between the picture and the username
                                          const SizedBox(width: 10),
                                          // Display username
                                          Tooltip(
                                            message: user.username,
                                            child: Text(
                                              user.username,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  ],
                                ),
                              ),
                            ],
                          ));
                    }
                  },
                );
              },
            );
          }
        },
      ),
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: ElevatedButton(
          onPressed: () {
            print(
                "Confirm button pressed!"); // You can replace this with your own function
          },
          child: const Text("Confirm"),
        ),
      ),
    ]));
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
