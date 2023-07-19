import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pawfection/models/user.dart';
import 'package:pawfection/repository/user_repository.dart';
import 'package:pawfection/service/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;

class UpdateAvailability extends StatefulWidget {
  UpdateAvailability({Key? key, required this.user}) : super(key: key);

  User user;

  @override
  State<UpdateAvailability> createState() => _UpdateAvailabilityState();
}

class _UpdateAvailabilityState extends State<UpdateAvailability> {
  final GlobalKey<FormState> _dateKey = GlobalKey<FormState>();
  late List<DateTime?> _date;
  final userRepository = UserRepository(true);
  final userService = UserService(true);

  final FirebaseAuth.FirebaseAuth _auth = FirebaseAuth.FirebaseAuth.instance;
  late FirebaseAuth.User currentUser;
  late User? user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentUser = _auth.currentUser!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Available Dates"),
        ),
        body: Column(children: [
          FutureBuilder<User?>(
            future: userService.findUserByUUID(currentUser.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // While waiting for the future to complete, show a loading indicator
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                // If an error occurs while fetching the user, display an error message
                return Text('Error: ${snapshot.error}');
              } else {
                final user = snapshot.data;
                return CalendarDatePicker2(
                  config: CalendarDatePicker2Config(
                    calendarType: CalendarDatePicker2Type.multi,
                  ),
                  value: user!.availabledates
                      .map((e) => DateTime.fromMicrosecondsSinceEpoch(
                          e!.microsecondsSinceEpoch))
                      .toList(),
                  onValueChanged: (dates) {
                    user.availabledates =
                        dates.map((e) => Timestamp.fromDate(e!)).toList();
                    userService.updateUser(user);
                  },
                );
              }
            },
          ),
        ]));
  }
}
