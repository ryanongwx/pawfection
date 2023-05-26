import 'package:flutter/material.dart';
import 'package:flutter_advanced_segment/flutter_advanced_segment.dart';
import 'package:pawfection/managerscreens/m_create_user_screen.dart';
import 'package:pawfection/models/user.dart';
import 'package:pawfection/services/data_repository.dart';
import 'package:searchable_listview/searchable_listview.dart';

class MVolunteerListScreen extends StatefulWidget {
  const MVolunteerListScreen({super.key});

  @override
  State<MVolunteerListScreen> createState() => _MVolunteerListScreenState();
}

final _selectedSegment_04 = ValueNotifier('Pending');

final DataRepository repository = DataRepository();

List<User> userList = [];

class _MVolunteerListScreenState extends State<MVolunteerListScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future<void> fetchUserList() async {
      Future<List<User>> userListFuture = repository.getUserList();
      userList = await userListFuture;
    }

    fetchUserList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Volunteers')),
        body: Stack(children: [
          Container(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: 550,
                child: Padding(
                  padding: EdgeInsets.only(top: 20.0, left: 20, right: 20),
                  child: SearchableList<User>(
                    autoFocusOnSearch: false,
                    initialList: userList,
                    filter: (value) => userList
                        .where((element) => element.username.contains(value))
                        .toList(),
                    builder: (User user) => UserItem(user: user),
                    emptyWidget: const EmptyView(),
                    inputDecoration: InputDecoration(
                      labelText: "Search Volunteer",
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
              )),
          Padding(
              padding: EdgeInsets.only(bottom: 100),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MCreateUserScreen()),
                      );
                    },
                    child: Text('Create Volunteer')),
              )),
        ]));
    ;
  }
}

class UserItem extends StatelessWidget {
  final User user;

  const UserItem({
    Key? key,
    required this.user,
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
                  '${user.username}',
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(
          Icons.error,
          color: Colors.red,
        ),
        Text('No User with this name is found'),
      ],
    );
  }
}
