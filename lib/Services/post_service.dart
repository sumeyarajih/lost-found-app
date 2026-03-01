import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/post.dart';

class PostService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Create a new post
  Future<Post?> createPost(Post post) async {
    try {
      final response = await _supabase
          .from('lost_found')
          .insert(post.toMap())
          .select()
          .single();

      return Post.fromMap(response, response['id']);
    } catch (e) {
      print('Error creating post: $e');
      return null;
    }
  }

  // Get all posts
  Future<List<Post>> getAllPosts() async {
    try {
      final response = await _supabase
          .from('lost_found')
          .select()
          .order('created_at', ascending: false);

      return response.map<Post>((json) => 
        Post.fromMap(json, json['id'])).toList();
    } catch (e) {
      print('Error fetching posts: $e');
      return [];
    }
  }

  // Get posts by category (Lost/Found)
  Future<List<Post>> getPostsByCategory(String category) async {
    try {
      final response = await _supabase
          .from('lost_found')
          .select()
          .eq('category', category)
          .order('created_at', ascending: false);

      return response.map<Post>((json) => 
        Post.fromMap(json, json['id'])).toList();
    } catch (e) {
      print('Error fetching posts: $e');
      return [];
    }
  }

  // Get posts by user ID
  Future<List<Post>> getUserPosts(String userId) async {
    try {
      final response = await _supabase
          .from('lost_found')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return response.map<Post>((json) => 
        Post.fromMap(json, json['id'])).toList();
    } catch (e) {
      print('Error fetching user posts: $e');
      return [];
    }
  }

  // Get single post by ID
  Future<Post?> getPostById(String postId) async {
    try {
      final response = await _supabase
          .from('lost_found')
          .select()
          .eq('id', postId)
          .single();

      return Post.fromMap(response, response['id']);
    } catch (e) {
      print('Error fetching post: $e');
      return null;
    }
  }

  // Update post status (for claiming)
  Future<bool> updatePostStatus(String postId, String status) async {
    try {
      await _supabase
          .from('lost_found')
          .update({'status': status})
          .eq('id', postId);
      return true;
    } catch (e) {
      print('Error updating post status: $e');
      return false;
    }
  }

  // Claim an item (with additional tracking)
  Future<bool> claimItem(String postId, String userId) async {
    try {
      // First check if item is already claimed
      final post = await getPostById(postId);
      if (post == null) return false;
      
      if (post.status != 'Active') {
        throw Exception('This item is no longer available');
      }

      await _supabase
          .from('lost_found')
          .update({
            'status': 'Claimed',
            'claimed_by': userId,
            'claimed_at': DateTime.now().toIso8601String(),
          })
          .eq('id', postId);
      return true;
    } catch (e) {
      print('Error claiming item: $e');
      return false;
    }
  }

  // Mark as resolved (owner confirms item is returned)
  Future<bool> resolveItem(String postId, String userId) async {
    try {
      // Verify the user is the owner
      final post = await getPostById(postId);
      if (post == null) return false;
      
      if (post.userId != userId) {
        throw Exception('Only the owner can resolve this item');
      }

      await _supabase
          .from('lost_found')
          .update({'status': 'Resolved'})
          .eq('id', postId);
      return true;
    } catch (e) {
      print('Error resolving item: $e');
      return false;
    }
  }

  // Update entire post
  Future<bool> updatePost(Post post) async {
    try {
      await _supabase
          .from('lost_found')
          .update(post.toMap())
          .eq('id', post.id!);
      return true;
    } catch (e) {
      print('Error updating post: $e');
      return false;
    }
  }

  // Delete post
  Future<bool> deletePost(String postId) async {
    try {
      await _supabase.from('lost_found').delete().eq('id', postId);
      return true;
    } catch (e) {
      print('Error deleting post: $e');
      return false;
    }
  }

  // Get unique locations for filter
  Future<List<String>> getAllLocations() async {
    try {
      final response = await _supabase
          .from('lost_found')
          .select('location');

      final List<dynamic> rows = response as List<dynamic>;
      
      final locations = rows
          .where((json) => json != null && json['location'] != null)
          .map<String>((json) => json['location'] as String)
          .toSet()
          .toList();
      
      locations.sort();
      return locations;
    } catch (e) {
      print('Error fetching locations: $e');
      return [];
    }
  }

  // Get posts with filters
  Future<List<Post>> getFilteredPosts({
    String? category,
    String? status,
    String? searchQuery,
    String? location,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      var query = _supabase.from('lost_found').select();

      if (category != null && category != 'All') {
        query = query.eq('category', category);
      }
      
      if (status != null && status != 'All') {
        query = query.eq('status', status);
      }

      if (location != null && location.isNotEmpty && location != 'All') {
        query = query.ilike('location', '%$location%');
      }

      if (startDate != null) {
        query = query.gte('date', startDate.toIso8601String());
      }

      if (endDate != null) {
        query = query.lte('date', endDate.toIso8601String());
      }
      
      final response = await query.order('created_at', ascending: false);
      
      List<Post> posts = response.map<Post>((json) => 
        Post.fromMap(json, json['id'])).toList();

      // Client-side search filtering (if needed)
      if (searchQuery != null && searchQuery.isNotEmpty) {
        posts = posts.where((post) =>
          post.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          (post.description?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false)
        ).toList();
      }

      return posts;
    } catch (e) {
      print('Error fetching filtered posts: $e');
      return [];
    }
  }
}