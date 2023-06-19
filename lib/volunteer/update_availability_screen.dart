import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:card_settings/widgets/information_fields/card_settings_header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pawfection/models/user.dart';
import 'package:pawfection/repository/user_repository.dart';
import 'package:pawfection/voluteer_view.dart';

class UpdateAvailability extends StatefulWidget {
  UpdateAvailability({Key? key, required this.user}) : super(key: key);

  User user;

  @override
  State<UpdateAvailability> createState() => _UpdateAvailabilityState();
}

class _UpdateAvailabilityState extends State<UpdateAvailability> {
  final GlobalKey<FormState> _dateKey = GlobalKey<FormState>();
  List<DateTime?> _date = [DateTime.now()];
  final userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Available Dates"),
          actions: [
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    widget.user.availabledates =
                        _date.map((e) => Timestamp.fromDate(e!)).toList();
                    userRepository.updateUser(widget.user);
                    Navigator.of(context).pop();
                  },
                  child: const Icon(
                    Icons.save,
                    size: 26.0,
                  ),
                )),
          ],
        ),
        body: Column(children: [
          CalendarDatePicker2(
            config: CalendarDatePicker2Config(
              calendarType: CalendarDatePicker2Type.multi,
            ),
            value: _date,
            onValueChanged: (dates) {
              setState(() {
                _date = dates;
              });
              debugPrint('Selected Dates: $_date');
            },
          ),
        ]));
  }
}
