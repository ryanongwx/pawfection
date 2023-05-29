import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:card_settings/card_settings.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter/cupertino.dart';
import 'package:pawfection/managerView.dart';
import 'package:pawfection/models/user.dart';
import 'package:pawfection/services/data_repository.dart';
import 'package:pawfection/volunteerscreens/profile_picture_update_screen.dart';
import 'package:pawfection/volunteerscreens/widgets/profile_widget.dart';

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
  final DataRepository repository = DataRepository();
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

                    if (_form['walking']) {}
                  },
                ),
                // ElevatedButton(
                //   child: const Text('Create'),
                //   onPressed: () {
                //     try {
                //       repository.addUser(User(_form['email'],
                //           username: _form['username'],
                //           role: _form['role'],
                //           availabledates: [],
                //           preferences: [],
                //           experiences: [],
                //           profilepicture: widget.imagePath,
                //           contactnumber: _form['contactnumber']));
                //       setState(() {
                //         alertmessage = 'User has successfully been created';
                //       });
                //     } catch (e) {
                //       setState(() {
                //         alertmessage = 'Please ensure all fields are filled in';
                //       });
                //     } finally {
                //       showDialog<String>(
                //         context: context,
                //         builder: (BuildContext context) => AlertDialog(
                //           title: const Text('Create User'),
                //           content: Text(alertmessage),
                //           actions: <Widget>[
                //             TextButton(
                //               onPressed: () => Navigator.pop(context, 'Cancel'),
                //               child: const Text('Cancel'),
                //             ),
                //             TextButton(
                //               onPressed: () => {
                //                 Navigator.pop(context, 'OK'),
                //                 if (alertmessage ==
                //                     'User has successfully been created')
                //                   {
                //                     Navigator.of(context).push(
                //                       MaterialPageRoute(
                //                           builder: (context) => ManagerView(
                //                                 tab: 2,
                //                               )),
                //                     )
                //                   }
                //               },
                //               child: const Text('OK'),
                //             ),
                //           ],
                //         ),
                //       );
                //     }
                //   },
                // ),
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
                // CupertinoButton(
                //   child: const Text('Create'),
                //   onPressed: () {
                //     try {
                //       repository.addUser(User(_form['email'],
                //           username: _form['username'],
                //           role: _form['role'],
                //           availabledates: [],
                //           preferences: [],
                //           experiences: [],
                //           profilepicture: widget.imagePath,
                //           contactnumber: _form['contactnumber']));
                //       setState(() {
                //         alertmessage = 'User has successfully been created';
                //       });
                //     } catch (e) {
                //       setState(() {
                //         alertmessage = 'Please ensure all fields are filled in';
                //       });
                //     } finally {
                //       showDialog<String>(
                //         context: context,
                //         builder: (BuildContext context) => AlertDialog(
                //           title: const Text('Create User'),
                //           content: Text(alertmessage),
                //           actions: <Widget>[
                //             TextButton(
                //               onPressed: () => Navigator.pop(context, 'Cancel'),
                //               child: const Text('Cancel'),
                //             ),
                //             TextButton(
                //               onPressed: () => {
                //                 Navigator.pop(context, 'OK'),
                //                 if (alertmessage ==
                //                     'User has successfully been created')
                //                   {
                //                     Navigator.of(context).push(
                //                       MaterialPageRoute(
                //                           builder: (context) => ManagerView(
                //                                 tab: 2,
                //                               )),
                //                     )
                //                   }
                //               },
                //               child: const Text('OK'),
                //             ),
                //           ],
                //         ),
                //       );
                //     }
                //   },
                // ),
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
      SizedBox(
        height: 200,
        child: ProfileWidget(
          imagePath: widget.imagePath,
          onClicked: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    ProfilePictureUpdateScreen(routetext: 'user')));
          },
        ),
      ),
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
      SizedBox(
        height: 200,
        child: ProfileWidget(
          imagePath: widget.imagePath,
          onClicked: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    ProfilePictureUpdateScreen(routetext: 'user')));
          },
        ),
      ),
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
