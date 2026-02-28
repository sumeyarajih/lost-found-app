import 'package:flutter/material.dart';
import 'package:lost_found_app/auth/Login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/color.dart';
import '../constants/text_style.dart';
import '../Services/auth_service.dart';
import '../widget/cardPost.dart';
import 'editPost.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = Supabase.instance.client.auth.currentUser;
    String username = user?.userMetadata?['username'] ?? user?.email?.split('@')[0] ?? 'User';
    String email = user?.email ?? 'No email';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: AppColors.primary.withOpacity(0.2),
                    child: const Icon(Icons.person, size: 80, color: AppColors.primary),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: AppColors.primary,
                      radius: 18,
                      child: IconButton(
                        icon: const Icon(Icons.edit, size: 18, color: Colors.white),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              username,
              style: AppTextStyle.splashText.copyWith(fontSize: 24),
            ),
            Text(
              email,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildProfileOption(Icons.post_add, 'My Posts', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MyPostsScreen()),
                    );
                  }),
                  _buildProfileOption(Icons.settings, 'Settings', () {}),
                  _buildProfileOption(Icons.help_outline, 'Help & Support', () {}),
                  _buildProfileOption(Icons.logout, 'Logout', () async {
                    await AuthService.signOut();
                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                        (route) => false,
                      );
                    }
                  }, isLogout: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title, VoidCallback onTap, {bool isLogout = false}) {
    return ListTile(
      leading: Icon(icon, color: isLogout ? Colors.red : Colors.black),
      title: Text(
        title,
        style: TextStyle(
          color: isLogout ? Colors.red : Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}

class MyPostsScreen extends StatelessWidget {
  const MyPostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock user's posts
    final List<Map<String, dynamic>> myPosts = [
      {
        'title': 'My Lost Keys',
        'description': 'Lost my house keys yesterday.',
        'category': 'Lost',
        'location': 'Downtown',
        'date': 'Feb 27, 2024',
        'status': 'Active',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Posts', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: myPosts.isEmpty
          ? const Center(child: Text('You haven\'t posted anything yet.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: myPosts.length,
              itemBuilder: (context, index) {
                final post = myPosts[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: CardPost(
                    title: post['title'],
                    description: post['description'],
                    category: post['category'],
                    location: post['location'],
                    date: post['date'],
                    status: post['status'],
                    isOwner: true,
                    onEdit: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditPostScreen(post: post),
                        ),
                      );
                    },
                    onDelete: () {
                      _showDeleteConfirmation(context, post['title']);
                    },
                  ),
                );
              },
            ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Post'),
        content: Text('Are you sure you want to delete "$title"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Post deleted successfully')),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
