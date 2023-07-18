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
import 'package:pawfection/repository/storage_repository.dart';
import 'package:pawfection/repository/task_repository.dart';
import 'package:pawfection/repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:pawfection/service/pet_service.dart';
import 'package:pawfection/service/task_service.dart';
import 'package:pawfection/service/user_service.dart';
import 'package:image_picker/image_picker.dart';

class MCreateTaskScreen extends StatefulWidget {
  MCreateTaskScreen({
    super.key,
    this.imagePath = 'assets/images/user_profile.png',
  });

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
  final storageRepository = StorageRepository();
  final taskService = TaskService();
  final petService = PetService();
  final userService = UserService();
  bool _isLoading = false;

  late var _form;
  late var alertmessage;
  List<File?> resources = [];
  var others = '';
  bool showTextField = false;

  final _auth = FirebaseAuth.FirebaseAuth.instance; // authInstance

  List<String> categories = [
    'Feeding',
    'Cleaning',
    'Maintenance',
    'Exercising',
    'Training',
    'Others'
  ];

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
                    print('Form changed: ${value.toString()}');
                    _form = value;
                  },
                ),
                ElevatedButton(
                  child: const Text('Create'),
                  onPressed: () async {
                    try {
                      final User? user = await userService.currentUser(_auth);
                      if (user == null) {
                        throw Exception(
                            'Please log into a manager account to create task');
                      }
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

                      String? assignedUserId;
                      if (_form['user'] != "<No volunteer assigned>") {
                        User? assignedUser =
                            await userService.findUserByUsername(
                                _form['user'].toString().split(' ')[0]);
                        assignedUserId = assignedUser!.referenceId;
                      } else {
                        assignedUserId = null;
                      }

                      String? assignedPetId;
                      if (_form['pet'] != "<No pet assigned>") {
                        Pet? assignedPet =
                            await petService.findPetByPetname(_form['pet']);
                        assignedPetId = assignedPet!.referenceId;
                      } else {
                        assignedPetId = null;
                      }
                      if (resources == []) {
                        taskService.addTask(Task(_form['name'],
                            createdby: user.referenceId,
                            assignedto: assignedUserId,
                            description: _form['description'],
                            category: _form['category'],
                            categoryothers: _form['cataegoryothers'],
                            status: _form['user'] == "<No volunteer assigned>"
                                ? 'Open'
                                : 'Pending',
                            resources: [],
                            deadline: [deadlinestart, deadlineend],
                            requests: [],
                            pet: assignedPetId,
                            contactperson: user.referenceId,
                            contactpersonnumber: user.contactnumber));
                      } else {
                        Task newtask = Task(_form['name'],
                            createdby: user.referenceId,
                            assignedto: assignedUserId,
                            description: _form['description'],
                            category: _form['category'],
                            categoryothers: _form['cataegoryothers'],
                            status: _form['user'] == "<No volunteer assigned>"
                                ? 'Open'
                                : 'Pending',
                            resources: [],
                            deadline: [deadlinestart, deadlineend],
                            requests: [],
                            pet: assignedPetId,
                            contactperson: user.referenceId,
                            contactpersonnumber: user.contactnumber);
                        String refId = await taskService.addTask(newtask);
                        List<String> resourcesList = [];
                        for (var i = 0; i < resources.length; i++) {
                          var newrefId = refId + i.toString();
                          String imageURL = await storageRepository
                              .uploadImageToStorage(resources[i]!, newrefId);
                          resourcesList.add(imageURL);
                        }

                        Task? t = await taskService.findTaskByTaskID(refId);
                        if (t != null) {
                          t.resources = resourcesList;
                          taskService.updateTask(t);
                        }
                      }

                      if (assignedUserId != null) {
                        // Add one to taskcount for assigned user
                        User? assigneduser =
                            await userService.findUserByUUID(assignedUserId!);
                        if (assigneduser != null) {
                          assigneduser.taskcount += 1;
                          userService.updateUser(assigneduser);
                        }
                      }

                      setState(() {
                        alertmessage = 'Task has successfully been created';
                      });
                    } catch (e) {
                      // Will need some form of error handling in the future
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
      return Scaffold(
        appBar: const CupertinoNavigationBar(middle: Text('Create Task')),
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
                  child: const Text('Create'),
                  onPressed: () async {
                    try {
                      final User? user = await userService.currentUser(_auth);
                      if (user == null) {
                        throw Exception(
                            'Please log into a manager account to create task');
                      }

                      if (_form['deadlineend']
                          .isBefore(_form['deadlinestart'])) {
                        throw Exception(
                            'Deadline end cannot be before deadline start');
                      }

                      if (_form['deadlineend'].isBefore(DateTime.now())) {
                        throw Exception(
                            'Deadline end cannot be before current time');
                      }

                      String? assignedUserId;
                      if (_form['user'] != "<No volunteer assigned>") {
                        User? assignedUser =
                            await userService.findUserByUsername(
                                _form['user'].toString().split(' ')[0]);
                        assignedUserId = assignedUser!.referenceId;
                      } else {
                        assignedUserId = null;
                      }

                      String? assignedPetId;
                      if (_form['pet'] != "<No pet assigned>") {
                        Pet? assignedPet =
                            await petService.findPetByPetname(_form['pet']);
                        if (assignedPet == null) {
                        } else {
                          debugPrint(assignedPet.referenceId);
                        }
                        assignedPetId = assignedPet!.referenceId;
                        debugPrint(assignedPetId);
                      } else {
                        assignedPetId = null;
                      }
                      if (resources == []) {
                        taskService.addTask(Task(_form['name'],
                            createdby: user.referenceId,
                            assignedto: assignedUserId,
                            description: _form['description'],
                            category: _form['category'],
                            categoryothers: _form['cataegoryothers'],
                            status: _form['user'] == "<No volunteer assigned>"
                                ? 'Open'
                                : 'Pending',
                            resources: [],
                            deadline: [
                              Timestamp.fromDate(_form['deadlinestart']),
                              Timestamp.fromDate(_form['deadlineend'])
                            ],
                            requests: [],
                            pet: assignedPetId,
                            contactperson: user.referenceId,
                            contactpersonnumber: user.contactnumber));
                      } else {
                        Task newtask = Task(_form['name'],
                            createdby: user.referenceId,
                            assignedto: assignedUserId,
                            description: _form['description'],
                            category: _form['category'],
                            categoryothers: _form['cataegoryothers'],
                            status: _form['user'] == "<No volunteer assigned>"
                                ? 'Open'
                                : 'Pending',
                            resources: [],
                            deadline: [
                              Timestamp.fromDate(_form['deadlinestart']),
                              Timestamp.fromDate(_form['deadlineend'])
                            ],
                            requests: [],
                            pet: assignedPetId,
                            contactperson: user.referenceId,
                            contactpersonnumber: user.contactnumber);
                        String refId = await taskService.addTask(newtask);
                        List<String> resourcesList = [];
                        for (var i = 0; i < resources.length; i++) {
                          var newrefId = refId + i.toString();
                          String imageURL = await storageRepository
                              .uploadImageToStorage(resources[i]!, newrefId);
                          resourcesList.add(imageURL);
                        }

                        Task? t = await taskService.findTaskByTaskID(refId);
                        if (t != null) {
                          t.resources = resourcesList;
                          taskService.updateTask(t);
                        }
                      }

                      if (assignedUserId != null) {
                        // Add one to taskcount for assigned user
                        User? assigneduser =
                            await userService.findUserByUUID(assignedUserId!);
                        if (assigneduser != null) {
                          assigneduser.taskcount += 1;
                          userService.updateUser(assigneduser);
                        }
                      }

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
        future: userService.getUserList(),
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
                    .map((user) => '${user.username} (${user.taskcount})')
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
                initialValue: nameList[0],
              ),
            );
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
          Row(
            children: [
              Expanded(
                  child: FastDropdown(
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
                      child: const FastTextField(
                      name: 'categoryothers',
                      labelText: 'Category',
                    ))
                  : const Column()
            ],
          ),
          FastTextField(
            name: 'description',
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
                              final imageUrl = resources[index];

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
                                              child: Image.file(
                                                imageUrl,
                                              ),
                                            ),
                                            Positioned(
                                              top: 10,
                                              right: 10,
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.red,
                                                ),
                                                child: IconButton(
                                                  icon: const Icon(Icons.close),
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
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Image.file(
                                        imageUrl!,
                                        width:
                                            150, // Set the desired width for the photos
                                        height:
                                            200, // Set the desired height for the photos
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 10,
                                      right: 20,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.red,
                                        ),
                                        child: IconButton(
                                          icon: const Icon(Icons.close),
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
          Row(
            children: [
              Expanded(
                  child: FastDropdown(
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
                      child: const FastTextField(
                      name: 'categoryothers',
                      labelText: 'Category',
                    ))
                  : const Column()
            ],
          ),
          FastTextField(
            name: 'description',
            labelText: 'Description',
            validator: Validators.compose([
              Validators.required((value) => 'Field is required'),
            ]),
          ),
          CupertinoButton(
              child: const Text('Add Resources'),
              onPressed: () => pickVideo(ImageSource.gallery)),
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
                              final imageUrl = resources[index];

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
                                              child: Image.file(
                                                imageUrl,
                                              ),
                                            ),
                                            Positioned(
                                              top: 10,
                                              right: 10,
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.red,
                                                ),
                                                child: IconButton(
                                                  icon: const Icon(Icons.close),
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
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Image.file(
                                        imageUrl!,
                                        width:
                                            150, // Set the desired width for the photos
                                        height:
                                            200, // Set the desired height for the photos
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 10,
                                      right: 20,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.red,
                                        ),
                                        child: IconButton(
                                          icon: const Icon(Icons.close),
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

  void _handleResourcesAdded(List<File?> resources) {
    // Handle the selected resources
    // Show the SnackBar or perform any other actions
    var count = 0;
    for (var i = 0; i < resources.length; i++) {
      count++;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$count images added"),
      ),
    );
    // Update the necessary state variables if needed
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
        resources.addAll(filepaths);
      });
    }

    setState(() {
      _isLoading = false; // Set loading state
    });
  }
}
