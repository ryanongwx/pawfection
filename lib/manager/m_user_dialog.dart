import 'package:flutter/material.dart';
import 'package:pawfection/models/user.dart';
import 'package:pawfection/repository/user_repository.dart';
import 'package:pawfection/service/user_service.dart';

Future<void> displayUserItemDialog(BuildContext context, String id) async {
  final userRepository = UserRepository(true);
  final userService = UserService(true);
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: FutureBuilder<User?>(
          future: userService.findUserByUUID(id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final user = snapshot.data;

              if (user == null) {
                return const Text('Error retrieving user details');
              } else {
                return Stack(
                  alignment: Alignment.topRight,
                  children: [
                    ListView(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: ClipOval(
                            child: Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(user.profilepicture),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(30),
                          child: Center(
                            child: Text(
                              user.username,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 48),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Role: ${user.role}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 48),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Contact Number: ${user.contactnumber}',
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
                                  'Bio',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  user.bio,
                                  style: const TextStyle(
                                      fontSize: 16, height: 1.4),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 48),
                                child: const Text(
                                  'Preferences',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 48),
                                height: 100,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: user.preferences.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Chip(
                                          label: Text(
                                              '${user.preferences[index]}'),
                                        ));
                                  },
                                ),
                              )
                            ]),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 48),
                                child: const Text(
                                  'Experiences',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 48),
                                height: 100,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: user.experiences.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Chip(
                                          label: Text(
                                              '${user.experiences[index]}'),
                                        ));
                                  },
                                ),
                              )
                            ]),
                        Padding(
                          padding: const EdgeInsets.all(30),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Return'),
                          ),
                        )
                      ],
                    ),

                    // Add this Padding at the end of your ListView
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
                            userService.deleteUser(user);
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    ),
                  ],
                );
              }
            }
          },
        ),
      );
    },
  );
}
