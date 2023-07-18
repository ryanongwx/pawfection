import 'dart:core';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:card_settings/card_settings.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter/cupertino.dart';
import 'package:pawfection/manager_view.dart';
import 'package:pawfection/models/pet.dart';
import 'package:pawfection/models/task.dart';
import 'package:pawfection/models/user.dart';
import 'package:pawfection/repository/pet_repository.dart';
import 'package:pawfection/repository/storage_repository.dart';
import 'package:pawfection/repository/task_repository.dart';
import 'package:pawfection/repository/user_repository.dart';
import 'package:pawfection/service/pet_service.dart';
import 'package:pawfection/service/task_service.dart';
import 'package:pawfection/service/user_service.dart';
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
  final userRepository = UserRepository();
  final petRepository = PetRepository();
  final petService = PetService();
  final userService = UserService();

  bool _isLoading = false;
  List<String?> resources = [];

  late var _form;
  late var alertmessage;
  var others = '';
  bool showTextField = false;

  List<String> categories = [
    'Feeding',
    'Cleaning',
    'Maintenance',
    'Exercising',
    'Training',
    'Others'
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    resources = widget.task.resources;
    if (widget.task.categoryothers != null) {
      showTextField = true;
    }
  }

  Widget buildPetList() => FutureBuilder<List<Pet>>(
        future: petService.getPetList(),
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

            List<String?> IDList =
                petList?.map((pet) => pet.referenceId).toSet().toList() ?? [];
            String? initialValue;
            if (widget.task.pet != null) {
              int index = IDList.indexOf(widget.task.pet);
              String petUsername = petList![index].name;
              initialValue = petUsername;
            } else {
              initialValue = "<No pet assigned>";
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: FastDropdown(
                name: 'pet',
                labelText: 'Pet',
                items: nameList,
                initialValue: initialValue,
              ),
            );
          }
        },
      );

  // To getUserList
  Widget buildVolunteerList() => FutureBuilder<List<User>>(
        future: userService.getUserList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final userList = snapshot.data;
            List<String?> nameList = userList
                    ?.where((user) => user.role.toLowerCase() == "volunteer")
                    .map((user) => '${user.username} (${user.taskcount})')
                    .toSet()
                    .toList() ??
                [];
            nameList.insert(0, "<No volunteer assigned>");
            List<String?> IDList = userList
                    ?.where((user) => user.role.toLowerCase() == "volunteer")
                    .map((user) => user.referenceId)
                    .toSet()
                    .toList() ??
                [];
            String? initialValue;
            if (widget.task.assignedto != null) {
              int index = IDList.indexOf(widget.task.assignedto);
              int userTaskCount = userList![index].taskcount;
              String userUsername = userList[index].username;
              initialValue = '${userUsername} (${userTaskCount})';
            } else {
              initialValue = "<No volunteer assigned>";
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: FastDropdown(
                name: 'user',
                labelText: 'Volunteer',
                items: nameList,
                initialValue: initialValue,
              ),
            );
          }
        },
      );

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
                      var updateduserID;
                      User? updateduser = await userService.findUserByUsername(
                          _form['user'].toString().split(' ')[0]);
                      if (updateduser != null) {
                        updateduserID = updateduser.referenceId;
                      }

                      debugPrint('1');

                      var updatedpetID;
                      Pet? updatedpet =
                          await petService.findPetByPetname(_form['pet']);
                      if (updatedpet != null) {
                        updatedpetID = updatedpet.referenceId!;
                      }

                      debugPrint('2');

                      // Subtract one from the taskcounter of the previous user assigned
                      if (widget.task.assignedto != null) {
                        User? prevassigneduser = await userService
                            .findUserByUUID(widget.task.assignedto!);
                        if (prevassigneduser != null) {
                          prevassigneduser.taskcount -= 1;
                          userService.updateUser(prevassigneduser);
                        }
                      }

                      debugPrint('3');

                      DateTime deadlineenddt = DateTime(
                          _form['deadlineend'].year,
                          _form['deadlineend'].month,
                          _form['deadlineend'].day,
                          _form['deadlineendtime'].hour,
                          _form['deadlineendtime'].minute);
                      DateTime deadlinestartdt = DateTime(
                          _form['deadlinestart'].year,
                          _form['deadlinestart'].month,
                          _form['deadlinestart'].day,
                          _form['deadlinestarttime'].hour,
                          _form['deadlinestarttime'].minute);

                      Timestamp deadlinestart =
                          Timestamp.fromDate(deadlinestartdt);
                      Timestamp deadlineend = Timestamp.fromDate(deadlineenddt);

                      if (deadlineenddt.isBefore(deadlinestartdt)) {
                        throw Exception(
                            'Deadline end cannot be before deadline start');
                      }

                      if (deadlineenddt.isBefore(DateTime.now())) {
                        throw Exception(
                            'Deadline end cannot be before current time');
                      }
                      widget.task.name = _form['name'];
                      widget.task.description = _form['description'];
                      widget.task.resources = resources;
                      widget.task.deadline = [deadlinestart, deadlineend];
                      widget.task.category = _form['category'];
                      if (_form['category'] != "Others") {
                        widget.task.categoryothers = null;
                      } else {
                        widget.task.categoryothers = _form['categoryothers'];
                      }
                      widget.task.pet = updatedpetID;
                      widget.task.assignedto = updateduserID;
                      taskService.updateTask(widget.task);

                      // Add one to the taskcounter of the user assigned
                      if (updateduserID != null) {
                        User? assigneduser =
                            await userService.findUserByUUID(updateduserID);
                        debugPrint(assigneduser.toString());
                        if (assigneduser != null) {
                          assigneduser.taskcount += 1;
                          userService.updateUser(assigneduser);
                        }
                      }

                      debugPrint('5');
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
                      if (_form['deadlineend']
                          .isBefore(_form['deadlinestart'])) {
                        throw Exception(
                            'Deadline end cannot be before deadline start');
                      }

                      if (_form['deadlineend'].isBefore(DateTime.now())) {
                        throw Exception(
                            'Deadline end cannot be before current time');
                      }

                      for (var i = 0; i < resources.length; i++) {
                        var newrefId = widget.task.referenceId! + i.toString();
                        if (!resources[i]!.startsWith('http')) {
                          String imageURL =
                              await storageRepository.uploadImageToStorage(
                                  File(resources[i]!), newrefId);
                          resources[i] = imageURL;
                        }
                      }
                      var updateduserID;
                      User? updateduser = await userService.findUserByUsername(
                          _form['user'].toString().split(' ')[0]);
                      if (updateduser != null) {
                        updateduserID = updateduser.referenceId;
                      }

                      debugPrint('1');

                      var updatedpetID;
                      Pet? updatedpet =
                          await petService.findPetByPetname(_form['pet']);
                      if (updatedpet != null) {
                        updatedpetID = updatedpet.referenceId!;
                      }

                      debugPrint('2');

                      // Subtract one from the taskcounter of the previous user assigned
                      if (widget.task.assignedto != null) {
                        User? prevassigneduser = await userService
                            .findUserByUUID(widget.task.assignedto!);
                        if (prevassigneduser != null) {
                          prevassigneduser.taskcount -= 1;
                          userService.updateUser(prevassigneduser);
                        }
                      }

                      debugPrint('3');

                      widget.task.name = _form['name'];
                      widget.task.assignedto = updateduserID;
                      widget.task.description = _form['description'];
                      widget.task.category = _form['category'];
                      if (_form['category'] != "Others") {
                        widget.task.categoryothers = null;
                      } else {
                        widget.task.categoryothers = _form['categoryothers'];
                      }

                      debugPrint(widget.task.category);
                      widget.task.resources = resources;
                      widget.task.deadline = [
                        Timestamp.fromDate(_form['deadlinestart']),
                        Timestamp.fromDate(_form['deadlineend'])
                      ];
                      widget.task.pet = updatedpetID;

                      taskService.updateTask(widget.task);

                      debugPrint('4');

                      // Add one to the taskcounter of the user assigned
                      if (updateduserID != null) {
                        User? assigneduser =
                            await userService.findUserByUUID(updateduserID);
                        debugPrint(assigneduser.toString());
                        if (assigneduser != null) {
                          assigneduser.taskcount += 1;
                          userService.updateUser(assigneduser);
                        }
                      }

                      debugPrint('5');

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
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Row(
              children: [
                Expanded(
                    child: FastDropdown(
                        initialValue: widget.task.category,
                        name: 'category',
                        onChanged: (newvalue) {
                          setState(() {
                            showTextField = newvalue == 'Others';
                          });
                        },
                        labelText: 'Category',
                        items: categories)),
                showTextField
                    ? Expanded(
                        child: FastTextField(
                        initialValue: widget.task.categoryothers ?? '',
                        name: 'categoryothers',
                        labelText: 'Category',
                      ))
                    : const Column()
              ],
            ),
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
          FastTimePicker(
            initialValue: TimeOfDay.fromDateTime(DateTime.now()),
            name: 'deadlinestarttime',
            labelText: 'Deadline Start Time',
          ),
          FastCalendar(
            name: 'deadlineend',
            initialValue: DateTime.fromMicrosecondsSinceEpoch(
                widget.task.deadline.elementAt(1)!.microsecondsSinceEpoch),
            labelText: 'Deadline End',
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
            initialValue: widget.task.name,
            labelText: 'Name',
            validator: Validators.compose([
              Validators.required((value) => 'Field is required'),
            ]),
          ),
          Row(
            children: [
              Expanded(
                  child: FastDropdown(
                      initialValue: widget.task.category,
                      name: 'category',
                      onChanged: (newvalue) {
                        setState(() {
                          showTextField = newvalue == 'Others';
                        });
                      },
                      labelText: 'Category',
                      items: categories)),
              showTextField
                  ? Expanded(
                      child: FastTextField(
                      initialValue: widget.task.categoryothers ?? '',
                      name: 'categoryothers',
                      labelText: 'Category',
                    ))
                  : const Column()
            ],
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
          buildPetList(),
          buildVolunteerList(),
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
