import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:card_settings/card_settings.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter/cupertino.dart';
import 'package:pawfection/manager/m_pet_screen.dart';
import 'package:pawfection/manager_view.dart';
import 'package:pawfection/models/pet.dart';
import 'package:pawfection/repository/pet_repository.dart';
import 'package:pawfection/volunteer/profile_picture_update_screen.dart';
import 'package:pawfection/volunteer/widgets/profile_widget.dart';
import 'package:pawfection/voluteer_view.dart';

class MUpdatePetScreen extends StatefulWidget {
  MUpdatePetScreen({super.key, required this.imageURL, required this.pet});

  String imageURL;
  Pet pet;

  @override
  State<MUpdatePetScreen> createState() => _MUpdatePetScreenState();
}

class _MUpdatePetScreenState extends State<MUpdatePetScreen> {
  final GlobalKey<FormState> _profileKey = GlobalKey<FormState>();
  final formKey = GlobalKey<FormState>();
  final petRepository = PetRepository();
  late var _form;
  late var alertmessage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.imageURL == '') {
      widget.imageURL = widget.pet.profilepicture;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Update Pet'),
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
                  child: const Text('Update'),
                  onPressed: () {
                    try {
                      petRepository.addPet(Pet(_form['name'],
                          profilepicture: widget.imageURL,
                          breed: _form['breed'],
                          description: _form['description'],
                          thingstonote: _form['thingstonote']));
                      alertmessage == 'Pet has successfully been created';
                    } catch (e) {
                      setState(() {
                        alertmessage = 'Please ensure all fields are filled in';
                      });
                    } finally {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Update Pet'),
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
                                    'Pet has successfully been updated')
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
        navigationBar: CupertinoNavigationBar(middle: Text('Update Pet')),
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
                      petRepository.addPet(Pet(_form['name'],
                          profilepicture: widget.imageURL,
                          breed: _form['breed'],
                          description: _form['description'],
                          thingstonote: _form['thingstonote']));
                      alertmessage == 'Pet has successfully been created';
                    } catch (e) {
                      setState(() {
                        alertmessage = 'Please ensure all fields are filled in';
                      });
                    } finally {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Update Pet'),
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
                                    'Pet has successfully been updated')
                                  {
                                    Navigator.of(context).pushReplacement(
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
      Padding(
        padding: EdgeInsets.only(top: 20),
        child: ProfileWidget(
          image: Image.network(widget.imageURL),
          onClicked: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProfilePictureUpdateScreen(
                      routetext: 'pet',
                      petid: widget.pet.referenceId!,
                    )));
          },
        ),
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
            placeholder: widget.pet.name,
            labelText: 'Name',
            validator: Validators.compose([
              Validators.required((value) => 'Field is required'),
            ]),
          ),
          FastTextField(
            name: 'breed',
            placeholder: widget.pet.breed,
            labelText: 'Breed',
          ),
          FastTextField(
            name: 'description',
            placeholder: widget.pet.description,
            labelText: 'Description',
          ),
          FastTextField(
            placeholder: widget.pet.thingstonote,
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
          image: Image.network(widget.imageURL),
          onClicked: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProfilePictureUpdateScreen(
                      routetext: 'pet',
                      petid: '',
                    )));
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
            placeholder: widget.pet.name,
            labelText: 'Name',
            validator: Validators.compose([
              Validators.required((value) => 'Field is required'),
            ]),
          ),
          FastTextField(
            placeholder: widget.pet.breed,
            name: 'breed',
            labelText: 'Breed',
          ),
          FastTextField(
            name: 'description',
            placeholder: widget.pet.description,
            labelText: 'Description',
          ),
          FastTextField(
            placeholder: widget.pet.thingstonote,
            name: 'thingstonote',
            labelText: 'Things to note',
          ),
        ],
      ),
    ];
  }
}
