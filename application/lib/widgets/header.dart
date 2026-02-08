import 'package:application/pages/post_items_page.dart';
import 'package:flutter/material.dart';
import '../pages/profile_page.dart';
import '../pages/create_listing_page.dart';
import '../pages/favourites_page.dart';
import '../pages/messages_page.dart';

class Header extends StatelessWidget {
  Header({super.key});

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
            bg: cs.surface.withValues(alpha:0),
            iconColor: cs.primary,
            textColor: cs.onSurface,
          ),
          const SizedBox(width: 60),

          // Search bar
          Expanded(
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(28),
              ),
              padding: const EdgeInsets.only(left: 30, right: 6),
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
                    width: 40,
                    height: 40,
                    child: const Icon(Icons.search, color: Colors.white, size: 24),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 60),

          // Action icons
          _HoverScale(
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FavouritesPage()),
                );
              },
              tooltip: 'Wishlist',
              icon: const Icon(Icons.favorite_border, size: 30),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MessagesPage()),
              );
            },
            tooltip: 'Messages',
            icon: const Icon(Icons.chat_bubble_outline, size: 30),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PostItemsPage()),
              );
            },
            tooltip: 'Post Item',
            icon: const Icon(Icons.add_circle_outline, size: 30),
          ),
          IconButton(
            tooltip: 'Account',
            icon: const Icon(Icons.person_outline, size: 30),
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
  final Color iconColor;
  final Color textColor;

  const _LocationChip({
    required this.icon,
    required this.label,
    required this.bg,
    required this.iconColor,
    required this.textColor,
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
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(color: textColor, fontWeight: FontWeight.w500, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

/// Hover scale animation wrapper for subtle scale effect on mouse hover.
class _HoverScale extends StatefulWidget {
  final Widget child;
  final double hoverScale;

  const _HoverScale({
    required this.child,
    this.hoverScale = 1.1,
  });

  @override
  State<_HoverScale> createState() => _HoverScaleState();
}

class _HoverScaleState extends State<_HoverScale> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? widget.hoverScale : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
