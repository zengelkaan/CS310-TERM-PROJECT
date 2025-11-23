import 'vaccination.dart';

class Pet {
  final String name;
  final String breed;
  final String gender;
  final String age;
  final String imagePath; // asset path
  final String type; // e.g. Dog, Cat
  List<Vaccination> vaccinations;

  Pet({
    required this.name,
    required this.breed,
    required this.gender,
    required this.age,
    required this.imagePath,
    this.type = 'Unknown',
    List<Vaccination>? vaccinations,
  }) : vaccinations = vaccinations ?? [];
}

