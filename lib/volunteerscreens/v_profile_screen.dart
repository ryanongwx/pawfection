import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pawfection/services/data_repository.dart';
import 'package:pawfection/models/user.dart';
import 'package:pawfection/volunteerscreens/profile_picture_update_screen.dart';
import 'package:pawfection/volunteerscreens/profile_update_screen.dart';
import 'package:pawfection/volunteerscreens/update_availability_screen.dart';
import 'package:pawfection/volunteerscreens/widgets/button_widget.dart';
import 'package:pawfection/volunteerscreens/widgets/numbers_widget.dart';
import 'package:pawfection/volunteerscreens/widgets/profile_widget.dart';
import 'package:pawfection/volunteerscreens/widgets/textfield_widget.dart';
import 'package:pawfection/volunteerscreens/profile_update_screen.dart';

class VProfileScreen extends StatefulWidget {
  VProfileScreen({Key? key, this.imagePath = 'assets/images/user_profile.png'})
      : super(key: key);

  String imagePath;

  @override
  State<VProfileScreen> createState() => _VProfileScreenState();
}

class _VProfileScreenState extends State<VProfileScreen> {
  final DataRepository repository = DataRepository();
  FirebaseAuth.FirebaseAuth _auth = FirebaseAuth.FirebaseAuth.instance;
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
        appBar: AppBar(title: const Text("My Profile")),
        body: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Builder(
                builder: (context) => Expanded(
                  // Wrap ListView with Expanded widget
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: [
                      ProfileWidget(
                        imagePath: widget.imagePath,
                        onClicked: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    ProfilePictureUpdateScreen(
                                        routetext: 'profile')),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      buildName(),
                      const SizedBox(height: 24),
                      Center(child: buildUpgradeButton1()),
                      Center(child: buildUpgradeButton2()),
                      const SizedBox(height: 48),
                      buildAbout(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget buildUpgradeButton1() => ButtonWidget(
        text: 'Update Profile',
        onClicked: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VProfileUpdateScreen(),
            ),
          );
        },
      );

  Widget buildUpgradeButton2() => ButtonWidget(
        text: 'Update Availability',
        onClicked: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const UpdateAvailability(),
            ),
          );
        },
      );

  Widget buildName() => FutureBuilder<User?>(
        future: repository.findUserByUUID(currentUser.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
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
                : Center(
                    child: Text("${user.username}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24))));
          }
        },
      );

  Widget buildAbout() => FutureBuilder<User?>(
        future: repository.findUserByUUID(currentUser.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
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
                : Container(
                    padding: EdgeInsets.symmetric(horizontal: 48),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'About',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "${user.bio}",
                          style: TextStyle(fontSize: 16, height: 1.4),
                        ),
                      ],
                    ),
                  ));
          }
        },
      );
}
