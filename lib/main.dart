import 'package:flutter/material.dart';

void main() {
  runApp(const PawfectApp());
}

class PawfectApp extends StatelessWidget {
  const PawfectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pawfect Match',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        fontFamily: 'Roboto', 
      ),
      initialRoute: '/animals',
      routes: {
        '/animals': (context) => const AvailableAnimalsScreen(),
        '/chats': (context) => const ChatListScreen(),
        '/detail': (context) => const PetDetailScreen(),
      },
    );
  }
}

// ------------------ MODEL ------------------

class Pet {
  final String name;
  final String breed;
  final String gender;
  final String age;
  final String imagePath; 

  const Pet({
    required this.name,
    required this.breed,
    required this.gender,
    required this.age,
    required this.imagePath,
  });
}

const List<Pet> pets = [
  Pet(
    name: 'Max',
    breed: 'Golden Retriever',
    gender: 'Male',
    age: '3 years',
    imagePath: 'assets/images/max.jpg',
  ),
  Pet(
    name: 'Luna',
    breed: 'Siamese',
    gender: 'Female',
    age: '2 years',
    imagePath: 'assets/images/luna.jpg',
  ),
  Pet(
    name: 'Coco',
    breed: 'Holland Lop',
    gender: 'Female',
    age: '1 year',
    imagePath: 'assets/images/coco.jpg',
  ),
];

// ------------------ BOTTOM NAV ------------------

class AppBottomNav extends StatelessWidget {
  final int currentIndex;

  const AppBottomNav({super.key, required this.currentIndex});

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/animals');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/chats');
        break;
      default:
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _onTap(context, index),
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: ''),
      ],
    );
  }
}

// ------------------ AVAILABLE ANIMALS LIST ------------------

class AvailableAnimalsScreen extends StatelessWidget {
  const AvailableAnimalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // back icon
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.maybePop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              ),
              const SizedBox(height: 8),
              const Text(
                'Available Animals',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Find your perfect companion',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  itemCount: pets.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final pet = pets[index];
                    return _PetListItem(pet: pet);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PetListItem extends StatelessWidget {
  final Pet pet;

  const _PetListItem({required this.pet});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 36,
          backgroundImage: AssetImage(pet.imagePath),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pet.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Breed: ${pet.breed}\nGender: ${pet.gender}\nAge: ${pet.age}',
                style: const TextStyle(fontSize: 13, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 120,
                height: 34,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/detail',
                      arguments: pet,
                    );
                  },
                  child: const Text(
                    'View Details',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ------------------ CHAT LIST SCREEN ------------------

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  static const _names = [
    'Emir Özyeşil',
    'İrem Ulusal',
    'Mehmet Salcan',
    'Hilal Öngel',
    'Kaan Zengil',
    'Mehmet Topçu',
    'Fethi Topak',
    'Fatih Terim',
    'Victor Oshimen',
    'Kazımcan',
    'Cem Yılmaz',
    'Ana de Armas',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const AppBottomNav(currentIndex: 3),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.maybePop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: _names.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: Text(_names[index]),
                      trailing: const Icon(Icons.chat_bubble_outline),
                      onTap: () {},
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------ PET DETAIL SCREEN ------------------

class PetDetailScreen extends StatelessWidget {
  const PetDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Pet pet = ModalRoute.of(context)?.settings.arguments as Pet? ??
        pets.first; // default Max

    return Scaffold(
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              ),
              const SizedBox(height: 8),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.asset(
                      pet.imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                pet.name,
                style:
                const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // info rows
              _InfoRow(label: 'Breed', value: pet.breed),
              _InfoRow(label: 'Gender', value: pet.gender),
              _InfoRow(label: 'Age', value: pet.age),
              const SizedBox(height: 16),

              // About card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Row(
                        children: [
                          Icon(Icons.info_outline, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'About This Pet',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Max is a healthy 3-year-old Golden Retriever looking '
                            'for his first mate. Friendly, energetic, and ready '
                            'to breed responsibly!',
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Owner :',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const CircleAvatar(
                    radius: 18,
                    backgroundImage:
                    AssetImage('assets/images/owner_emily.jpg'),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Emily Clark',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/chats');
                    },
                    icon: const Icon(Icons.chat_bubble_outline, size: 18),
                    label: const Text('Message'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 36),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              '$label :',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        const Divider(height: 12),
      ],
    );
  }
}
