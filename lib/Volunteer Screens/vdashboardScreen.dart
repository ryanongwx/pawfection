import 'package:flutter/material.dart';
import 'package:flutter_advanced_segment/flutter_advanced_segment.dart';
import 'package:searchable_listview/searchable_listview.dart';

class VDashboardScreen extends StatefulWidget {
  const VDashboardScreen({super.key});

  @override
  State<VDashboardScreen> createState() => _VDashboardScreenState();
}

final _selectedSegment_04 = ValueNotifier('all');
final List<Actor> actors = [
  Actor(age: 47, name: 'Leonardo', lastName: 'DiCaprio'),
  Actor(age: 58, name: 'Johnny', lastName: 'Depp'),
  Actor(age: 78, name: 'Robert', lastName: 'De Niro'),
  Actor(age: 44, name: 'Tom', lastName: 'Hardy'),
  Actor(age: 66, name: 'Denzel', lastName: 'Washington'),
  Actor(age: 49, name: 'Ben', lastName: 'Affleck'),
];

class _VDashboardScreenState extends State<VDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Padding(
          padding: EdgeInsets.all(20.0),
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
              backgroundColor: Colors.black26, // Color
              sliderColor: Colors.white, // Color
              sliderOffset: 2.0, // Double
              borderRadius:
                  const BorderRadius.all(Radius.circular(8.0)), // BorderRadius
              itemPadding: const EdgeInsets.symmetric(
                // EdgeInsets
                horizontal: 15,
                vertical: 10,
              ),
              animationDuration: Duration(milliseconds: 250), // Duration
            ),
          )),
      Padding(
        padding: EdgeInsets.only(top: 75.0),
        child: SearchableList<Actor>(
          autoFocusOnSearch: false,
          initialList: actors,
          builder: (Actor user) => ActorItem(actor: user),
          filter: (value) => actors
              .where(
                (element) => element.name.toLowerCase().contains(value),
              )
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

  Actor({
    required this.age,
    required this.name,
    required this.lastName,
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
              Icons.star,
              color: Colors.yellow[700],
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
