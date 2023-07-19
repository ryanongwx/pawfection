import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawfection/manager/m_create_pet_screen.dart';
import 'package:pawfection/manager/m_pet_screen.dart';
import 'package:pawfection/models/pet.dart';
import 'package:pawfection/repository/pet_repository.dart';
import 'package:pawfection/service/pet_service.dart';

void main() {
  testWidgets('MPetScreen displays loading indicator while fetching pets',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: MPetScreen()));

    // Verify that the loading indicator is displayed
    expect(find.text('Loading'), findsOneWidget);

    // Ensure that the loading indicator disappears once the pets are fetched
    await tester.pumpAndSettle();
    expect(find.text('Loading'), findsNothing);
  });

  testWidgets('MPetScreen displays error message on snapshot error',
      (WidgetTester tester) async {
    // Mock a stream that throws an error
    final petRepositoryMock = PetRepositoryMock(hasError: true);
    final petServiceMock = PetServiceMock(petRepositoryMock);
    await tester.pumpWidget(MaterialApp(home: MPetScreen()));

    // Ensure that the error message is displayed
    expect(find.text('Something went wrong'), findsOneWidget);
  });

  testWidgets('MPetScreen displays pet items from snapshot',
      (WidgetTester tester) async {
    // Mock a stream that contains a list of pets
    final petRepositoryMock = PetRepositoryMock(hasError: false);
    final petServiceMock = PetServiceMock(petRepositoryMock);
    await tester.pumpWidget(MaterialApp(home: MPetScreen()));

    // Ensure that the pet items are displayed
    await tester.pumpAndSettle();
    expect(find.byType(PetItem), findsWidgets);
  });

  testWidgets('MPetScreen opens create pet screen when add button is tapped',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: MPetScreen()));

    // Tap on the add button
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Verify that the MCreatePetScreen is opened
    expect(find.byType(MCreatePetScreen), findsOneWidget);
  });
}

// Mock class for PetRepository
class PetRepositoryMock extends PetRepository {
  final bool hasError;

  PetRepositoryMock({this.hasError = false});

  @override
  Stream<QuerySnapshot> get pets {
    if (hasError) {
      return Stream.error(Exception('Mock Error'));
    } else {
      // Return a stream with a list of pets
      final pets = [
        Pet(name: 'Pet 1', profilepicture: 'image_url_1'),
        Pet(name: 'Pet 2', profilepicture: 'image_url_2'),
        // Add more pets as needed
      ];
      return Stream.value(QuerySnapshotMock(pets));
    }
  }
}

// Mock class for QuerySnapshot
class QuerySnapshotMock extends QuerySnapshot {
  final List<Pet> pets;

  QuerySnapshotMock(this.pets);

  @override
  List<QueryDocumentSnapshot> get docs =>
      pets.map((pet) => QueryDocumentSnapshotMock(pet)).toList();
}

// Mock class for QueryDocumentSnapshot
class QueryDocumentSnapshotMock extends QueryDocumentSnapshot {
  final Pet pet;

  QueryDocumentSnapshotMock(this.pet);

  @override
  Map<String, dynamic> data() => pet.toMap();
}

// Mock class for PetService
class PetServiceMock extends PetService {
  final PetRepositoryMock petRepositoryMock;

  PetServiceMock(this.petRepositoryMock);

  @override
  List<Pet> snapshotToPetList(AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.hasData) {
      final petsData = snapshot.data!.docs.map((doc) => doc.data()).toList();
      return petsData.map((data) => Pet.fromMap(data)).toList();
    } else {
      return [];
    }
  }
}
