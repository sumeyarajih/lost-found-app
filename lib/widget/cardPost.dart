// import 'package:flutter/material.dart';
// import '../constants/color.dart';

// class CardPost extends StatelessWidget {
//   final String title;
//   final String description;
//   final String category; // 'Lost' or 'Found'
//   final String location;
//   final String date;
//   final String status; // 'Active' or 'Claimed'
//   final bool isOwner;
//   final VoidCallback? onClaim;
//   final VoidCallback? onEdit;
//   final VoidCallback? onDelete;

//   const CardPost({
//     super.key,
//     required this.title,
//     required this.description,
//     required this.category,
//     required this.location,
//     required this.date,
//     required this.status,
//     this.isOwner = false,
//     this.onClaim,
//     this.onEdit,
//     this.onDelete,
//   });

//   @override
//   Widget build(BuildContext context) {
//     bool isClaimed = status == 'Claimed';
    
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       color: isClaimed ? Colors.grey[200] : Colors.white,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: category == 'Lost' ? Colors.red[100] : Colors.green[100],
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Text(
//                     category,
//                     style: TextStyle(
//                       color: category == 'Lost' ? Colors.red : Colors.green,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 if (isOwner)
//                   Row(
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.edit, size: 20, color: Colors.blue),
//                         onPressed: onEdit,
//                         constraints: const BoxConstraints(),
//                         padding: const EdgeInsets.only(right: 8),
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.delete, size: 20, color: Colors.red),
//                         onPressed: onDelete,
//                         constraints: const BoxConstraints(),
//                         padding: EdgeInsets.zero,
//                       ),
//                     ],
//                   )
//                 else if (isClaimed)
//                   const Text(
//                     'CLAIMED',
//                     style: TextStyle(
//                       color: Colors.grey,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               description,
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//               style: TextStyle(color: Colors.grey[700]),
//             ),
//             const SizedBox(height: 12),
//             Row(
//               children: [
//                 const Icon(Icons.location_on, size: 16, color: Colors.grey),
//                 const SizedBox(width: 4),
//                 Expanded(child: Text(location, style: const TextStyle(color: Colors.grey, fontSize: 12), overflow: TextOverflow.ellipsis)),
//                 const SizedBox(width: 16),
//                 const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
//                 const SizedBox(width: 4),
//                 Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
//               ],
//             ),
//             if (!isClaimed && !isOwner) ...[
//               const SizedBox(height: 16),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: onClaim,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primary,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                   ),
//                   child: const Text('Claim Item', style: TextStyle(color: Colors.white)),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../constants/color.dart';

class CardPost extends StatelessWidget {
  final String title;
  final String description;
  final String category;
  final String location;
  final String date;
  final String status;
  final VoidCallback? onClaim;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onResolve;
  final bool isOwner;
  final String? claimedBy;
  final String? imageUrl;

  const CardPost({
    super.key,
    required this.title,
    required this.description,
    required this.category,
    required this.location,
    required this.date,
    required this.status,
    this.onClaim,
    this.onEdit,
    this.onDelete,
    this.onResolve,
    this.isOwner = false,
    this.claimedBy,
    this.imageUrl,
  });

  Color _getCategoryColor() {
    return category == 'Lost' ? Colors.orange : Colors.green;
  }

  Color _getStatusColor() {
    switch (status) {
      case 'Active':
        return Colors.green;
      case 'Claimed':
        return Colors.blue;
      case 'Resolved':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon() {
    switch (status) {
      case 'Active':
        return Icons.fiber_new;
      case 'Claimed':
        return Icons.hourglass_empty;
      case 'Resolved':
        return Icons.check_circle;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isActive = status == 'Active';
    final bool isClaimed = status == 'Claimed';
    final bool isResolved = status == 'Resolved';

    return Container(
      decoration: BoxDecoration(
        color: isResolved ? Colors.grey[50] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isResolved ? Colors.grey[300]! : Colors.transparent,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageUrl != null)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                imageUrl!,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 150,
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with category, status, and owner controls
                Row(
                  children: [
                    // Category chip
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getCategoryColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            category == 'Lost' ? Icons.search_off : Icons.pets,
                            size: 14,
                            color: _getCategoryColor(),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            category,
                            style: TextStyle(
                              color: _getCategoryColor(),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    
                    // Status chip
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getStatusIcon(),
                            size: 14,
                            color: _getStatusColor(),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            status,
                            style: TextStyle(
                              color: _getStatusColor(),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const Spacer(),
                    
                    // Owner controls (Edit/Delete)
                    if (isOwner && isActive) ...[
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, size: 18, color: AppColors.primary),
                              onPressed: onEdit,
                              constraints: const BoxConstraints(),
                              padding: const EdgeInsets.all(8),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                              onPressed: onDelete,
                              constraints: const BoxConstraints(),
                              padding: const EdgeInsets.all(8),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Title
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isResolved ? Colors.grey[600] : Colors.black,
                    decoration: isResolved ? TextDecoration.lineThrough : null,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Description
                Text(
                  description,
                  style: TextStyle(
                    color: isResolved ? Colors.grey[500] : Colors.grey[600],
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 12),
                
                // Location and Date
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        location,
                        style: TextStyle(
                          color: isResolved ? Colors.grey[400] : Colors.grey[500],
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.calendar_today, size: 14, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(
                      date,
                      style: TextStyle(
                        color: isResolved ? Colors.grey[400] : Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                
                // Claimed by info
                if (isClaimed && claimedBy != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info, size: 16, color: Colors.blue),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'This item has been claimed and is waiting for owner confirmation',
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                
                const SizedBox(height: 16),
                
                // Action buttons based on status and ownership
                if (!isOwner) ...[
                  if (isActive && onClaim != null)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onClaim,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Claim This Item'),
                      ),
                    ),
                  if (isClaimed)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          'Item Claimed - Pending Confirmation',
                          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  if (isResolved)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          'Item Resolved',
                          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
                
                // Owner resolve button
                if (isOwner && isClaimed && onResolve != null)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onResolve,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Confirm Item Returned'),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}