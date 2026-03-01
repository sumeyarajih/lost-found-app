import 'package:flutter/material.dart';
import 'package:lost_found_app/Screens/editPost.dart';
import 'package:lost_found_app/Services/post_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/color.dart';
import '../models/post.dart';
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
  final PostService _postService = PostService();
  final User? _currentUser = Supabase.instance.client.auth.currentUser;
  
  List<Post> _allPosts = [];
  List<Post> _filteredPosts = [];
  bool _isLoading = true;
  String _searchQuery = '';
  
  // Filter variables
  String _selectedLocation = 'All';
  String _selectedStatus = 'All';
  DateTime? _selectedDate;
  List<String> _locations = ['All'];
  
  // Filter visibility
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    int initialIndex = widget.initialCategory == 'Lost' ? 1 : (widget.initialCategory == 'Found' ? 2 : 0);
    _tabController = TabController(length: 3, vsync: this, initialIndex: initialIndex);
    _tabController.addListener(_handleTabChange);
    _fetchAllPosts();
    _fetchLocations();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      _applyFilters();
    }
  }

  Future<void> _fetchLocations() async {
    final locations = await _postService.getAllLocations();
    if (mounted) {
      setState(() {
        _locations = ['All', ...locations];
      });
    }
  }

  Future<void> _fetchAllPosts() async {
    setState(() => _isLoading = true);
    try {
      final posts = await _postService.getAllPosts();
      if (mounted) {
        setState(() {
          _allPosts = posts;
          _applyFilters();
        });
      }
    } catch (e) {
      print('Error fetching posts: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _applyFilters() {
    String currentCategory = _getCurrentCategory();
    
    _filteredPosts = _allPosts.where((post) {
      // Category filter
      bool matchesCategory = currentCategory == 'All' || post.category == currentCategory;
      
      // Status filter
      bool matchesStatus = _selectedStatus == 'All' || post.status == _selectedStatus;
      
      // Location filter
      bool matchesLocation = _selectedLocation == 'All' || post.location == _selectedLocation;
      
      // Date filter
      bool matchesDate = true;
      if (_selectedDate != null && post.date != null) {
        matchesDate = post.date!.year == _selectedDate!.year &&
                     post.date!.month == _selectedDate!.month &&
                     post.date!.day == _selectedDate!.day;
      }
      
      // Search query
      bool matchesSearch = _searchQuery.isEmpty ||
          post.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (post.description?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false) ||
          (post.location?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
      
      return matchesCategory && matchesStatus && matchesLocation && matchesDate && matchesSearch;
    }).toList();
  }

  String _getCurrentCategory() {
    switch (_tabController.index) {
      case 0:
        return 'All';
      case 1:
        return 'Lost';
      case 2:
        return 'Found';
      default:
        return 'All';
    }
  }

  void _clearFilters() {
    setState(() {
      _selectedLocation = 'All';
      _selectedStatus = 'All';
      _selectedDate = null;
      _searchController.clear();
      _searchQuery = '';
      _applyFilters();
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _applyFilters();
      });
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
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
        actions: [
          IconButton(
            icon: Icon(_showFilters ? Icons.filter_list : Icons.filter_list_alt),
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchAllPosts,
          ),
        ],
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
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                  _applyFilters();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search by title, description, or location...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty 
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                          _applyFilters();
                        });
                      }
                    ) 
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
          
          // Filter Section
          if (_showFilters) ...[
            Container(
              color: Colors.grey[50],
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filters',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: _clearFilters,
                        child: const Text('Clear All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        // Location Filter
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: DropdownButton<String>(
                            value: _selectedLocation,
                            hint: const Text('Location'),
                            underline: const SizedBox(),
                            items: _locations.map((location) {
                              return DropdownMenuItem(
                                value: location,
                                child: Text(location),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedLocation = value!;
                                _applyFilters();
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        
                        // Status Filter
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: DropdownButton<String>(
                            value: _selectedStatus,
                            hint: const Text('Status'),
                            underline: const SizedBox(),
                            items: ['All', 'Active', 'Claimed', 'Resolved'].map((status) {
                              return DropdownMenuItem(
                                value: status,
                                child: Text(status),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedStatus = value!;
                                _applyFilters();
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        
                        // Date Filter
                        GestureDetector(
                          onTap: () => _selectDate(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                                const SizedBox(width: 8),
                                Text(
                                  _selectedDate == null
                                      ? 'Select Date'
                                      : '${_selectedDate!.month}/${_selectedDate!.day}/${_selectedDate!.year}',
                                  style: TextStyle(
                                    color: _selectedDate == null ? Colors.grey[600] : Colors.black,
                                  ),
                                ),
                                if (_selectedDate != null) ...[
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedDate = null;
                                        _applyFilters();
                                      });
                                    },
                                    child: Icon(Icons.close, size: 16, color: Colors.grey[600]),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          // Results count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  '${_filteredPosts.length} items found',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // Posts List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredPosts.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off, size: 80, color: Colors.grey[300]),
                            const SizedBox(height: 16),
                            Text(
                              'No posts found',
                              style: TextStyle(color: Colors.grey[600], fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try adjusting your filters',
                              style: TextStyle(color: Colors.grey[500], fontSize: 14),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _clearFilters,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                              ),
                              child: const Text('Clear Filters'),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _fetchAllPosts,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredPosts.length,
                          itemBuilder: (context, index) {
                            final post = _filteredPosts[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: CardPost(
                                title: post.title,
                                description: post.description ?? '',
                                category: post.category,
                                location: post.location ?? 'Unknown',
                                date: _formatDate(post.date ?? post.createdAt),
                                status: post.status,
                                isOwner: _currentUser?.id == post.userId,
                                claimedBy: post.claimedBy,
                                onClaim: post.status == 'Active' && _currentUser?.id != post.userId
                                    ? () => _handleClaim(post)
                                    : null,
                                onEdit: _currentUser?.id == post.userId
                                    ? () => _handleEdit(post)
                                    : null,
                                onDelete: _currentUser?.id == post.userId
                                    ? () => _handleDelete(post)
                                    : null,
                                onResolve: post.status == 'Claimed' && _currentUser?.id == post.userId
                                    ? () => _handleResolve(post)
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleClaim(Post post) async {
    if (_currentUser == null) {
      _showSnackBar('Please login to claim items', isError: true);
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Claim Item'),
        content: Text('Are you sure you want to claim "${post.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Claim', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);
    try {
      final success = await _postService.claimItem(post.id!, _currentUser.id);
      if (success && mounted) {
        _showSnackBar('Item claimed successfully! The owner will be notified.');
        _fetchAllPosts();
      }
    } catch (e) {
      _showSnackBar('Error claiming item: ${e.toString()}', isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleResolve(Post post) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mark as Resolved'),
        content: Text('Have you received your "${post.title}" back?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes, Resolve', style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);
    try {
      final success = await _postService.resolveItem(post.id!, _currentUser!.id);
      if (success && mounted) {
        _showSnackBar('Item marked as resolved!');
        _fetchAllPosts();
      }
    } catch (e) {
      _showSnackBar('Error: ${e.toString()}', isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleEdit(Post post) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPostScreen(post: post),
      ),
    );
    if (result == true) {
      _fetchAllPosts();
    }
  }

  Future<void> _handleDelete(Post post) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Post'),
        content: Text('Are you sure you want to delete "${post.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);
    try {
      final success = await _postService.deletePost(post.id!);
      if (success && mounted) {
        _showSnackBar('Post deleted successfully');
        _fetchAllPosts();
      }
    } catch (e) {
      _showSnackBar('Error deleting post: ${e.toString()}', isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown date';
    return '${date.month}/${date.day}/${date.year}';
  }
}