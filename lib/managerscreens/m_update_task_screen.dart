import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:card_settings/card_settings.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter/cupertino.dart';
import 'package:pawfection/manager_view.dart';
import 'package:pawfection/models/task.dart';
import 'package:pawfection/models/user.dart';
import 'package:pawfection/repository/task_repository.dart';
import 'package:pawfection/volunteerscreens/profile_picture_update_screen.dart';
import 'package:pawfection/volunteerscreens/widgets/profile_widget.dart';

class MUpdateTaskScreen extends StatefulWidget {
  MUpdateTaskScreen({super.key, required this.task});

  Task task;

  @override
  State<MUpdateTaskScreen> createState() => _MUpdateTaskScreenState();
}

class _MUpdateTaskScreenState extends State<MUpdateTaskScreen> {
  final GlobalKey<FormState> _profileKey = GlobalKey<FormState>();
  final formKey = GlobalKey<FormState>();
  final taskRepository = TaskRepository();
  late var _form;
  late var alertmessage;
  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Update Task'),
          elevation: 4.0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                FastForm(
                  formKey: formKey,
                  inputDecorationTheme: InputDecorationTheme(
                    disabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey[700]!, width: 1),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(width: 2),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red[500]!, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  children: _buildForm(context),
                  onChanged: (value) {
                    // ignore: avoid_print
                    print('Form changed: ${value.toString()}');
                    _form = value;

                    if (_form['walking']) {}
                  },
                ),
                ElevatedButton(
                  child: const Text('Update'),
                  onPressed: () {
                    try {
                      taskRepository.updateTask(Task(_form['name'],
                          createdby: 'soo',
                          assignedto: 'soo',
                          description: _form['description'],
                          status: 'Pending',
                          resources: _form['resources'],
                          contactperson: _form['contactperson'],
                          contactpersonnumber: _form['contactpersonnumber'],
                          deadline: [
                            _form['deadlinestart'],
                            _form['deadlineend']
                          ],
                          pet: 'Truffle'));
                      setState(() {
                        alertmessage = 'Task has successfully been updated';
                      });
                    } catch (e) {
                      setState(() {
                        alertmessage = 'Please ensure all fields are filled in';
                      });
                    } finally {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Update Task'),
                          content: Text(alertmessage),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => {
                                Navigator.pop(context, 'OK'),
                                if (alertmessage ==
                                    'Task has successfully been updated')
                                  {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => ManagerView(
                                                tab: 1,
                                              )),
                                    )
                                  }
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      );
    } else if (Platform.isIOS) {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(middle: Text('Update Task')),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                FastForm(
                  adaptive: true,
                  formKey: formKey,
                  children: _buildCupertinoForm(context),
                  onChanged: (value) {
                    // ignore: avoid_print
                    print('Form changed: ${value.toString()}');
                    _form = value;
                  },
                ),
                CupertinoButton(
                  child: const Text('Update'),
                  onPressed: () {
                    try {
                      taskRepository.updateTask(Task(_form['name'],
                          createdby: 'soo',
                          assignedto: 'soo',
                          description: _form['description'],
                          status: 'Pending',
                          resources: _form['resources'],
                          contactperson: _form['contactperson'],
                          contactpersonnumber: _form['contactnumber'],
                          deadline: [
                            _form['deadlinestart'],
                            _form['deadlineend']
                          ],
                          pet: 'Truffle'));
                      setState(() {
                        alertmessage = 'Task has successfully been updated';
                      });
                    } catch (e) {
                      debugPrint(e.toString());
                      setState(() {
                        alertmessage = 'Please ensure all fields are filled in';
                      });
                    } finally {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Create Task'),
                          content: Text(alertmessage),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => {
                                Navigator.pop(context, 'OK'),
                                if (alertmessage ==
                                    'Task has successfully been updated')
                                  {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => ManagerView(
                                                tab: 1,
                                              )),
                                    )
                                  }
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Column();
  }

  List<Widget> _buildForm(BuildContext context) {
    return [
      FastFormSection(
        padding: const EdgeInsets.all(16.0),
        header: const Padding(
          padding: EdgeInsets.all(12.0),
          child: Text(
            'Task Details',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        children: [
          FastTextField(
            name: 'name',
            placeholder: widget.task.name,
            labelText: 'Name',
            validator: Validators.compose([
              Validators.required((value) => 'Field is required'),
            ]),
          ),
          FastTextField(
            name: 'description',
            placeholder: widget.task.description,
            labelText: 'Description',
            validator: Validators.compose([
              Validators.required((value) => 'Field is required'),
            ]),
          ),
          FastTextField(
            name: 'resources',
            labelText: 'Resources',
            validator: Validators.compose([
              Validators.required((value) => 'Field is required'),
            ]),
          ),
          FastTextField(
            name: 'contactperson',
            placeholder: widget.task.contactperson,
            labelText: 'Contact Person',
            validator: Validators.compose([
              Validators.required((value) => 'Field is required'),
            ]),
          ),
          FastTextField(
            name: 'contactnumber',
            placeholder: widget.task.contactpersonnumber,
            labelText: 'Contact Number',
            validator: Validators.compose([
              Validators.required((value) => 'Field is required'),
            ]),
          ),
          FastCalendar(
            name: 'deadlinestart',
            initialValue: DateTime.fromMicrosecondsSinceEpoch(
                widget.task.deadline.elementAt(0)!.microsecondsSinceEpoch),
            labelText: 'Deadline Start',
            firstDate: DateTime(2023),
            lastDate: DateTime(2040),
          ),
          FastCalendar(
            name: 'deadlineend',
            initialValue: DateTime.fromMicrosecondsSinceEpoch(
                widget.task.deadline.elementAt(1)!.microsecondsSinceEpoch),
            labelText: 'Deadline End',
            firstDate: DateTime(2023),
            lastDate: DateTime(2040),
          ),
          ElevatedButton(child: Text('Assign Pet'), onPressed: () {}),
          ElevatedButton(child: Text('Assign Volunteer'), onPressed: () {}),
        ],
      ),
    ];
  }

  List<Widget> _buildCupertinoForm(BuildContext context) {
    return [
      FastFormSection(
        adaptive: true,
        insetGrouped: true,
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        header: const Text('Task Details'),
        children: [
          FastTextField(
            name: 'name',
            placeholder: widget.task.name,
            labelText: 'Name',
            validator: Validators.compose([
              Validators.required((value) => 'Field is required'),
            ]),
          ),
          FastTextField(
            name: 'description',
            placeholder: widget.task.description,
            labelText: 'Description',
            validator: Validators.compose([
              Validators.required((value) => 'Field is required'),
            ]),
          ),
          FastTextField(
            name: 'resources',
            labelText: 'Resources',
            validator: Validators.compose([
              Validators.required((value) => 'Field is required'),
            ]),
          ),
          FastTextField(
            placeholder: widget.task.contactperson,
            name: 'contactperson',
            labelText: 'Contact Person',
            validator: Validators.compose([
              Validators.required((value) => 'Field is required'),
            ]),
          ),
          FastTextField(
            placeholder: widget.task.contactpersonnumber,
            name: 'contactnumber',
            labelText: 'Contact Number',
            validator: Validators.compose([
              Validators.required((value) => 'Field is required'),
            ]),
          ),
          FastDatePicker(
            name: 'deadlinestart',
            initialValue: DateTime.fromMicrosecondsSinceEpoch(
                widget.task.deadline.elementAt(0)!.microsecondsSinceEpoch),
            firstDate: DateTime(2023),
            lastDate: DateTime(2040),
            labelText: 'Start',
            mode: CupertinoDatePickerMode.dateAndTime,
          ),
          FastDatePicker(
            name: 'deadlineend',
            initialValue: DateTime.fromMicrosecondsSinceEpoch(
                widget.task.deadline.elementAt(1)!.microsecondsSinceEpoch),
            firstDate: DateTime(2023),
            lastDate: DateTime(2040),
            labelText: 'Deadline',
            mode: CupertinoDatePickerMode.dateAndTime,
          ),
          CupertinoButton(child: Text('Assign Pet'), onPressed: () {}),
          CupertinoButton(child: Text('Assign Volunteer'), onPressed: () {}),
        ],
      ),
    ];
  }
}
