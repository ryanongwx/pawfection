import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pawfection/manager/m_create_pet_screen.dart';
import 'package:pawfection/models/pet.dart';
import 'package:pawfection/repository/pet_repository.dart';
import 'package:pawfection/service/pet_service.dart';
import 'package:searchable_listview/searchable_listview.dart';
import 'package:pawfection/manager/m_pet_dialog.dart' as Dialog;

class MPetScreen extends StatefulWidget {
  final FirebaseFirestore firebaseFirestore;
  MPetScreen({super.key, required this.firebaseFirestore});

  @override
  State<MPetScreen> createState() => _MPetScreenState();
}

late PetRepository petRepository;
late PetService petService;

class _MPetScreenState extends State<MPetScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    petRepository = PetRepository(widget.firebaseFirestore);
    petService = PetService(widget.firebaseFirestore);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: petRepository.pets,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        // Convert to List
        List<Pet> petList = petService.snapshotToPetList(snapshot);

        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        return Scaffold(
            appBar: AppBar(
              title: const Text('Pets'),
              actions: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MCreatePetScreen(
                                    imageURL:
                                        'https://firebasestorage.googleapis.com/v0/b/pawfection-c14ed.appspot.com/o/profilepictures%2FFlFhhBapCZOzattk8mT1CMNxou22?alt=media&token=530bd4b2-95b6-45dc-88f0-9abf64d2a916',
                                  )),
                        );
                      },
                      child: const Icon(
                        Icons.add,
                        size: 26.0,
                      ),
                    )),
              ],
            ),
            body: Stack(children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.75,
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 20.0, left: 20, right: 20),
                  child: SearchableList<Pet>(
                    autoFocusOnSearch: false,
                    initialList: petList,
                    filter: (value) => petList
                        .where((element) =>
                            element.name.contains(value.toLowerCase()))
                        .toList(),
                    builder: (Pet pet) => PetItem(
                      pet: pet,
                      firebaseFirestore: widget.firebaseFirestore,
                    ),
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
              // Padding(
              //     padding: EdgeInsets.only(bottom: 100),
              //     child: Align(
              //       alignment: Alignment.bottomCenter,
              //       child: ElevatedButton(
              //           onPressed: () {
              //             Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                   builder: (context) => MCreatePetScreen()),
              //             );
              //           },
              //           child: Text('Create Pet')),
              //     )),
            ]));
      },
    );
  }
}

class PetItem extends StatelessWidget {
  final Pet pet;
  final FirebaseFirestore firebaseFirestore;

  PetItem({
    Key? key,
    required this.pet,
    required this.firebaseFirestore,
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
              debugPrint(pet.name);
              Dialog.displayPetItemDialog(context, pet.referenceId!);
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  (firebaseFirestore is FakeFirebaseFirestore)
                      ? Column()
                      : ClipOval(
                          child: Material(
                            color: Colors.transparent,
                            child: Ink.image(
                              image: Image.network(pet.profilepicture).image,
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
        Text('No Pet with this name is found'),
      ],
    );
  }
}
