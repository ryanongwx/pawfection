import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter/cupertino.dart';
import 'package:pawfection/models/user.dart';
import 'package:pawfection/repository/storage_repository.dart';
import 'package:pawfection/repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:pawfection/service/user_service.dart';
import 'package:pawfection/voluteer_view.dart';

class VProfileUpdateScreen extends StatefulWidget {
  VProfileUpdateScreen(
      {super.key,
      this.imagePath = 'assets/images/user_profile.png',
      required this.user});

  String imagePath;
  User user;

  @override
  State<VProfileUpdateScreen> createState() => _VProfileUpdateScreenState();
}

class _VProfileUpdateScreenState extends State<VProfileUpdateScreen> {
  final GlobalKey<FormState> _profileKey = GlobalKey<FormState>();
  final formKey = GlobalKey<FormState>();
  final userRepository = UserRepository();
  final storageRepository = StorageRepository();
  final userService = UserService();
  final FirebaseAuth.FirebaseAuth _auth = FirebaseAuth.FirebaseAuth.instance;

  late var _form;
  late var alertmessage;

  var preferences = [];

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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Update Volunteer Profile'),
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
                  onPressed: () async {
                    try {
                      User? findusername = await userService
                          .findUserByUsername(_form['username']);
                      if (findusername == null ||
                          findusername.username == widget.user.username) {
                        userService.updateUser(User(_form['email'],
                            referenceId: widget.user.referenceId,
                            username: _form['username'],
                            role: widget.user.role,
                            bio: _form['bio'],
                            availabledates: widget.user.availabledates,
                            preferences: _form['preferences'],
                            experiences: _form['experiences'],
                            profilepicture: widget.user.profilepicture,
                            contactnumber: _form['contactnumber'],
                            taskcount: widget.user.taskcount));
                        setState(() {
                          alertmessage = 'User has successfully been updated';
                        });
                      } else {
                        setState(() {
                          alertmessage = 'Username has been taken';
                        });
                      }
                    } catch (e) {
                      setState(() {
                        alertmessage = 'Please ensure all fields are filled in';
                      });
                    } finally {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Create User'),
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
                                    'User has successfully been updated')
                                  {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const VolunteerView(
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
        navigationBar: const CupertinoNavigationBar(
            middle: Text('Update Volunteer Profile')),
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
                  onPressed: () async {
                    try {
                      List<String> preferences = [];
                      if (_form['p_walking']) {
                        preferences.add('walking');
                      }
                      if (_form['p_running']) {
                        preferences.add('walking');
                      }
                      if (_form['p_feeding']) {
                        preferences.add('walking');
                      }
                      if (_form['p_training']) {
                        preferences.add('training');
                      }

                      List<String> experiences = [];
                      if (_form['e_walking']) {
                        experiences.add('walking');
                      }
                      if (_form['e_running']) {
                        experiences.add('walking');
                      }
                      if (_form['e_feeding']) {
                        experiences.add('walking');
                      }
                      if (_form['e_training']) {
                        experiences.add('training');
                      }
                      User? findusername = await userService
                          .findUserByUsername(_form['username']);
                      if (findusername == null ||
                          findusername.username == widget.user.username) {
                        userService.updateUser(User(_form['email'],
                            referenceId: widget.user.referenceId,
                            username: _form['username'],
                            role: widget.user.role,
                            bio: _form['bio'],
                            availabledates: widget.user.availabledates,
                            preferences: preferences,
                            experiences: experiences,
                            profilepicture: widget.user.profilepicture,
                            contactnumber: _form['contactnumber'],
                            taskcount: widget.user.taskcount));
                        setState(() {
                          alertmessage = 'User has successfully been updated';
                        });
                      } else {
                        setState(() {
                          alertmessage = 'Username has been taken';
                        });
                      }
                    } catch (e) {
                      setState(() {
                        alertmessage = '$e';
                      });
                    } finally {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Update User Profile'),
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
                                    'User has successfully been updated')
                                  {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const VolunteerView(
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

  List<Widget> _buildForm(BuildContext context) {
    return [
      FastFormSection(
        padding: const EdgeInsets.all(16.0),
        header: const Padding(
          padding: EdgeInsets.all(12.0),
          child: Text(
            'Volunteer Details',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        children: [
          FastTextField(
            name: 'username',
            labelText: 'Username',
            initialValue: widget.user.username,
            validator: Validators.compose([
              Validators.required((value) => 'Field is required'),
            ]),
          ),
          FastTextField(
            name: 'email',
            labelText: 'Email',
            keyboardType: TextInputType.emailAddress,
            initialValue: widget.user.email,
            validator: Validators.compose([
              Validators.required((value) => 'Field is required'),
            ]),
          ),
          FastTextField(
            name: 'contactnumber',
            labelText: 'Contact Number',
            keyboardType: TextInputType.phone,
            initialValue: widget.user.contactnumber,
            validator: Validators.compose([
              Validators.required((value) {
                if (value == null) {
                  return 'Field is required';
                } else if (value.length != 8) {
                  return 'Phone number has to be 8 digits long';
                }
                return null;
              }),
            ]),
          ),
          FastTextField(
            name: 'bio',
            labelText: 'Bio',
            initialValue: widget.user.bio,
            validator: Validators.compose([
              Validators.required((value) => 'Field is required'),
            ]),
          ),
          FastChoiceChips(
            name: 'preferences',
            labelText: 'Preferences',
            alignment: WrapAlignment.center,
            chipPadding: const EdgeInsets.all(8.0),
            chips: [
              FastChoiceChip(
                value: 'Walking',
              ),
              FastChoiceChip(
                value: 'Runnning',
              ),
              FastChoiceChip(
                value: 'Feeding',
              ),
            ],
            validator: (value) => value == null || value.isEmpty
                ? 'Please select at least one chip'
                : null,
          ),
          FastChoiceChips(
            name: 'experiences',
            labelText: 'Experiences',
            alignment: WrapAlignment.center,
            chipPadding: const EdgeInsets.all(8.0),
            chips: [
              FastChoiceChip(
                value: 'Walking',
              ),
              FastChoiceChip(
                value: 'Runnning',
              ),
              FastChoiceChip(
                value: 'Feeding',
              ),
            ],
            validator: (value) => value == null || value.isEmpty
                ? 'Please select at least one chip'
                : null,
          ),
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
        header: const Text('Volunteer Details'),
        children: [
          FastTextField(
            name: 'username',
            labelText: 'Username',
            initialValue: widget.user.username,
            validator: Validators.compose([
              Validators.required((value) => 'Field is required'),
            ]),
          ),
          FastTextField(
            name: 'email',
            labelText: 'Email',
            keyboardType: TextInputType.emailAddress,
            initialValue: widget.user.email,
            validator: Validators.compose([
              Validators.required((value) => 'Field is required'),
            ]),
          ),
          FastTextField(
            name: 'contactnumber',
            labelText: 'Contact Number',
            keyboardType: TextInputType.phone,
            initialValue: widget.user.contactnumber,
            validator: Validators.compose([
              Validators.required((value) => 'Field is required'),
            ]),
          ),
          FastTextField(
            name: 'bio',
            labelText: 'Bio',
            initialValue: widget.user.bio,
            validator: Validators.compose([
              Validators.required((value) => 'Field is required'),
            ]),
          ),
        ],
      ),
      const FastFormSection(
          adaptive: true,
          insetGrouped: true,
          padding: EdgeInsets.symmetric(vertical: 12.0),
          header: Text('Experience'),
          children: [
            FastCheckbox(
              name: 'e_walking',
              labelText: 'Walking pets',
            ),
            FastCheckbox(
              name: 'e_running',
              labelText: 'Running with pets',
            ),
            FastCheckbox(
              name: 'e_training',
              labelText: 'Training pets',
            ),
            FastCheckbox(
              name: 'e_feeding',
              labelText: 'Feeding pets',
            ),
          ]),
      const FastFormSection(
          adaptive: true,
          insetGrouped: true,
          padding: EdgeInsets.symmetric(vertical: 12.0),
          header: Text('Preferences'),
          children: [
            FastCheckbox(
              name: 'p_walking',
              labelText: 'Walking pets',
            ),
            FastCheckbox(
              name: 'p_running',
              labelText: 'Running with pets',
            ),
            FastCheckbox(
              name: 'p_training',
              labelText: 'Training pets',
            ),
            FastCheckbox(
              name: 'p_feeding',
              labelText: 'Feeding pets',
            ),
          ])
    ];
  }
}
