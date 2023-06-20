import 'dart:core';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter/cupertino.dart';
import 'package:pawfection/manager_view.dart';
import 'package:pawfection/models/task.dart';
import 'package:pawfection/models/pet.dart';
import 'package:pawfection/models/user.dart';
import 'package:pawfection/repository/pet_repository.dart';
import 'package:pawfection/repository/task_repository.dart';
import 'package:pawfection/repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;

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
  final petRepository = PetRepository();
  final userRepository = UserRepository();

  late var _form;
  late var alertmessage;

  final _auth = FirebaseAuth.FirebaseAuth.instance; // authInstance

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Create Task'),
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
                  },
                ),
                ElevatedButton(
                  child: const Text('Create'),
                  onPressed: () async {
                    try {
                      final User? user =
                          await userRepository.currentUser(_auth);
                      if (user == null) {
                        throw Exception(
                            'Please log into a manager account to create task');
                      }
                      Timestamp deadlinestart = Timestamp.fromDate(DateTime(
                          _form['deadlineend'].year,
                          _form['deadlineend'].month,
                          _form['deadlineend'].day,
                          _form['deadlineendtime'].hour,
                          _form['deadlineendtime'].minute));
                      Timestamp deadlineend = Timestamp.fromDate(DateTime(
                          _form['deadlinestart'].year,
                          _form['deadlinestart'].month,
                          _form['deadlinestart'].day,
                          _form['deadlinestarttime'].hour,
                          _form['deadlinestarttime'].minute));

                      String? assignedUserId;
                      if (_form['user'] != "<No volunteer assigned>") {
                        User? assignedUser = await userRepository.findUserByUsername(_form['user']);
                        assignedUserId = assignedUser!.referenceId;
                      } else {
                        assignedUserId = null;
                      }

                      taskRepository.addTask(Task(_form['name'],
                          createdby: user.referenceId,
                          assignedto: assignedUserId,
                          description: _form['description'],
                          status: _form['user'] == "<No volunteer assigned>"
                              ? 'Open'
                              : 'Pending',
                          resources: [_form['resources']],
                          deadline: [deadlinestart, deadlineend],
                          requests: [],
                          pet: _form['pet'],
                          contactperson: user.referenceId,
                          contactpersonnumber: user.contactnumber));
                      setState(() {
                        alertmessage = 'Task has successfully been created';
                      });
                    } on Exception catch (e) {
                      // If the exception thrown is a general Exception
                      setState(() {
                        alertmessage = e.toString();
                      });
                    } catch (e) {
                      // If any other type of exception/error is thrown
                      setState(() {
                        alertmessage = e.toString();
                      });
                    } finally {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Create Task'),
                          content: Text(alertmessage),
                          actions: <Widget>[
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
        navigationBar:
            const CupertinoNavigationBar(middle: Text('Create Task')),
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
                  onPressed: () async {
                    try {
                      final User? user =
                          await userRepository.currentUser(_auth);
                      if (user == null) {
                        throw Exception(
                            'Please log into a manager account to create task');
                      }

                      String? assignedUserId;
                      if (_form['user'] != "<No volunteer assigned>") {
                        User? assignedUser = await userRepository.findUserByUsername(_form['user']);
                        assignedUserId = assignedUser!.referenceId;
                      } else {
                        assignedUserId = null;
                      }

                      taskRepository.addTask(Task(_form['name'],
                          createdby: user.referenceId,
                          assignedto: assignedUserId,
                          description: _form['description'],
                          status: _form['user'] == "<No volunteer assigned>"
                              ? 'Open'
                              : 'Pending',
                          resources: [_form['resources']],
                          requests: [],
                          deadline: [
                            Timestamp.fromDate(_form['deadlinestart']),
                            Timestamp.fromDate(_form['deadlineend'])
                          ],
                          pet: _form['pet'],
                          contactperson: user.referenceId,
                          contactpersonnumber: user.contactnumber));
                      setState(() {
                        alertmessage = 'Task has successfully been created';
                      });
                    } on Exception catch (e) {
                      // If the exception thrown is a general Exception
                      setState(() {
                        alertmessage = e.toString();
                      });
                    } catch (e) {
                      // If any other type of exception/error is thrown
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
    return const Column();
  }

  // To getPetList
  Widget buildPetList() => FutureBuilder<List<Pet>>(
        future: petRepository.getPetList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for the future to complete, show a loading indicator
            return const CircularProgressIndicator();
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
            return const CircularProgressIndicator();
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
            initialValue: DateTime.now(),
            firstDate: DateTime(2023),
            lastDate: DateTime(2040),
          ),
          FastTimePicker(
            initialValue: TimeOfDay.fromDateTime(DateTime.now()),
            name: 'deadlinestarttime',
            labelText: 'Deadline Start Time',
          ),
          FastCalendar(
            name: 'deadlineend',
            labelText: 'Deadline End',
            initialValue: DateTime.now(),
            firstDate: DateTime(2023),
            lastDate: DateTime(2040),
          ),
          FastTimePicker(
            name: 'deadlineendtime',
            labelText: 'Deadline End Time',
            initialValue: TimeOfDay.fromDateTime(DateTime.now()),
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
            initialValue: DateTime.now(),
            firstDate: DateTime(2023),
            lastDate: DateTime(2040),
            labelText: 'Start',
            mode: CupertinoDatePickerMode.dateAndTime,
          ),
          FastDatePicker(
            name: 'deadlineend',
            initialValue: DateTime.now(),
            firstDate: DateTime(2023),
            lastDate: DateTime(2040),
            labelText: 'Deadline',
            mode: CupertinoDatePickerMode.dateAndTime,
          ),
          Material(child: buildPetList()),
          Material(child: buildVolunteerList())
        ],
      ),
    ];
  }
}
