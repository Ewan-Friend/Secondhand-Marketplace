import 'package:flutter/material.dart';

class UserWidget extends StatelessWidget {
  final String userName;
  final double rating;
  final int reviews;
  final String? avatarUrl; // Optional network image

  const UserWidget({
    Key? key,
    required this.userName,
    required this.rating,
    required this.reviews,
    this.avatarUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        // Circular Avatar
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.grey.shade300,
          backgroundImage:
              avatarUrl != null ? NetworkImage(avatarUrl!) : null,
          child: avatarUrl == null ? Icon(Icons.person_2, size: 24, color: Colors.grey.shade500) : null,
        ),
        SizedBox(width: 12),
        // User Info
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userName,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.star, color: cs.primary, size: 14),
                SizedBox(width: 4),
                Text(
                  rating.toStringAsFixed(2),
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(width: 6),
                Text(
                  '· $reviews reviews',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
