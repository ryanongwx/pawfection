import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pawfection/manager/m_create_user_screen.dart';
import 'package:pawfection/models/user.dart';
import 'package:pawfection/repository/user_repository.dart';
import 'package:pawfection/service/user_service.dart';
import 'package:pawfection/volunteer/widgets/profile_widget.dart';
import 'package:searchable_listview/searchable_listview.dart';
import 'package:pawfection/manager/m_user_dialog.dart' as Dialog;

class MVolunteerListScreen extends StatefulWidget {
  const MVolunteerListScreen({super.key});

  @override
  State<MVolunteerListScreen> createState() => _MVolunteerListScreenState();
}

final userRepository = UserRepository();
final userService = UserService();

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
      stream: userRepository.users,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        // Convert to List
        List<User> userList = userService.snapshotToUserList(snapshot);

        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        return Scaffold(
            appBar: AppBar(
              title: const Text('Volunteers'),
              actions: <Widget>[
                Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MCreateUserScreen()),
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
                  padding:
                      const EdgeInsets.only(top: 20.0, left: 20, right: 20),
                  child: SearchableList<User>(
                    autoFocusOnSearch: false,
                    initialList: userList,
                    filter: (value) => userList
                        .where((element) =>
                            element.username.contains(value.toLowerCase()))
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
              //                   builder: (context) => MCreateUserScreen()),
              //             );
              //           },
              //           child: Text('Create Volunteer')),
              //     )),
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
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(width: 2),
          ),
          child: InkWell(
            onTap: () {
              Dialog.displayUserItemDialog(context, user.referenceId!);
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  ClipOval(
                    child: Material(
                      color: Colors.transparent,
                      child: Ink.image(
                        image: Image.network(user.profilepicture).image,
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                      ),
                    ),
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
        Text('No User with this name is found'),
      ],
    );
  }
}
