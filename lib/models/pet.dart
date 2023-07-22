class Pet {
  String? referenceId;
  String name;
  String? breed;
  String? description;
  String? thingstonote;
  String profilepicture;

  Pet(this.name,
      {this.referenceId,
      this.breed,
      this.description,
      this.thingstonote,
      required this.profilepicture});

  @override
  String toString() => 'Pet<$name>';
}
