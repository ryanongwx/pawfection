import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:flutter/material.dart';
import 'package:pawfection/models/user.dart';
import 'package:pawfection/service/user_service.dart';
import 'package:pawfection/volunteer/profile_picture_update_screen.dart';
import 'package:pawfection/volunteer/profile_update_screen.dart';
import 'package:pawfection/volunteer/update_availability_screen.dart';
import 'package:pawfection/volunteer/widgets/button_widget.dart';
import 'package:pawfection/volunteer/widgets/profile_widget.dart';
import 'package:pawfection/login_view.dart';

class VProfileScreen extends StatefulWidget {
  VProfileScreen({Key? key}) : super(key: key);

  @override
  State<VProfileScreen> createState() => _VProfileScreenState();
}

class _VProfileScreenState extends State<VProfileScreen> {
  final userService = UserService(FirebaseFirestore.instance);

  final FirebaseAuth.FirebaseAuth _auth = FirebaseAuth.FirebaseAuth.instance;
  late FirebaseAuth.User currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentUser = _auth.currentUser!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("My Profile"), actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              try {
                _auth.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginView()),
                  (Route<dynamic> route) => false,
                );
              } catch (e) {
                debugPrint(e.toString());
              }
            },
          )
        ]),
        body: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Builder(
                builder: (context) => Expanded(
                    // Wrap ListView with Expanded widget
                    child: FutureBuilder<User?>(
                  future: userService.findUserByUUID(currentUser.uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
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
                          : ListView(
                              physics: const BouncingScrollPhysics(),
                              children: [
                                ProfileWidget(
                                  image: Image.network(user.profilepicture),
                                  onClicked: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProfilePictureUpdateScreen(
                                                routetext: 'profile',
                                                petid: '',
                                              )),
                                    );
                                  },
                                ),
                                const SizedBox(height: 24),
                                Center(
                                    child: Text(user.username,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24))),
                                const SizedBox(height: 24),
                                Center(
                                    child: ButtonWidget(
                                  text: 'Update Profile',
                                  onClicked: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            VProfileUpdateScreen(
                                          user: user,
                                        ),
                                      ),
                                    );
                                  },
                                )),
                                Center(
                                    child: ButtonWidget(
                                  text: 'Update Availability',
                                  onClicked: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            UpdateAvailability(user: user),
                                      ),
                                    );
                                  },
                                )),
                                const SizedBox(height: 24),
                                Column(children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 48),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'About',
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          user.bio,
                                          style: const TextStyle(
                                              fontSize: 16, height: 1.4),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                                const SizedBox(height: 24),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 60),
                                        child: const Text(
                                          'Preferences',
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 60),
                                        height: 100,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: user.preferences.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10),
                                                child: Chip(
                                                  label: Text(
                                                      '${user.preferences[index]}'),
                                                ));
                                          },
                                        ),
                                      )
                                    ]),
                                const SizedBox(height: 24),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 60),
                                        child: const Text(
                                          'Experiences',
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 60),
                                        height: 100,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: user.experiences.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10),
                                                child: Chip(
                                                  label: Text(
                                                      '${user.experiences[index]}'),
                                                ));
                                          },
                                        ),
                                      )
                                    ]),
                              ],
                            ));
                    }
                  },
                )),
              ),
            ],
          ),
        ));
  }
}
