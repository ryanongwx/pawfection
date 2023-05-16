import 'package:flutter/material.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter_advanced_segment/flutter_advanced_segment.dart';
import 'package:searchable_listview/searchable_listview.dart';

class ManagerView extends StatefulWidget {
  const ManagerView({super.key});

  @override
  State<ManagerView> createState() => _ManagerViewState();
}

class _ManagerViewState extends State<ManagerView> {
  final _pageController = PageController(initialPage: 1);

  int maxCount = 3;

  /// widget list
  final List<Widget> bottomBarPages = [
    const PetPage(),
    const DashboardPage(),
    const TaskPage(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
            bottomBarPages.length, (index) => bottomBarPages[index]),
      ),
      extendBody: true,
      bottomNavigationBar: (bottomBarPages.length <= maxCount)
          ? AnimatedNotchBottomBar(
              pageController: _pageController,
              color: Colors.white,
              showLabel: false,
              notchColor: Colors.black87,
              bottomBarItems: const [
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.pets,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.pets,
                    color: Colors.blueAccent,
                  ),
                  itemLabel: 'Pets',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.dashboard,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.dashboard,
                    color: Colors.blueAccent,
                  ),
                  itemLabel: 'Dashboard',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.task,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.task,
                    color: Colors.blueAccent,
                  ),
                  itemLabel: 'Tasks',
                ),
              ],
              onTap: (index) {
                /// control your animation using page controller
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeIn,
                );
              },
            )
          : null,
    );
  }
}

class PetPage extends StatefulWidget {
  const PetPage({Key? key}) : super(key: key);

  @override
  State<PetPage> createState() => _PetPageState();
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

class _PetPageState extends State<PetPage> {
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
              segments: {
                'Pending': 'Pending',
                'Completed': 'Completed',
                'Open': 'Open',
              },
              activeStyle: TextStyle(
                // TextStyle
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
              inactiveStyle: TextStyle(
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
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: const Center(child: Text('All-in-one Dashboard')));
  }
}

class TaskPage extends StatelessWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: const Center(child: Text('Create New Tasks')));
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
