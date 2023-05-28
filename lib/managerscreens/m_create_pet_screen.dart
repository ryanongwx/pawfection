import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:card_settings/card_settings.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter/cupertino.dart';
import 'package:pawfection/managerscreens/m_pet_screen.dart';
import 'package:pawfection/managerview.dart';
import 'package:pawfection/models/pet.dart';
import 'package:pawfection/services/data_repository.dart';
import 'package:pawfection/volunteerscreens/profile_picture_update_screen.dart';
import 'package:pawfection/volunteerscreens/widgets/profile_widget.dart';
import 'package:pawfection/voluteerView.dart';

class MCreatePetScreen extends StatefulWidget {
  MCreatePetScreen(
      {super.key, this.imagePath = 'assets/images/user_profile.png'});

  String imagePath;

  @override
  State<MCreatePetScreen> createState() => _MCreatePetScreenState();
}

class _MCreatePetScreenState extends State<MCreatePetScreen> {
  final GlobalKey<FormState> _profileKey = GlobalKey<FormState>();
  final formKey = GlobalKey<FormState>();
  final DataRepository repository = DataRepository();
  late var _form;
  late var alertmessage;

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Create Pet'),
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
                  onPressed: () {
                    try {
                      if (widget.imagePath !=
                          'assets/images/user_profile.png') {
                        repository.addPet(Pet(_form['name'],
                            profilepicture: widget.imagePath,
                            breed: _form['breed'],
                            description: _form['description'],
                            thingstonote: _form['thingstonote']));
                        setState(() {
                          alertmessage = 'Pet has successfully been created';
                        });
                      } else if (widget.imagePath ==
                          'assets/images/user_profile.png') {
                        setState(() {
                          alertmessage =
                              'Please change the profile picture of the pet';
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
                          title: const Text('Create Pet'),
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
                                    'Pet has successfully been created')
                                  {
                                    Navigator.of(context).push(
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
        navigationBar: CupertinoNavigationBar(middle: Text('Create Pet')),
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
                      if (widget.imagePath !=
                          'assets/images/user_profile.png') {
                        repository.addPet(Pet(_form['name'],
                            profilepicture: widget.imagePath,
                            breed: _form['breed'],
                            description: _form['description'],
                            thingstonote: _form['thingstonote']));
                        setState(() {
                          alertmessage = 'Pet has successfully been created';
                        });
                      } else if (widget.imagePath ==
                          'assets/images/user_profile.png') {
                        setState(() {
                          alertmessage =
                              'Please change the profile picture of the pet';
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
                          title: const Text('Create Pet'),
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
                                    'Pet has successfully been created')
                                  {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => ManagerView(
                                                tab: 0,
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
      ProfileWidget(
        imagePath: widget.imagePath,
        onClicked: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  ProfilePictureUpdateScreen(routetext: 'pet')));
        },
      ),
      FastFormSection(
        padding: const EdgeInsets.all(16.0),
        header: const Padding(
          padding: EdgeInsets.all(12.0),
          child: Text(
            'Pet Details',
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
            name: 'breed',
            labelText: 'Breed',
          ),
          const FastTextField(
            name: 'description',
            labelText: 'Description',
          ),
          const FastTextField(
            name: 'thingstonote',
            labelText: 'Things to note',
          ),
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
                    ProfilePictureUpdateScreen(routetext: 'pet')));
          },
        ),
      ),
      FastFormSection(
        adaptive: true,
        insetGrouped: true,
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        header: const Text('Pet Details'),
        children: [
          FastTextField(
            name: 'name',
            labelText: 'Name',
            validator: Validators.compose([
              Validators.required((value) => 'Field is required'),
            ]),
          ),
          const FastTextField(
            name: 'breed',
            labelText: 'Breed',
          ),
          const FastTextField(
            name: 'description',
            labelText: 'Description',
          ),
          const FastTextField(
            name: 'thingstonote',
            labelText: 'Things to note',
          ),
        ],
      ),
    ];
  }
}