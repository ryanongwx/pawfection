import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_segment/flutter_advanced_segment.dart';
import 'package:pawfection/managerscreens/m_create_pet_screen.dart';
import 'package:pawfection/models/pet.dart';
import 'package:pawfection/services/data_repository.dart';
import 'package:searchable_listview/searchable_listview.dart';
import 'package:pawfection/services/data_repository.dart';
import 'package:pawfection/models/pet.dart';

class MPetScreen extends StatefulWidget {
  const MPetScreen({super.key});

  @override
  State<MPetScreen> createState() => _MPetScreenState();
}

final DataRepository repository = DataRepository();

// List<Pet> petList = [];

// Future<void> fetchPetList() async {
//   Future<List<Pet>> petListFuture = repository.getPetList();
//   petList = await petListFuture;
// }

class _MPetScreenState extends State<MPetScreen> {
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   fetchPetList();
  // }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: DataRepository().pets,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        // Convert to List
        List<Pet> petList = DataRepository().snapshotToPetList(snapshot);

        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        return Scaffold(
            appBar: AppBar(title: const Text('Pets')),
            body: Stack(children: [
              SizedBox(
                height: 550,
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 20.0, left: 20, right: 20),
                  child: SearchableList<Pet>(
                    autoFocusOnSearch: false,
                    initialList: petList,
                    filter: (value) => petList
                        .where((element) => element.name.contains(value))
                        .toList(),
                    builder: (Pet pet) => PetItem(pet: pet),
                    emptyWidget: const EmptyView(),
                    inputDecoration: InputDecoration(
                      labelText: "Search Pet",
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
              Padding(
                  padding: EdgeInsets.only(bottom: 100),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MCreatePetScreen()),
                          );
                        },
                        child: Text('Create Pet')),
                  )),
            ]));
      },
    );
  }
}

class PetItem extends StatelessWidget {
  final Pet pet;

  const PetItem({
    Key? key,
    required this.pet,
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
                  '${pet.name}',
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
        Text('No Pet with this name is found'),
      ],
    );
  }
}
