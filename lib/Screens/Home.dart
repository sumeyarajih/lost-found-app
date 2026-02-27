import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/color.dart';
import '../constants/text_style.dart';
import '../widget/bottomNavbar.dart';
import '../widget/cardPost.dart';
import 'addPost.dart';
import 'profile.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  final User? user = Supabase.instance.client.auth.currentUser;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomeContent(),
      const AddPostScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    String username = user?.userMetadata?['username'] ?? user?.email?.split('@')[0] ?? 'User';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _currentIndex == 0 ? AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Lost & Found Board',
              style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.normal),
            ),
            Text(
              'Welcome, $username',
              style: AppTextStyle.splashText.copyWith(fontSize: 18),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none, color: Colors.black),
          ),
        ],
      ) : null,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: CustomBottomNavbar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data
    final List<Map<String, String>> mockItems = [
      {
        'title': 'Lost Black Wallet',
        'description': 'Lost near Central Park on Jan 15. Contains ID and credit cards.',
        'category': 'Lost',
        'location': 'Central Park',
        'date': 'Jan 15, 2024',
        'status': 'Active',
      },
      {
        'title': 'Found Golden Retriever',
        'description': 'Found a friendly golden retriever wandering near the library. No collar.',
        'category': 'Found',
        'location': 'Public Library',
        'date': 'Jan 18, 2024',
        'status': 'Active',
      },
      {
        'title': 'Lost iPhone 13',
        'description': 'iPhone 13 with a blue case lost on the subway.',
        'category': 'Lost',
        'location': 'Subway Line A',
        'date': 'Jan 20, 2024',
        'status': 'Claimed',
      },
      {
        'title': 'Found Car Keys',
        'description': 'Found Toyota car keys in the parking lot of the mall.',
        'category': 'Found',
        'location': 'Town Mall',
        'date': 'Jan 22, 2024',
        'status': 'Active',
      },
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search items...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.tune, color: AppColors.primary),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Recent Posts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextButton(onPressed: () {}, child: const Text('See All', style: TextStyle(color: AppColors.primary))),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: mockItems.length,
            itemBuilder: (context, index) {
              final item = mockItems[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: CardPost(
                  title: item['title']!,
                  description: item['description']!,
                  category: item['category']!,
                  location: item['location']!,
                  date: item['date']!,
                  status: item['status']!,
                  onClaim: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Claim request sent for ${item['title']}')),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
