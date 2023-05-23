import 'package:flutter/material.dart';
import 'package:flutter_advanced_segment/flutter_advanced_segment.dart';
import 'package:pawfection/models/pet.dart';
import 'package:pawfection/services/data_repository.dart';
import 'package:searchable_listview/searchable_listview.dart';

class MPetScreen extends StatefulWidget {
  const MPetScreen({super.key});

  @override
  State<MPetScreen> createState() => _MPetScreenState();
}

final _selectedSegment_04 = ValueNotifier('Pending');

final DataRepository repository = DataRepository();

List<Pet> petList = [];

Future<void> fetchPetList() async {
  Future<List<Pet>> petListFuture = repository.getPetList();
  petList = await petListFuture;
}

class _MPetScreenState extends State<MPetScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchPetList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Volunteers')),
        body: Stack(children: [
          Padding(
            padding: EdgeInsets.only(top: 20.0, left: 20, right: 20),
            child: SearchableList<Pet>(
              autoFocusOnSearch: false,
              initialList: petList,
              filter: (value) => petList
                  .where((element) => element.name.contains(value))
                  .toList(),
              builder: (Pet pet) => PetItem(pet: pet),
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(
          Icons.error,
          color: Colors.red,
        ),
        Text('No Pet with this name is found'),
      ],
    );
  }
}
