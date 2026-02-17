import 'package:application/pages/home_page.dart';
import 'package:application/pages/post_items_page.dart';
import 'package:flutter/material.dart';
import '../pages/profile_page.dart';
import '../pages/favourites_page.dart';
import '../pages/messages_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:application/widgets/hover_scale.dart';

class Header extends StatelessWidget {
  Header({
    super.key,
    this.showSearch = true,
    this.showBackButton = false,
    });

  final bool showSearch;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16, left: 15, right: 80),
      child: Row(
        children: [
          // Logo
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),
            tooltip: 'Home',
            icon: SvgPicture.asset(
              'assets/logo/logo-static.svg',
              height: 80,
            ),
          ),

          // back button
          if (showBackButton)
            IconButton(
              icon: const Icon(Icons.arrow_back, size: 28),
              tooltip: 'Back',
              onPressed: () {
                Navigator.pop(context);
              },
            ),

          const SizedBox(width: 24),
          
          // Location
          _LocationChip(
            icon: Icons.location_on,
            label: 'Bristol, UK',
            bg: cs.surface.withValues(alpha:0),
            iconColor: cs.primary,
            textColor: cs.onSurface,
          ),

          // Search bar
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: showSearch
                  ? ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: 280,
                        maxWidth: 620,
                      ),
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
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: cs.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.search,
                                  color: Colors.white, size: 24),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),

          // Action icons
          HoverScale(
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
          HoverScale(
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MessagesPage()),
                );
              },
              tooltip: 'Messages',
              icon: const Icon(Icons.chat_bubble_outline, size: 30),
            ),
          ),
          HoverScale(
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PostItemsPage()),
                );
              },
              tooltip: 'Post Item',
              icon: const Icon(Icons.add_circle_outline, size: 30),
            ),
          ),
          HoverScale(
            child: IconButton(
              tooltip: 'Account',
              icon: const Icon(Icons.person_outline, size: 30),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
            ),
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
