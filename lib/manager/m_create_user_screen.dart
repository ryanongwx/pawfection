import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter/cupertino.dart';
import 'package:pawfection/manager_view.dart';
import 'package:pawfection/models/user.dart';

import 'package:pawfection/repository/user_repository.dart';
import 'package:pawfection/service/user_service.dart';
import 'package:pawfection/volunteer/profile_picture_update_screen.dart';
import 'package:pawfection/volunteer/widgets/profile_widget.dart';

class MCreateUserScreen extends StatefulWidget {
  MCreateUserScreen(
      {super.key, this.imagePath = 'assets/images/user_profile.png'});

  String imagePath;

  @override
  State<MCreateUserScreen> createState() => _MCreateUserScreenState();
}

class _MCreateUserScreenState extends State<MCreateUserScreen> {
  final GlobalKey<FormState> _profileKey = GlobalKey<FormState>();
  final formKey = GlobalKey<FormState>();
  final userService = UserService();
  late var _form;
  late var alertmessage;

  var _experiences = [];
  var preferences = [];

  int _selectedFruit = 0;

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
    String accesscode = '';
    if (Platform.isAndroid) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Create Volunteer'),
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
                      User? findusername = await userService
                          .findUserByUsername(_form['username']);
                      if (findusername == null) {
                        accesscode = await userService.addUser(User(
                            _form['email'],
                            username: _form['username'],
                            role: _form['role'],
                            availabledates: [],
                            preferences: [],
                            experiences: [],
                            profilepicture:
                                'https://firebasestorage.googleapis.com/v0/b/pawfection-c14ed.appspot.com/o/profilepictures%2FFlFhhBapCZOzattk8mT1CMNxou22?alt=media&token=530bd4b2-95b6-45dc-88f0-9abf64d2a916',
                            contactnumber: _form['contactnumber'],
                            referenceId: '',
                            bio: ''));
                        setState(() {
                          alertmessage =
                              'User has successfully been created. \n Access Code: $accesscode';
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
                          content: Text(
                            alertmessage,
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () async {
                                debugPrint(accesscode);
                                await Clipboard.setData(
                                        ClipboardData(text: accesscode))
                                    .then((_) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Access code copied to clipboard")));
                                });
                              },
                              child: const Text('Copy Access Code'),
                            ),
                            TextButton(
                              onPressed: () => {
                                Navigator.pop(context, 'OK'),
                                if (alertmessage ==
                                    'User has successfully been created. \n Access Code: $accesscode')
                                  {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => ManagerView(
                                                tab: 2,
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
        navigationBar: CupertinoNavigationBar(middle: Text('Create User')),
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
                      User? findusername = await userService
                          .findUserByUsername(_form['username']);
                      if (findusername == null) {
                        accesscode = await userService.addUser(User(
                            _form['email'],
                            username: _form['username'],
                            role: _form['role'],
                            availabledates: [],
                            preferences: [],
                            experiences: [],
                            profilepicture:
                                'https://firebasestorage.googleapis.com/v0/b/pawfection-c14ed.appspot.com/o/profilepictures%2FFlFhhBapCZOzattk8mT1CMNxou22?alt=media&token=530bd4b2-95b6-45dc-88f0-9abf64d2a916',
                            contactnumber: _form['contactnumber'],
                            referenceId: '',
                            bio: ''));
                        setState(() {
                          alertmessage =
                              'User has successfully been created. \n Access Code: $accesscode';
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
                              onPressed: () async {
                                await Clipboard.setData(
                                        ClipboardData(text: accesscode))
                                    .then((_) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Access code copied to clipboard")));
                                });
                              },
                              child: const Text('Copy Access Code'),
                            ),
                            TextButton(
                              onPressed: () => {
                                Navigator.pop(context, 'OK'),
                                if (alertmessage ==
                                    'User has successfully been created. \n Access Code: $accesscode')
                                  {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => ManagerView(
                                                tab: 2,
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
            'Volunteer Details',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        children: [
          FastTextField(
            name: 'username',
            labelText: 'Username',
            validator: Validators.compose([
              Validators.required((value) => 'Field is required'),
            ]),
          ),
          FastTextField(
            name: 'email',
            labelText: 'Email',
            validator: Validators.compose([
              Validators.required((value) => 'Field is required'),
            ]),
          ),
          FastTextField(
            name: 'contactnumber',
            labelText: 'Contact Number',
            validator: Validators.compose([
              Validators.required((value) => 'Field is required'),
            ]),
          ),
          FastRadioGroup<String>(
            name: 'role',
            labelText: 'Role',
            options: const [
              FastRadioOption(text: 'Volunteer', value: 'volunteer'),
              FastRadioOption(text: 'Manager', value: 'manager'),
            ],
          ),
          // FastChoiceChips(
          //   name: 'preferences',
          //   labelText: 'Preferences',
          //   alignment: WrapAlignment.center,
          //   chipPadding: const EdgeInsets.all(8.0),
          //   chips: [
          //     FastChoiceChip(
          //       selected: true,
          //       value: 'Walking',
          //     ),
          //     FastChoiceChip(
          //       value: 'Runnning',
          //     ),
          //     FastChoiceChip(
          //       value: 'Feeding',
          //     ),
          //   ],
          //   validator: (value) => value == null || value.isEmpty
          //       ? 'Please select at least one chip'
          //       : null,
          // ),
          // FastChoiceChips(
          //   name: 'experiences',
          //   labelText: 'Experiences',
          //   alignment: WrapAlignment.center,
          //   chipPadding: const EdgeInsets.all(8.0),
          //   chips: [
          //     FastChoiceChip(
          //       selected: true,
          //       value: 'Walking',
          //     ),
          //     FastChoiceChip(
          //       value: 'Runnning',
          //     ),
          //     FastChoiceChip(
          //       value: 'Feeding',
          //     ),
          //   ],
          //   validator: (value) => value == null || value.isEmpty
          //       ? 'Please select at least one chip'
          //       : null,
          // ),
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
            validator: Validators.compose([
              Validators.required((value) => 'Field is required'),
            ]),
          ),
          FastTextField(
            name: 'email',
            labelText: 'Email',
            validator: Validators.compose([
              Validators.required((value) => 'Field is required'),
            ]),
          ),
          FastTextField(
            name: 'contactnumber',
            labelText: 'Contact Number',
            validator: Validators.compose([
              Validators.required((value) => 'Field is required'),
            ]),
          ),
          FastSegmentedControl<String>(
            name: 'role',
            labelText: 'Role',
            children: const {
              'volunteer': Text(
                'Volunteer',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    decoration: TextDecoration.none),
              ),
              'manager': Text(
                'Manager',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    decoration: TextDecoration.none),
              ),
            },
          ),
        ],
      ),
      // const FastFormSection(
      //     adaptive: true,
      //     insetGrouped: true,
      //     padding: EdgeInsets.symmetric(vertical: 12.0),
      //     header: Text('Experience'),
      //     children: [
      //       FastCheckbox(
      //         name: 'walking',
      //         labelText: 'Walking pets',
      //       ),
      //       FastCheckbox(
      //         name: 'running',
      //         labelText: 'Running with pets',
      //       ),
      //       FastCheckbox(
      //         name: 'training',
      //         labelText: 'Training pets',
      //       ),
      //       FastCheckbox(
      //         name: 'feeding',
      //         labelText: 'Feeding pets',
      //       ),
      //     ]),
      // const FastFormSection(
      //     adaptive: true,
      //     insetGrouped: true,
      //     padding: EdgeInsets.symmetric(vertical: 12.0),
      //     header: Text('Preferences'),
      //     children: [
      //       FastCheckbox(
      //         name: 'walking',
      //         labelText: 'Walking pets',
      //       ),
      //       FastCheckbox(
      //         name: 'running',
      //         labelText: 'Running with pets',
      //       ),
      //       FastCheckbox(
      //         name: 'training',
      //         labelText: 'Training pets',
      //       ),
      //       FastCheckbox(
      //         name: 'feeding',
      //         labelText: 'Feeding pets',
      //       ),
      //     ])
    ];
  }
}
