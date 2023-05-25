import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_segment/flutter_advanced_segment.dart';
import 'package:pawfection/models/user.dart';
import 'package:pawfection/services/data_repository.dart';
import 'package:searchable_listview/searchable_listview.dart';

class MVolunteerListScreen extends StatefulWidget {
  const MVolunteerListScreen({super.key});

  @override
  State<MVolunteerListScreen> createState() => _MVolunteerListScreenState();
}

final DataRepository repository = DataRepository();

List<User> userList = [];

class _MVolunteerListScreenState extends State<MVolunteerListScreen> {

  // @override
  // void initState() {
  // // TODO: implement initState
  // super.initState();
  // Future<void> fetchUserList() async {
  //   Future<List<User>> userListFuture = repository.getUserList();
  //   userList = await userListFuture;
  // }

  // fetchUserList();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: DataRepository().users,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        // Convert to List
        List<User> userList = DataRepository().snapshotToUserList(snapshot);

        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        return Scaffold(
            appBar: AppBar(title: const Text('Pets')),
            body: Stack(children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
                child: SearchableList<User>(
                  autoFocusOnSearch: false,
                  initialList: userList,
                  filter: (value) =>
                      userList
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
            ]));
      },
    );
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
                  user.username,
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
        Text('No User with this name is found'),
      ],
    );
  }
}
