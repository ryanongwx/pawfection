import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_segment/flutter_advanced_segment.dart';
import 'package:pawfection/models/pet.dart';
import 'package:pawfection/models/task.dart';
import 'package:pawfection/models/user.dart';
import 'package:pawfection/services/data_repository.dart';
import 'package:searchable_listview/searchable_listview.dart';
import 'package:pawfection/managerscreens/m_create_task_screen.dart';
import '../volunteerscreens/v_dashboard_screen.dart';
import 'package:pawfection/managerscreens/m_task_dialog.dart' as Dialog;

class MDashboardScreen extends StatefulWidget {
  const MDashboardScreen({super.key});

  @override
  State<MDashboardScreen> createState() => _MDashboardScreenState();
}

final _selectedSegment_04 = ValueNotifier('Pending');

final DataRepository repository = DataRepository();

// List<Task> taskList = [];

// Future<void> fetchTaskList() async {
//   Future<List<Task>> taskListFuture = repository.getTaskList();
//   taskList = await taskListFuture;
// }

class _MDashboardScreenState extends State<MDashboardScreen> {
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   fetchTaskList();
  // }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: DataRepository().tasks,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // Convert to List
          List<Task> taskList = DataRepository().snapshotToTaskList(snapshot);

          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          return Scaffold(
              appBar: AppBar(
                title: const Text('Tasks'),
                actions: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MCreateTaskScreen()),
                          );
                        },
                        child: Icon(
                          Icons.add,
                          size: 26.0,
                        ),
                      )),
                ],
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
                    return Padding(
                      padding:
                          const EdgeInsets.only(top: 75.0, left: 20, right: 20),
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
                        inputDecoration: InputDecoration(
                          labelText: "Search Task",
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    );
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

  @override
  Widget build(BuildContext context) {
    if (task == null) {
      return Column();
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
                  Dialog.displayTaskItemDialog(context, task.referenceId!);
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    const Icon(
                      Icons.account_circle,
                      color: Colors.black,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${task.name}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
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
