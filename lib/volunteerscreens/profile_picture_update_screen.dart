import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:image_cropper/image_cropper.dart';
import 'package:pawfection/managerscreens/m_create_pet_screen.dart';
import 'package:pawfection/managerscreens/m_create_user_screen.dart';
import 'package:pawfection/models/pet.dart';
import 'package:pawfection/models/user.dart';
import 'package:pawfection/services/data_repository.dart';
import 'package:pawfection/volunteerscreens/v_profile_screen.dart';
import 'package:pawfection/voluteerView.dart';

class ProfilePictureUpdateScreen extends StatefulWidget {
  ProfilePictureUpdateScreen(
      {super.key, required this.routetext, required this.petid});

  String routetext;
  String petid;

  @override
  _ProfilePictureUpdateScreenState createState() =>
      _ProfilePictureUpdateScreenState();
}

class _ProfilePictureUpdateScreenState
    extends State<ProfilePictureUpdateScreen> {
  bool _isLoading = false;
  bool _isSaved = false;

  final ValueNotifier<File?> _croppedImageNotifier = ValueNotifier<File?>(null);
  final TextEditingController _textEditingController = TextEditingController();

  final DataRepository repository = DataRepository();
  FirebaseAuth.FirebaseAuth _auth = FirebaseAuth.FirebaseAuth.instance;
  late FirebaseAuth.User currentUser;

  Future<File?> _cropImage(File originalImageFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: originalImageFile.path,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Crop Image',
        ),
      ],
    );

    return croppedFile != null ? File(croppedFile.path) : null;
  }

  Future<void> pickImage(ImageSource source) async {
    setState(() {
      _isLoading = true; // Set loading state
    });

    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      File originalImageFile = File(pickedFile.path);
      File? croppedImageFile = await _cropImage(originalImageFile);
      _croppedImageNotifier.value = croppedImageFile;

      if (croppedImageFile != null) {
        final processedImageFile = croppedImageFile.path;
      }
    }

    setState(() {
      _isLoading = false; // Set loading state
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentUser = _auth.currentUser!;
  }

  @override
  void dispose() {
    _croppedImageNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool filecheck = false;
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Profile Picture '),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Image Selected:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: ValueListenableBuilder<File?>(
                  valueListenable: _croppedImageNotifier,
                  builder: (context, file, child) {
                    if (file != null) {
                      filecheck = true;
                      return CircleAvatar(
                        backgroundImage: FileImage(file),
                        radius: 150,
                      );
                    } else {
                      return const Center(child: Text('No image selected'));
                    }
                  },
                ),
              ),
              Container(
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () => pickImage(ImageSource.gallery),
                      child: Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text('Upload Image'),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                      ),
                    ),
                    ValueListenableBuilder<File?>(
                      valueListenable: _croppedImageNotifier,
                      builder: (context, file, child) {
                        if (file != null) {
                          filecheck = true;
                          if (widget.routetext == 'profile') {
                            return FutureBuilder<User?>(
                              future:
                                  repository.findUserByUUID(currentUser.uid),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  // While waiting for the future to complete, show a loading indicator
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  // If an error occurs while fetching the user, display an error message
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  // The future completed successfully
                                  final user = snapshot.data;

                                  return (user == null
                                      ? const Text('User not logged in')
                                      : ElevatedButton(
                                          onPressed: filecheck
                                              ? () async {
                                                  debugPrint(widget.routetext);
                                                  String imageURL =
                                                      await repository
                                                          .uploadImageToStorage(
                                                              file,
                                                              user.referenceId);
                                                  repository.updateUser(User(
                                                      user.email,
                                                      username: user.email,
                                                      bio: user.bio,
                                                      referenceId:
                                                          user.referenceId,
                                                      role: user.role,
                                                      availabledates:
                                                          user.availabledates,
                                                      preferences:
                                                          user.preferences,
                                                      experiences:
                                                          user.experiences,
                                                      profilepicture: imageURL,
                                                      contactnumber:
                                                          user.contactnumber));
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            VolunteerView(
                                                              tab: 1,
                                                            )),
                                                  );
                                                }
                                              : null,
                                          child: Padding(
                                            padding: EdgeInsets.all(15.0),
                                            child:
                                                Text('Update Profile Picture'),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(32.0),
                                            ),
                                          ),
                                        ));
                                }
                              },
                            );
                          } else if (widget.routetext == 'pet') {
                            return ElevatedButton(
                              onPressed: filecheck
                                  ? () async {
                                      debugPrint(widget.routetext);
                                      String imageURL =
                                          await repository.uploadImageToStorage(
                                              file, widget.petid);
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MCreatePetScreen(
                                                    imageURL: imageURL)),
                                      );
                                    }
                                  : null,
                              child: Padding(
                                padding: EdgeInsets.all(15.0),
                                child: Text('Update Profile Picture'),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                ),
                              ),
                            );
                          } else {
                            return FutureBuilder<User?>(
                              future:
                                  repository.findUserByUUID(currentUser.uid),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  // While waiting for the future to complete, show a loading indicator
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  // If an error occurs while fetching the user, display an error message
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  // The future completed successfully
                                  final user = snapshot.data;

                                  return (user == null
                                      ? const Text('User not logged in')
                                      : ElevatedButton(
                                          onPressed: filecheck
                                              ? () async {
                                                  debugPrint(widget.routetext);
                                                  String imageURL =
                                                      await repository
                                                          .uploadImageToStorage(
                                                              file,
                                                              user.referenceId);
                                                  repository.addUser(User(
                                                      user.email,
                                                      username: user.email,
                                                      bio: user.bio,
                                                      referenceId:
                                                          user.referenceId,
                                                      role: user.role,
                                                      availabledates:
                                                          user.availabledates,
                                                      preferences:
                                                          user.preferences,
                                                      experiences:
                                                          user.experiences,
                                                      profilepicture: imageURL,
                                                      contactnumber:
                                                          user.contactnumber));
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            MCreateUserScreen(
                                                                imagePath:
                                                                    file.path)),
                                                  );
                                                }
                                              : null,
                                          child: Padding(
                                            padding: EdgeInsets.all(15.0),
                                            child:
                                                Text('Update Profile Picture'),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(32.0),
                                            ),
                                          ),
                                        ));
                                }
                              },
                            );
                          }
                        } else {
                          return ElevatedButton(
                            onPressed: null,
                            child: Padding(
                              padding: EdgeInsets.all(15.0),
                              child: Text('Update Profile Picture'),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32.0),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
