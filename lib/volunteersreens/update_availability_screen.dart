import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UpdateAvailability extends StatefulWidget {
  const UpdateAvailability({Key? key}) : super(key: key);

  @override
  State<UpdateAvailability> createState() => _UpdateAvailabilityState();
}

class _UpdateAvailabilityState extends State<UpdateAvailability> {
  final GlobalKey<FormState> _dateKey = GlobalKey<FormState>();
  List<DateTime?> _date = [
    DateTime.now()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
        body: Material(
            child: CalendarDatePicker2(
            config: CalendarDatePicker2Config(
            calendarType: CalendarDatePicker2Type.multi,
            ),
            value: _date,
            onValueChanged: (dates) => _date = dates,
            )
        )
    );
  }
}
