import 'package:flutter/material.dart';
import '../widgets/header.dart';
import '../services/api_service.dart';
import '../models/item_model.dart';

class ItemDetailPage extends StatefulWidget {
  // accepts the ID from the
  final String? itemId;
  const ItemDetailPage({super.key, this.itemId});
  
  @override
  State<ItemDetailPage> createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetailPage> {
  // Takes the id that was passed in from the navigator of the item widget
  late Future<Item> _itemFuture;
  final APIService _apiService = APIService();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Extracting arguments is best done here or in build, 
    final itemId = widget.itemId;
    _itemFuture = _apiService.getItemFromID(itemId);
  }

  

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      // Header (navigation bar)
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: Header(showSearch: false, showBackButton: true), // search functionality disabled
      ),
      body: SafeArea(
        // CREATE THE ITEM INFO HOORAY
        child: FutureBuilder<Item>(
          future: _itemFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('Item not found'));
            }

            final item = snapshot.data!;

            // Data is fetched
            return LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 980;
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      // Title row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              item.title  ,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                              )
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.favorite_border),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Location line
                      Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.location_on,
                                size: 18, color: Colors.red.shade400),
                            const SizedBox(width: 6),
                                Text('Redland, Bristol, UK',
                                style: TextStyle(fontSize: 13, color: Colors.black54)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Main content area
                      isWide
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Left: media + description
                                Expanded(
                                  flex: 7,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 400,
                                        child: _ImageCarousel(imageUrls: item.imageUrls),
                                      ),
                                      SizedBox(height: 20),
                                      _ConditionTag(),
                                      SizedBox(height: 10),
                                      _SectionTitle('Description'),
                                      SizedBox(height: 8),
                                      Text(
                                        item.description, 
                                        style: TextStyle(fontSize: 14, height: 1.5)  
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 28),
                                // Right: price + seller card
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      _Price(text: "£${item.price.toString()}"),
                                      SizedBox(height: 12),
                                      _ContactSellerButton(),
                                      SizedBox(height: 12),
                                      _SellerCard(sellerInfo: item.sellerInfo,),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 400,
                                  child: _ImageCarousel(imageUrls: item.imageUrls),
                                ),
                                const SizedBox(height: 16),
                                _Price(text: '£${item.price}'),
                                const SizedBox(height: 12),
                                const _ContactSellerButton(),
                                const SizedBox(height: 16),
                                const _ConditionTag(),
                                const SizedBox(height: 10),
                                const _SectionTitle('Description'),
                                const SizedBox(height: 8),
                                Text(item.description, 
                                style: const TextStyle(fontSize: 14, height: 1.5)  
                                ),
                                SizedBox(height: 16),
                                _SellerCard(sellerInfo: item.sellerInfo,),
                              ],
                            ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget { // build the top bar: back button, location chip, search bar, and action icons.
  const _Header();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        // Back button
         IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back',
          onPressed: () {
             Navigator.pop(context);
          },
         ),

        const SizedBox(width: 8),
        
        _LocationChip(
          icon: Icons.location_on,
          label: 'Bristol, UK',
          bg: Colors.grey.shade100,
          fg: cs.primary,
        ),
        const SizedBox(width: 16),
        // Search bar
        Expanded(
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(28),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                )
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        IconButton(onPressed: () {}, tooltip: 'Wishlist', icon: const Icon(Icons.favorite_border)),
        IconButton(onPressed: () {}, tooltip: 'Messages', icon: const Icon(Icons.chat_bubble_outline)),
        IconButton(onPressed: () {}, tooltip: 'Notifications', icon: const Icon(Icons.add_circle_outline)),
        IconButton(onPressed: () {}, tooltip: 'Account', icon: const Icon(Icons.person_outline)),
      ],
    );
  }
}

class _ImageCarousel extends StatefulWidget {
  final List<String> imageUrls;

  const _ImageCarousel({required this.imageUrls});

  @override
  State<_ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<_ImageCarousel> {
  int currentIndex = 0;

  void nextImage() {
    if (widget.imageUrls.isEmpty) return;
    setState(() {
      currentIndex = (currentIndex + 1) % widget.imageUrls.length;
    });
  }

  void previousImage() {
    if (widget.imageUrls.isEmpty) return;
    setState(() {
      currentIndex =
          (currentIndex - 1 + widget.imageUrls.length) %
              widget.imageUrls.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasImages = widget.imageUrls.isNotEmpty;

    return Stack(
      alignment: Alignment.center,
      children: [
        AspectRatio(
          aspectRatio: 4 / 3,
          child: hasImages
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.imageUrls[currentIndex],
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const _ImagePlaceholder(),
                  ),
                )
              : const _ImagePlaceholder(),
        ),

        /// LEFT ARROW
        Positioned(
          left: 8,
          child: _ArrowButton(
            icon: Icons.arrow_back_ios,
            onTap: hasImages ? previousImage : null,
          ),
        ),

        /// RIGHT ARROW
        Positioned(
          right: 8,
          child: _ArrowButton(
            icon: Icons.arrow_forward_ios,
            onTap: hasImages ? nextImage : null,
          ),
        ),
      ],
    );
  }
}

class _ArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _ArrowButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onTap == null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDisabled
              ? Colors.black.withValues(alpha: 0.2)
              : Colors.black.withValues(alpha: 0.4),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: isDisabled ? Colors.white38 : Colors.white, size: 18),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget { // placeholder for real images
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Icon(Icons.image_outlined, size: 40, color: Colors.white70),
      ),
    );
  }
}

class _ConditionTag extends StatelessWidget {
  const _ConditionTag();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.sell_outlined, size: 18, color: Colors.red.shade400),
        const SizedBox(width: 6),
        Text('CONDITION NOT IMPLEMENTED', style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}

class _Price extends StatelessWidget {
  final String text;
  const _Price({required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class _ContactSellerButton extends StatelessWidget {
  const _ContactSellerButton();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      height: 46,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: cs.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        ),
        onPressed: () {},
        child: const Text(
          'Contact Seller',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _SellerCard extends StatelessWidget {
  final Map<String, dynamic>? sellerInfo; // Accepts the seller_info from Python
  const _SellerCard({this.sellerInfo});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      color: Colors.grey.shade100,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // ------ PROFILE PICTURE ------
                CircleAvatar(
                  radius: 26,
                  backgroundColor: Color(0xFFD9D9D9),
                  backgroundImage:
                    sellerInfo?["avatar_url"] != null ? NetworkImage(sellerInfo?["avatar_url"]) : null,
                  child:  sellerInfo?["avatar_url"] == null ? Icon(Icons.person_2, size: 24, color: Colors.grey.shade500) : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text(
                        sellerInfo?["username"],
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(sellerInfo!["rating_score"].toString(), style: TextStyle(fontSize: 13, color: Colors.black87)),
                          const SizedBox(width: 6),
                          ...List.generate(5, (i) {
                            return Icon(
                              i < 4 ? Icons.star : Icons.star_border,
                              size: 16,
                              color: Colors.amber.shade600,
                            );
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text('posting for [NOT IMPLEMENTED] months',
                style: TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(foregroundColor: cs.primary),
              child: const Text('View Listings'),
            ),
          ],
        ),
      ),
    );
  }
}

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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: fg),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: Colors.grey.shade800)),
        ],
      ),
    );
  }
}