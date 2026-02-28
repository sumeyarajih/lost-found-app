import 'package:flutter/material.dart';
import '../constants/color.dart';
import '../widget/cardPost.dart';

class AllPostsScreen extends StatefulWidget {
  final String initialCategory;

  const AllPostsScreen({super.key, this.initialCategory = 'All'});

  @override
  State<AllPostsScreen> createState() => _AllPostsScreenState();
}

class _AllPostsScreenState extends State<AllPostsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Mock data for demonstration
  final List<Map<String, dynamic>> _allPosts = [
    {
      'title': 'Lost Black Wallet',
      'description': 'Lost near Central Park. Contains ID and cards.',
      'category': 'Lost',
      'location': 'Central Park',
      'date': 'Jan 15, 2024',
      'status': 'Active',
    },
    {
      'title': 'Found Golden Retriever',
      'description': 'Friendly dog found near the library.',
      'category': 'Found',
      'location': 'Public Library',
      'date': 'Jan 18, 2024',
      'status': 'Active',
      'imageUrl': 'https://images.unsplash.com/photo-1552053831-71594a27632d?q=80&w=200&auto=format&fit=crop',
    },
    {
      'title': 'Lost iPhone 13',
      'description': 'Blue case, lost on subway.',
      'category': 'Lost',
      'location': 'Subway Line A',
      'date': 'Jan 20, 2024',
      'status': 'Claimed',
      'imageUrl': 'https://images.unsplash.com/photo-1632661674596-df8be070a5c5?q=80&w=200&auto=format&fit=crop',
    },
    {
      'title': 'Found Car Keys',
      'description': 'Toyota keys in parking lot.',
      'category': 'Found',
      'location': 'Town Mall',
      'date': 'Jan 22, 2024',
      'status': 'Active',
      'imageUrl': 'https://images.unsplash.com/photo-1605462863863-10d9e47e15ee?q=80&w=200&auto=format&fit=crop',
    },
  ];

  @override
  void initState() {
    super.initState();
    int initialIndex = widget.initialCategory == 'Lost' ? 1 : (widget.initialCategory == 'Found' ? 2 : 0);
    _tabController = TabController(length: 3, vsync: this, initialIndex: initialIndex);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _getFilteredPosts(String category) {
    return _allPosts.where((post) {
      bool matchesCategory = category == 'All' || post['category'] == category;
      bool matchesSearch = post['title'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          post['location'].toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('All Posts', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Lost'),
            Tab(text: 'Found'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search by title or location...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty 
                  ? IconButton(icon: const Icon(Icons.clear), onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    }) 
                  : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPostList('All'),
                _buildPostList('Lost'),
                _buildPostList('Found'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostList(String category) {
    final filteredPosts = _getFilteredPosts(category);

    if (filteredPosts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text('No posts found', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredPosts.length,
      itemBuilder: (context, index) {
        final post = filteredPosts[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: CardPost(
            title: post['title'],
            description: post['description'],
            category: post['category'],
            location: post['location'],
            date: post['date'],
            status: post['status'],
            onClaim: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Claim request sent for ${post['title']}')),
              );
            },
          ),
        );
      },
    );
  }
}
