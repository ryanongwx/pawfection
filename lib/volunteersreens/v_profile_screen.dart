import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:pawfection/volunteersreens/models/user.dart';
import 'package:pawfection/volunteersreens/profile_picture_update_screen.dart';
import 'package:pawfection/volunteersreens/update_availability_screen.dart';
import 'package:pawfection/volunteersreens/widgets/button_widget.dart';
import 'package:pawfection/volunteersreens/utils/user_accounts.dart';
import 'package:pawfection/volunteersreens/widgets/numbers_widget.dart';
import 'package:pawfection/volunteersreens/widgets/profile_widget.dart';
import 'package:pawfection/volunteersreens/widgets/textfield_widget.dart';
import 'package:pawfection/volunteersreens/profile_update_screen.dart';

class VProfileScreen extends StatefulWidget {
  const VProfileScreen({Key? key}) : super(key: key);

  @override
  State<VProfileScreen> createState() => _VProfileScreenState();
}

class _VProfileScreenState extends State<VProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = UserPreferences.myUser;
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Builder(
            builder: (context) => Expanded(
              // Wrap ListView with Expanded widget
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  ProfileWidget(
                    imagePath: user.imagePath,
                    onClicked: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => ProfilePictureUpdateScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  buildName(user),
                  const SizedBox(height: 24),
                  Center(child: buildUpgradeButton1()),
                  Center(child: buildUpgradeButton2()),
                  const SizedBox(height: 24),
                  NumbersWidget(),
                  const SizedBox(height: 48),
                  buildAbout(user),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Widget buildName(User user) => Column(
        children: [
          Text(
            user.name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      );

  Widget buildUpgradeButton1() => ButtonWidget(
        text: 'Update Profile',
        onClicked: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const VProfileUpdateScreen(),
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

  Widget buildAbout(User user) => Container(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              user.about,
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      );
}
