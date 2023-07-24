import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pawfection/manager/m_update_pet_screen.dart';
import 'package:pawfection/models/pet.dart';
import 'package:pawfection/service/pet_service.dart';

Future<void> displayPetItemDialog(BuildContext context, String id) async {
  final petService = PetService(FirebaseFirestore.instance);

  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: FutureBuilder<Pet?>(
          future: petService.findPetByPetID(id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // While waiting for the future to complete, show a loading indicator
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              // If an error occurs while fetching the user, display an error message
              return Text('Error: ${snapshot.error}');
            } else {
              // The future completed successfully
              final pet = snapshot.data;

              return (pet == null)
                  ? const Text('Error retrieving pet details')
                  : Stack(
                      alignment: Alignment.topRight,
                      children: [
                        ListView(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: ClipOval(
                                child: Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: NetworkImage(pet.profilepicture),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 30),
                              child: Center(
                                child: Text(
                                  pet.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 48),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Breed: ${pet.breed}',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 30),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 48),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Description',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "${pet.description}",
                                      style: const TextStyle(
                                          fontSize: 16, height: 1.4),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 30),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 48),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Things to note',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "${pet.thingstonote}",
                                      style: const TextStyle(
                                          fontSize: 16, height: 1.4),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 30, left: 30, top: 20),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => MUpdatePetScreen(
                                              pet: pet,
                                              imageURL: '',
                                            )),
                                  );
                                },
                                child: const Text('Edit'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 30, left: 30, top: 10, bottom: 30),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Return'),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Confirm Delete"),
                                  content: const Text(
                                      "Are you sure you want to delete this pet?"),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text("Cancel"),
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                    ),
                                    TextButton(
                                      child: const Text("Delete"),
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      },
                                    ),
                                  ],
                                ),
                              );

                              if (confirmed ?? false) {
                                petService.deletePet(pet);
                                Navigator.of(context).pop();
                              }
                            },
                          ),
                        ),
                      ],
                    );
            }
          },
        ),
      );
    },
  );
}
