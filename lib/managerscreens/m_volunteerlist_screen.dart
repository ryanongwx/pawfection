import 'package:flutter/material.dart';
import 'package:flutter_advanced_segment/flutter_advanced_segment.dart';
import 'package:searchable_listview/searchable_listview.dart';

class MVolunteerListScreen extends StatefulWidget {
  const MVolunteerListScreen({super.key});

  @override
  State<MVolunteerListScreen> createState() => _MVolunteerListScreenState();
}

final _selectedSegment_04 = ValueNotifier('Pending');
final List<Actor> actors = [
  Actor(age: 47, name: 'Leonardo', lastName: 'DiCaprio', status: 'Pending'),
  Actor(age: 58, name: 'Johnny', lastName: 'Depp', status: 'Completed'),
  Actor(age: 78, name: 'Robert', lastName: 'De Niro', status: 'Pending'),
  Actor(age: 44, name: 'Tom', lastName: 'Hardy', status: 'Open'),
  Actor(age: 66, name: 'Denzel', lastName: 'Washington', status: 'Completed'),
  Actor(age: 49, name: 'Ben', lastName: 'Affleck', status: 'Open'),
];

class _MVolunteerListScreenState extends State<MVolunteerListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Volunteers')),
        body: Stack(children: [
          Padding(
            padding: EdgeInsets.only(top: 20.0, left: 20, right: 20),
            child: SearchableList<Actor>(
              autoFocusOnSearch: false,
              initialList: actors
                  .where((element) =>
                      element.status.contains(_selectedSegment_04.value))
                  .toList(),
              builder: (Actor user) => ActorItem(actor: user),
              filter: (value) => actors
                  .where(
                    (element) => element.name.toLowerCase().contains(value),
                  )
                  .where((element) =>
                      element.status.contains(_selectedSegment_04.value))
                  .toList(),
              emptyWidget: const EmptyView(),
              inputDecoration: InputDecoration(
                labelText: "Search Actor",
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
          ),
        ]));
    ;
  }
}

class Actor {
  int age;
  String name;
  String lastName;
  String status;

  Actor({
    required this.age,
    required this.name,
    required this.lastName,
    required this.status,
  });
}

class ActorItem extends StatelessWidget {
  final Actor actor;

  const ActorItem({
    Key? key,
    required this.actor,
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
            Icon(
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
                  'Firstname: ${actor.name}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Lastname: ${actor.lastName}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Age: ${actor.age}',
                  style: const TextStyle(
                    color: Colors.black,
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(
          Icons.error,
          color: Colors.red,
        ),
        Text('no actor is found with this name'),
      ],
    );
  }
}
