import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:flutter/material.dart';
import 'package:flutter_advanced_segment/flutter_advanced_segment.dart';
import 'package:pawfection/models/pet.dart';
import 'package:pawfection/models/task.dart';
import 'package:pawfection/repository/task_repository.dart';
import 'package:pawfection/service/pet_service.dart';
import 'package:pawfection/service/task_service.dart';
import 'package:searchable_listview/searchable_listview.dart';
import 'package:pawfection/volunteer/v_task_dialog.dart' as taskDialog;

class VDashboardScreen extends StatefulWidget {
  const VDashboardScreen({super.key});

  @override
  State<VDashboardScreen> createState() => _VDashboardScreenState();
}

final _selectedSegment_04 = ValueNotifier('Pending');

final taskRepository = TaskRepository(FirebaseFirestore.instance);
final taskService = TaskService(FirebaseFirestore.instance);

class _VDashboardScreenState extends State<VDashboardScreen> {
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   fetchTaskList();
  // }

  final FirebaseAuth.FirebaseAuth _auth = FirebaseAuth.FirebaseAuth.instance;
  late FirebaseAuth.User currentUser;
  final PetService petService = PetService(FirebaseFirestore.instance);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentUser = _auth.currentUser!;
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
                title: const Text('Tasks'),
              ),
              body: Stack(children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
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
                                    .where((element) =>
                                        (element.assignedto == currentUser.uid ||
                                            element.assignedto == null) &&
                                        element.status.contains(
                                            _selectedSegment_04.value))
                                    .toList(),
                                builder: (Task task) => TaskItem(
                                    task: task, petService: petService),
                                filter: (value) => taskList
                                    .where((element) => element.name
                                        .toLowerCase()
                                        .contains(value.toLowerCase()))
                                    .where((element) =>
                                        (element.assignedto == currentUser.uid ||
                                            element.assignedto == null) &&
                                        element.status.contains(_selectedSegment_04.value))
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

class TaskItem extends StatefulWidget {
  final Task task;
  final PetService petService;

  const TaskItem({
    Key? key,
    required this.task,
    required this.petService,
  }) : super(key: key);

  @override
  State<TaskItem> createState() => _TaskItemState(petService);
}

class _TaskItemState extends State<TaskItem> {
  final _auth = FirebaseAuth.FirebaseAuth.instance;
  // authInstance
  late FirebaseAuth.User currentUser;
  late PetService petService = petService;

  _TaskItemState(this.petService);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentUser = _auth.currentUser!;
  }

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
      const Icon(Icons.restaurant),
      const Icon(Icons.cleaning_services),
      const Icon(Icons.miscellaneous_services),
      const Icon(Icons.sports_soccer),
      const Icon(Icons.school),
      const Icon(Icons.task)
    ];

    return icons[categories.indexOf(category)];
  }

  @override
  Widget build(BuildContext context) {
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
              if (widget.task.referenceId != null) {
                taskDialog.displayTaskItemDialog(
                    context, widget.task.referenceId!);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  showCategoryIcon(widget.task.category),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            widget.task.name,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.task.pet != null) // Check if pet is not null
                    FutureBuilder<Pet?>(
                      future: petService.findPetByPetID(widget.task.pet!),
                      // Fetch the pet using referenceId
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final pet = snapshot.data!;
                          return Align(
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(pet.profilepicture),
                              ),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return const Text('Error retrieving pet');
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                  const SizedBox(
                      width:
                          6), // This will add space between the pet profile picture and the IconButton
                  if (widget.task.status == "Open")
                    if (widget.task.requests.contains(currentUser.uid))
                      SizedBox(
                        height: 24.0, // Change as needed
                        width: 24.0, // Change as needed
                        child: IconButton(
                          padding: EdgeInsets.zero, // removes default padding
                          alignment: Alignment.center, // centers the icon
                          icon: const Icon(Icons.person_remove),
                          iconSize: 20.0, // Change as needed
                          onPressed: () {
                            widget.task.requests.remove(currentUser.uid);
                            taskService.updateTask(widget.task);
                          },
                        ),
                      )
                    else
                      SizedBox(
                        height: 24.0, // Change as needed
                        width: 24.0, // Change as needed
                        child: IconButton(
                          padding: EdgeInsets.zero, // removes default padding
                          alignment: Alignment.center, // centers the icon
                          icon: const Icon(Icons.person_add),
                          iconSize: 20.0, // Change as needed
                          onPressed: () {
                            if (!widget.task.requests
                                .contains(currentUser.uid)) {
                              widget.task.requests.add(currentUser.uid);
                              taskService.updateTask(widget.task);
                            }
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
        Text('No Task was found'),
      ],
    );
  }
}
