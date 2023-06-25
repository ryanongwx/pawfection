import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:pawfection/repository/pet_repository.dart';

void main() {
  late PetRepository petRepo;
  late FakeFirebaseFirestore instance;

  // Sets up a new FakeFirebaseFirestore instance for each test
  setUp(() {
    instance = FakeFirebaseFirestore();
    petRepo = PetRepository(instance);
  });

  // Tears down the instance at the end of each test
  tearDown(() {
    instance = FakeFirebaseFirestore();
  });

  test('addPetRepo', () async {
    // Arrange
    final pet = {
      'name': 'Catto',
      'breed': 'Persian',
      'description': 'A nice cat',
      'profilepicture': 'assets/images/user_profile.png'
    };

    // Act
    await petRepo.addPetRepo(pet);

    // Assert
    final snapshot = await instance.collection('pets').get();
    expect(snapshot.docs.length, 1);
    expect(snapshot.docs.first.get('name'), 'Catto');
  });
}
