import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:card_settings/card_settings.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter/cupertino.dart';
import 'package:pawfection/managerView.dart';
import 'package:pawfection/models/task.dart';
import 'package:pawfection/models/pet.dart';
import 'package:pawfection/models/user.dart';
import 'package:pawfection/repository/task_repository.dart';
import 'package:pawfection/volunteerscreens/profile_picture_update_screen.dart';
import 'package:pawfection/volunteerscreens/widgets/profile_widget.dart';

class MCreateTaskScreen extends StatefulWidget {
  MCreateTaskScreen(
      {super.key, this.imagePath = 'assets/images/user_profile.png'});

  String imagePath;

  @override
  State<MCreateTaskScreen> createState() => _MCreateTaskScreenState();
}

class _MCreateTaskScreenState extends State<MCreateTaskScreen> {
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
          title: Text('Create Task'),
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
                  child: const Text('Create'),
                  onPressed: () {
                    try {
                      taskRepository.addTask(Task(_form['name'],
                          createdby: 'soo',
                          assignedto: _form['user'],
                          description: _form['description'],
                          status: _form['user'] == "<No volunteer assigned>"
                              ? 'Open'
                              : 'Pending',
                          resources: [_form['resources']],
                          deadline: [
                            _form['deadlinestart'],
                            _form['deadlineend']
                          ],
                          pet: _form['pet']));
                      setState(() {
                        alertmessage = 'Task has successfully been created';
                      });
                    } catch (e) {
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
                                    'Task has successfully been created')
                                  {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                          const ManagerView(
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
        navigationBar: CupertinoNavigationBar(middle: Text('Create Task')),
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
                  child: const Text('Create'),
                  onPressed: () {
                    try {
                      taskRepository.addTask(Task(_form['name'],
                          createdby: 'soo',
                          assignedto: _form['user'],
                          description: _form['description'],
                          status: _form['user'] == "<No volunteer assigned>"
                              ? 'Open'
                              : 'Pending',
                          resources: [_form['resources']],
                          deadline: [
                            _form['deadlinestart'],
                            _form['deadlineend']
                          ],
                          pet: _form['pet']));
                      setState(() {
                        alertmessage = 'Task has successfully been created';
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
                                    'Task has successfully been created')
                                  {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                          const ManagerView(
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

  // To getPetList
  Widget buildPetList() => FutureBuilder<List<Pet>>(
    future: petRepository.getPetList(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        // While waiting for the future to complete, show a loading indicator
        return CircularProgressIndicator();
      } else if (snapshot.hasError) {
        // If an error occurs while fetching the user, display an error message
        return Text('Error: ${snapshot.error}');
      } else {
        // The future completed successfully
        final petList = snapshot.data;
        List<String> nameList =
            petList?.map((pet) => pet.name).toSet().toList() ?? [];
        nameList.insert(0, "<No pet assigned>");
        return Padding(
            padding: const EdgeInsets.all(16.0),
            child: FastDropdown(
                name: 'pet',
                labelText: 'Pet',
                items: nameList,
                initialValue: nameList[0]));
      }
    },
  );

  // To getUserList
  Widget buildVolunteerList() => FutureBuilder<List<User>>(
    future: userRepository.getUserList(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        // While waiting for the future to complete, show a loading indicator
        return CircularProgressIndicator();
      } else if (snapshot.hasError) {
        // If an error occurs while fetching the user, display an error message
        return Text('Error: ${snapshot.error}');
      } else {
        // The future completed successfully
        final userList = snapshot.data;
        List<String?> nameList = userList
            ?.where((user) => user.role.toLowerCase() == "volunteer")
            .map((user) => user.username)
            .toSet()
            .toList() ??
            [];
        nameList.insert(0, "<No volunteer assigned>");
        return Padding(
            padding: const EdgeInsets.all(16.0),
            child: FastDropdown(
                name: 'user',
                labelText: 'Volunteer',
                items: nameList,
                initialValue: nameList[0]));
      }
    },
  );

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
            labelText: 'Name',
            validator: Validators.compose([
              Validators.required((value) => 'Field is required'),
            ]),
          ),
          FastTextField(
            name: 'description',
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
          FastCalendar(
            name: 'deadlinestart',
            labelText: 'Deadline Start',
            firstDate: DateTime(2023),
            lastDate: DateTime(2040),
          ),
          FastCalendar(
            name: 'deadlineend',
            labelText: 'Deadline End',
            firstDate: DateTime(2023),
            lastDate: DateTime(2040),
          ),
          buildPetList(),
          buildVolunteerList(),
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
            labelText: 'Name',
            validator: Validators.compose([
              Validators.required((value) => 'Field is required'),
            ]),
          ),
          FastTextField(
            name: 'description',
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
          FastDatePicker(
            name: 'deadlinestart',
            firstDate: DateTime(2023),
            lastDate: DateTime(2040),
            labelText: 'Start',
            mode: CupertinoDatePickerMode.dateAndTime,
          ),
          FastDatePicker(
            name: 'deadlineend',
            firstDate: DateTime(2023),
            lastDate: DateTime(2040),
            labelText: 'Deadline',
            mode: CupertinoDatePickerMode.dateAndTime,
          ),
          buildPetList(),
          buildVolunteerList()
        ],
      ),
    ];
  }
}
