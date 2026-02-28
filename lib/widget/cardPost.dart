import 'package:flutter/material.dart';
import '../constants/color.dart';

class CardPost extends StatelessWidget {
  final String title;
  final String description;
  final String category; // 'Lost' or 'Found'
  final String location;
  final String date;
  final String status; // 'Active' or 'Claimed'
  final bool isOwner;
  final VoidCallback? onClaim;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CardPost({
    super.key,
    required this.title,
    required this.description,
    required this.category,
    required this.location,
    required this.date,
    required this.status,
    this.isOwner = false,
    this.onClaim,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    bool isClaimed = status == 'Claimed';
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isClaimed ? Colors.grey[200] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: category == 'Lost' ? Colors.red[100] : Colors.green[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      color: category == 'Lost' ? Colors.red : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (isOwner)
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20, color: Colors.blue),
                        onPressed: onEdit,
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.only(right: 8),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                        onPressed: onDelete,
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  )
                else if (isClaimed)
                  const Text(
                    'CLAIMED',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(child: Text(location, style: const TextStyle(color: Colors.grey, fontSize: 12), overflow: TextOverflow.ellipsis)),
                const SizedBox(width: 16),
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
            if (!isClaimed && !isOwner) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onClaim,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Claim Item', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
