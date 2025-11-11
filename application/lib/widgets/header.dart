import 'package:flutter/material.dart';
import '../pages/profile_page.dart';
import '../pages/create_listing_page.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 80),
      child: Row(
        children: [
          _LocationChip(
            icon: Icons.location_on,
            label: 'Bristol, UK',
            bg: Colors.grey.shade100,
            fg: cs.primary,
          ),
          const SizedBox(width: 60),

          // Search bar
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(28),
              ),
              padding: const EdgeInsets.only(left: 20, right: 8),
              child: Row(
                children: [
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search for an item',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: cs.primary,
                      shape: BoxShape.circle,
                    ),
                    width: 32,
                    height: 32,
                    child: const Icon(Icons.search, color: Colors.white, size: 18),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 60),

          // Action icons
          IconButton(
            onPressed: () {
              // Navigate to wishlist page
            },
            tooltip: 'Wishlist',
            icon: const Icon(Icons.favorite_border),
          ),
          IconButton(
            onPressed: () {
              // Navigate to messages page
            },
            tooltip: 'Messages',
            icon: const Icon(Icons.chat_bubble_outline),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateListingPage()),
              );
            },
            tooltip: 'Post Item',
            icon: const Icon(Icons.add_circle_outline),
          ),
          IconButton(
            tooltip: 'Account',
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Simple location chip widget (you can move this out to its own file later)
class _LocationChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color bg;
  final Color fg;

  const _LocationChip({
    required this.icon,
    required this.label,
    required this.bg,
    required this.fg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: fg, size: 18),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(color: fg, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
