import 'package:flutter/material.dart';
import '../widgets/custom_bottom_nav.dart';

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
      bottomNavigationBar: const CustomBottomNav(currentIndex: 3),
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
              const SizedBox(height: 8),
              const Text(
                'Messages',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  itemCount: _names.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.person_outline)),
                      title: Text(_names[index]),
                      trailing: const Icon(Icons.chat_bubble_outline),
                      onTap: () {
                        Navigator.pushNamed(context, '/chat');
                      },
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

