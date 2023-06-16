import 'package:flutter/material.dart';
import 'package:pawfection/managerscreens/m_update_pet_screen.dart';
import 'package:pawfection/models/pet.dart';
import 'package:pawfection/repository/pet_repository.dart';
import 'package:pawfection/volunteerscreens/widgets/profile_widget.dart';

Future<void> displayPetItemDialog(BuildContext context, String id) async {
  final petRepository = PetRepository();
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: FutureBuilder<Pet?>(
          future: petRepository.findPetByPetID(id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // While waiting for the future to complete, show a loading indicator
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              // If an error occurs while fetching the user, display an error message
              return Text('Error: ${snapshot.error}');
            } else {
              // The future completed successfully
              final pet = snapshot.data;

              return (pet == null)
                  ? const Text('Error retrieving pet details')
                  : ListView(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 20),
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
                          padding: EdgeInsets.only(top: 30),
                          child: Center(
                            child: Text(
                              "${pet.name}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 48),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Breed: ${pet.breed}',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 48),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Description',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "${pet.description}",
                                  style: TextStyle(fontSize: 16, height: 1.4),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 48),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Things to note',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "${pet.thingstonote}",
                                  style: TextStyle(fontSize: 16, height: 1.4),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(right: 30, left: 30, top: 20),
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
                            child: Text('Edit'),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              right: 30, left: 30, top: 10, bottom: 30),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Return'),
                          ),
                        )
                      ],
                    );
            }
          },
        ),
      );
    },
  );
}
