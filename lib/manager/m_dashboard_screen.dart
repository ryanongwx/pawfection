import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_segment/flutter_advanced_segment.dart';
import 'package:pawfection/models/task.dart';
import 'package:pawfection/repository/task_repository.dart';
import 'package:pawfection/service/task_service.dart';
import 'package:searchable_listview/searchable_listview.dart';
import 'package:pawfection/manager/m_create_task_screen.dart';
import 'package:pawfection/manager/m_task_dialog.dart' as taskDialog;
import 'package:pawfection/manager/m_volunteer_dialog.dart' as volunteerDialog;
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:pawfection/login_view.dart';

class MDashboardScreen extends StatefulWidget {
  FirebaseFirestore firebaseFirestore;

  MDashboardScreen({super.key, required this.firebaseFirestore});

  @override
  State<MDashboardScreen> createState() => _MDashboardScreenState();
}

final _selectedSegment_04 = ValueNotifier('Pending');

late TaskRepository taskRepository;
late TaskService taskService;

final _auth = FirebaseAuth.FirebaseAuth.instance; // authInstance

class _MDashboardScreenState extends State<MDashboardScreen> {
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   fetchTaskList();
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    taskRepository = TaskRepository(widget.firebaseFirestore);
    taskService = TaskService(widget.firebaseFirestore);
  }

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
                centerTitle: true,
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
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
                    ),
                  ),
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
                // Padding(
                //     padding: EdgeInsets.only(bottom: 100),
                //     child: Align(
                //       alignment: Alignment.bottomCenter,
                //       child: ElevatedButton(
                //           onPressed: () {
                //             Navigator.push(
                //               context,
                //               MaterialPageRoute(
                //                   builder: (context) => MCreateTaskScreen()),
                //             );
                //           },
                //           child: Text('Create Tasks')),
                //     )),
              ]));
        });
  }
}

class TaskItem extends StatelessWidget {
  final Task task;

  const TaskItem({
    Key? key,
    required this.task,
  }) : super(key: key);

  Icon showCategoryIcon(String category) {
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
                    const SizedBox(
                      width: 10,
                    ),
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
                      ],
                    ),
                    // To push icon to the right
                    const Expanded(child: SizedBox()),
                    if (task.status == "Open")
                      SizedBox(
                        height: 24.0, // Change as needed
                        width: 24.0, // Change as needed
                        child: IconButton(
                          padding: EdgeInsets.zero, // removes default padding
                          alignment: Alignment.center, // centers the icon
                          icon: const Icon(Icons.person_add),
                          iconSize: 20.0, // Change as needed
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
          ));
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
