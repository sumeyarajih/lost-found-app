class Post {
  final String? id;
  final String userId;
  final String title;
  final String? description;
  final String category;
  final String? location;
  final DateTime? date;
  final String? contactInfo;
  final String status;
  final DateTime? createdAt;
  final String? claimedBy; // Add this field
  final DateTime? claimedAt; // Add this field

  Post({
    this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.category,
    this.location,
    this.date,
    this.contactInfo,
    this.status = 'Active',
    this.createdAt,
    this.claimedBy,
    this.claimedAt,
  });

  factory Post.fromMap(Map<String, dynamic> map, String id) {
    return Post(
      id: id,
      userId: map['user_id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'],
      category: map['category'] ?? 'Lost',
      location: map['location'],
      date: map['date'] != null ? DateTime.parse(map['date']) : null,
      contactInfo: map['contact_info'],
      status: map['status'] ?? 'Active',
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      claimedBy: map['claimed_by'],
      claimedAt: map['claimed_at'] != null ? DateTime.parse(map['claimed_at']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'title': title,
      'description': description,
      'category': category,
      'location': location,
      'date': date?.toIso8601String(),
      'contact_info': contactInfo,
      'status': status,
      'claimed_by': claimedBy,
      'claimed_at': claimedAt?.toIso8601String(),
    };
  }
}