import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:image_cropper/image_cropper.dart';

class ProfilePictureUpdateScreen extends StatefulWidget {
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
  void dispose() {
    _croppedImageNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Column(
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
                  ElevatedButton(
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
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
