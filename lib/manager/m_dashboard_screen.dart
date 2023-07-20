import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_segment/flutter_advanced_segment.dart';
import 'package:pawfection/models/task.dart';
import 'package:pawfection/repository/task_repository.dart';
import 'package:pawfection/service/functions_service.dart';
import 'package:pawfection/service/task_service.dart';
import 'package:searchable_listview/searchable_listview.dart';
import 'package:pawfection/manager/m_create_task_screen.dart';
import 'package:pawfection/manager/m_task_dialog.dart' as taskDialog;
import 'package:pawfection/manager/m_volunteer_dialog.dart' as volunteerDialog;
import 'package:pawfection/manager/m_auto_assign_dialog.dart' as autoAssignDialog;
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:pawfection/login_view.dart';

class MDashboardScreen extends StatefulWidget {
  const MDashboardScreen({super.key});

  @override
  State<MDashboardScreen> createState() => _MDashboardScreenState();
}

final _selectedSegment_04 = ValueNotifier('Pending');

final taskRepository = TaskRepository();
final taskService = TaskService();
final functionService = FunctionService();

final _auth = FirebaseAuth.FirebaseAuth.instance; // authInstance

class _MDashboardScreenState extends State<MDashboardScreen> {
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   fetchTaskList();
  // }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: taskRepository.tasks,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // Convert to List
          List<Task> taskList = taskService.snapshotToTaskList(snapshot);

          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          return Scaffold(
              appBar: AppBar(
                title: Text('Tasks'),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.person),
                    onPressed: () async {
                      try {
                        autoAssignDialog.displayAutoAssignDialog(
                            context);
                      } catch (e) {
                        debugPrint(e.toString());
                      }
                    },
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MCreateTaskScreen()),
                          );
                        },
                        child: const Icon(
                          Icons.add,
                          size: 26.0,
                        ),
                      )),
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () async {
                      try {
                        _auth.signOut();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => LoginView()),
                          (Route<dynamic> route) => false,
                        );
                      } catch (e) {
                        debugPrint(e.toString());
                      }
                    },
                  ),
                ],
              ),
              body: Stack(children: [
                SizedBox(
                  child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: AdvancedSegment(
                          controller: _selectedSegment_04,
                          segments: const {
                            'Pending': 'Pending',
                            'Completed': 'Completed',
                            'Open': 'Open',
                          },
                          activeStyle: const TextStyle(
                            // TextStyle
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                          inactiveStyle: const TextStyle(
                            // TextStyle
                            color: Colors.white54,
                          ),
                          backgroundColor: Colors.black26,
                          // Color
                          sliderColor: Colors.white,
                          // Color
                          sliderOffset: 2.0,
                          // Double
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8.0)),
                          // BorderRadius
                          itemPadding: const EdgeInsets.symmetric(
                            // EdgeInsets
                            horizontal: 15,
                            vertical: 10,
                          ),
                          animationDuration:
                              const Duration(milliseconds: 250), // Duration
                        ),
                      )),
                ),
                ValueListenableBuilder(
                  valueListenable: _selectedSegment_04,
                  builder: (context, value, child) {
                    return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.75,
                        child: Padding(
                            padding: const EdgeInsets.only(
                                top: 75.0, left: 20, right: 20),
                            child: SearchableList<Task>(
                                autoFocusOnSearch: false,
                                initialList: taskList
                                    .where((element) => element.status
                                        .contains(_selectedSegment_04.value))
                                    .toList(),
                                builder: (Task task) => TaskItem(task: task),
                                filter: (value) => taskList
                                    .where((element) => element.name
                                        .toLowerCase()
                                        .contains(value.toLowerCase()))
                                    .where((element) => element.status
                                        .contains(_selectedSegment_04.value))
                                    .toList(),
                                emptyWidget: const EmptyView(),
                                inputDecoration: const InputDecoration(
                                  labelText: "Search Task",
                                  fillColor: Colors.white,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.blue,
                                      width: 1.0,
                                    ),
                                  ),
                                ))));
                  },
                ),
              ]));
        });
  }
}

class TaskItem extends StatelessWidget {
  final Task task;
  final PetRepository petRepository;

  const TaskItem({
    Key? key,
    required this.task,
    required this.petRepository,
  }) : super(key: key);

  Icon showCategoryIcon(String category) {
    // Category and icon lists
    List<String> categories = [
      'Feeding',
      'Cleaning',
      'Maintenance',
      'Exercising',
      'Training',
      'Others'
    ];

    List<Icon> icons = [
      Icon(Icons.restaurant),
      Icon(Icons.cleaning_services),
      Icon(Icons.miscellaneous_services),
      Icon(Icons.sports_soccer),
      Icon(Icons.school),
      Icon(Icons.task)
    ];

    return icons[categories.indexOf(category)];
  }

  @override
  Widget build(BuildContext context) {
    if (task == null) {
      return const Column();
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(width: 2),
          ),
          child: InkWell(
            onTap: () {
              if (task.referenceId != null) {
                taskDialog.displayTaskItemDialog(context, task.referenceId!);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  showCategoryIcon(task.category),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        task.name,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (task.pet != null) // Check if pet is not null
                        FutureBuilder<Pet?>(
                          future: findPetByPetID(task.pet!),
                          // Fetch the pet using referenceId
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final pet = snapshot.data!;
                              return CircleAvatar(
                                radius: 16,
                                backgroundImage: NetworkImage(
                                    pet.profilePicture),
                              );
                            } else if (snapshot.hasError) {
                              return const Text('Error retrieving pet');
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
                    ],
                  ),
                  const Expanded(child: SizedBox()),
                  if (task.status == "Open")
                    SizedBox(
                      height: 24.0,
                      width: 24.0,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.center,
                        icon: const Icon(Icons.person_add),
                        iconSize: 20.0,
                        onPressed: () async {
                          volunteerDialog.displayVolunteersDialog(
                              context, task);
                        },
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}

class EmptyView extends StatelessWidget {
  const EmptyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.error,
          color: Colors.red,
        ),
        Text('No Task with this name is found'),
      ],
    );
  }
}
