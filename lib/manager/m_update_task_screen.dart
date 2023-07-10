import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:card_settings/card_settings.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter/cupertino.dart';
import 'package:pawfection/manager_view.dart';
import 'package:pawfection/models/task.dart';
import 'package:pawfection/models/user.dart';
import 'package:pawfection/repository/storage_repository.dart';
import 'package:pawfection/repository/task_repository.dart';
import 'package:pawfection/service/task_service.dart';
import 'package:pawfection/volunteer/profile_picture_update_screen.dart';
import 'package:pawfection/volunteer/widgets/profile_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

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
  final taskService = TaskService();
  final storageRepository = StorageRepository();

  bool _isLoading = false;
  List<String?> resources = [];

  late var _form;
  late var alertmessage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    resources = widget.task.resources;
  }

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
          title: const Text('Update Task'),
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
                      for (var i = 0; i < resources.length; i++) {
                        var newrefId = widget.task.referenceId! + i.toString();
                        if (!resources[i]!.startsWith('http')) {
                          String imageURL =
                              await storageRepository.uploadImageToStorage(
                                  File(resources[i]!), newrefId);
                          resources[i] = imageURL;
                        }
                      }
                      taskService.updateTask(Task(_form['name'],
                          createdby: 'soo',
                          assignedto: 'soo',
                          description: _form['description'],
                          status: 'Pending',
                          resources: _form['resources'],
                          contactperson: _form['contactperson'],
                          contactpersonnumber: _form['contactpersonnumber'],
                          requests: [],
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
      return Scaffold(
        appBar: const CupertinoNavigationBar(middle: Text('Update Task')),
        body: SafeArea(
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
                      for (var i = 0; i < resources.length; i++) {
                        var newrefId = widget.task.referenceId! + i.toString();
                        if (!resources[i]!.startsWith('http')) {
                          String imageURL =
                              await storageRepository.uploadImageToStorage(
                                  File(resources[i]!), newrefId);
                          resources[i] = imageURL;
                        }
                      }
                      taskService.updateTask(Task(_form['name'],
                          createdby: 'soo',
                          assignedto: 'soo',
                          description: _form['description'],
                          status: 'Pending',
                          resources: resources,
                          requests: [],
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
            initialValue: widget.task.name,
            labelText: 'Name',
            validator: Validators.compose([
              Validators.required((value) => 'Field is required'),
            ]),
          ),
          FastTextField(
            name: 'description',
            initialValue: widget.task.description,
            labelText: 'Description',
            validator: Validators.compose([
              Validators.required((value) => 'Field is required'),
            ]),
          ),
          ElevatedButton(
            child: const Text('Add Resources'),
            onPressed: () => pickVideo(ImageSource.gallery),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  resources.isEmpty
                      ? Container(
                          height: 0,
                        ) // No empty space when the list is empty
                      : Container(
                          height:
                              200, // Set the desired height for the scroll view
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: resources.length,
                            itemBuilder: (BuildContext context, int index) {
                              final image = resources[index];

                              return GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      final screenSize =
                                          MediaQuery.of(context).size;
                                      final dialogWidth =
                                          screenSize.width * 0.7;
                                      final dialogHeight =
                                          screenSize.height * 0.7;

                                      return Dialog(
                                        child: Stack(
                                          children: [
                                            FittedBox(
                                                fit: BoxFit.cover,
                                                child: image.startsWith('http')
                                                    ? Image.network(image)
                                                    : Image.file(File(image))),
                                            Positioned(
                                              top: 10,
                                              right: 10,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.red,
                                                ),
                                                child: IconButton(
                                                  icon: Icon(Icons.close),
                                                  color: Colors.white,
                                                  iconSize:
                                                      18, // Adjust the size as desired
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: image!.startsWith('http')
                                            ? Image.network(image)
                                            : Image.file(File(image))),
                                    Positioned(
                                      top: 10,
                                      right: 20,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.red,
                                        ),
                                        child: IconButton(
                                          icon: Icon(Icons.close),
                                          color: Colors.white,
                                          iconSize:
                                              18, // Adjust the size as desired
                                          onPressed: () {
                                            setState(() {
                                              resources.removeAt(index);
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                ],
              ),
            ),
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
          ElevatedButton(child: const Text('Assign Pet'), onPressed: () {}),
          ElevatedButton(
              child: const Text('Assign Volunteer'), onPressed: () {}),
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
            initialValue: widget.task.name,
            labelText: 'Name',
            validator: Validators.compose([
              Validators.required((value) => 'Field is required'),
            ]),
          ),
          FastTextField(
            name: 'description',
            initialValue: widget.task.description,
            labelText: 'Description',
            validator: Validators.compose([
              Validators.required((value) => 'Field is required'),
            ]),
          ),
          CupertinoButton(
            child: const Text('Add Resources'),
            onPressed: () => pickVideo(ImageSource.gallery),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  resources.isEmpty
                      ? Container(
                          height: 0,
                        ) // No empty space when the list is empty
                      : Container(
                          height:
                              200, // Set the desired height for the scroll view
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: resources.length,
                            itemBuilder: (BuildContext context, int index) {
                              final image = resources[index];

                              return GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      final screenSize =
                                          MediaQuery.of(context).size;
                                      final dialogWidth =
                                          screenSize.width * 0.7;
                                      final dialogHeight =
                                          screenSize.height * 0.7;

                                      return Dialog(
                                        child: Stack(
                                          children: [
                                            FittedBox(
                                                fit: BoxFit.cover,
                                                child: image.startsWith('http')
                                                    ? Image.network(image)
                                                    : Image.file(File(image))),
                                            Positioned(
                                              top: 10,
                                              right: 10,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.red,
                                                ),
                                                child: IconButton(
                                                  icon: Icon(Icons.close),
                                                  color: Colors.white,
                                                  iconSize:
                                                      18, // Adjust the size as desired
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: image!.startsWith('http')
                                            ? Image.network(image)
                                            : Image.file(File(image))),
                                    Positioned(
                                      top: 10,
                                      right: 20,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.red,
                                        ),
                                        child: IconButton(
                                          icon: Icon(Icons.close),
                                          color: Colors.white,
                                          iconSize:
                                              18, // Adjust the size as desired
                                          onPressed: () {
                                            setState(() {
                                              resources.removeAt(index);
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                ],
              ),
            ),
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
          CupertinoButton(child: const Text('Assign Pet'), onPressed: () {}),
          CupertinoButton(
              child: const Text('Assign Volunteer'), onPressed: () {}),
        ],
      ),
    ];
  }

  Future<void> pickVideo(ImageSource source) async {
    setState(() {
      _isLoading = true; // Set loading state
    });

    final ImagePicker picker = ImagePicker();
    final List<XFile> pickedFiles = await picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      final List<File?> filepaths =
          pickedFiles.map((e) => File(e.path)).toList();
      setState(() {
        resources.addAll(filepaths.map((e) => e!.path).toList());
      });
    }

    setState(() {
      _isLoading = false; // Set loading state
    });
  }

  File convertImageToFile(img.Image image) {
    final tempDir = Directory.systemTemp;
    final tempFile = File('${tempDir.path}/image.png');

    // Encode the image as PNG bytes
    final pngBytes = img.encodePng(image);

    // Write the bytes to the file
    tempFile.writeAsBytesSync(pngBytes);

    return tempFile;
  }
}
