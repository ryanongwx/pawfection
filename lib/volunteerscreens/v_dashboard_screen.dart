import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_segment/flutter_advanced_segment.dart';
import 'package:pawfection/models/pet.dart';
import 'package:pawfection/models/task.dart';
import 'package:pawfection/models/user.dart';
import 'package:pawfection/repository/storage_repository.dart';
import 'package:pawfection/repository/task_repository.dart';
import 'package:searchable_listview/searchable_listview.dart';

class VDashboardScreen extends StatefulWidget {
  const VDashboardScreen({super.key});

  @override
  State<VDashboardScreen> createState() => _VDashboardScreenState();
}

final _selectedSegment_04 = ValueNotifier('Pending');

final taskRepository = TaskRepository();

// List<Task> taskList = [];

// Future<void> fetchTaskList() async {
//   Future<List<Task>> taskListFuture = repository.getTaskList();
//   taskList = await taskListFuture;
// }

class _VDashboardScreenState extends State<VDashboardScreen> {
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
          List<Task> taskList = taskRepository.snapshotToTaskList(snapshot);

          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          return Scaffold(
              appBar: AppBar(title: const Text('Dashboard')),
              body: Stack(children: [
                Padding(
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
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
    );
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
