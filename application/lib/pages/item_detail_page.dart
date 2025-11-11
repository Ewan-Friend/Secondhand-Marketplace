import 'package:flutter/material.dart';

void main() {
  runApp(const ItemDetailPage());
}

class ItemDetailPage extends StatelessWidget {
  const ItemDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Detail',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE76F72)),
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      home: const ProductDetailPage(),
    );
  }
}

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 980;
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _Header(),
                  const SizedBox(height: 24),
                  // Title row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          'Product Title',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
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
                        const Text('Redland, Bristol, UK',
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
                                children: const [
                                  _ImageCollage(),
                                  SizedBox(height: 20),
                                  _ConditionTag(),
                                  SizedBox(height: 10),
                                  _SectionTitle('Description'),
                                  SizedBox(height: 8),
                                  _LoremIpsum(),
                                ],
                              ),
                            ),
                            const SizedBox(width: 28),
                            // Right: price + seller card
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: const [
                                  _Price(text: 'CHF 120'),
                                  SizedBox(height: 12),
                                  _ContactSellerButton(),
                                  SizedBox(height: 12),
                                  _SellerCard(),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            _ImageCollage(),
                            SizedBox(height: 16),
                            _Price(text: 'CHF 120'),
                            SizedBox(height: 12),
                            _ContactSellerButton(),
                            SizedBox(height: 16),
                            _ConditionTag(),
                            SizedBox(height: 10),
                            _SectionTitle('Description'),
                            SizedBox(height: 8),
                            _LoremIpsum(),
                            SizedBox(height: 16),
                            _SellerCard(),
                          ],
                        ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
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
        IconButton(onPressed: () {
          print('Account icon tapped');
          Navigator.pushNamed(context, '/profile');
        }, tooltip: 'Account', icon: const Icon(Icons.person_outline)),
      ],
    );
  }
}

class _ImageCollage extends StatelessWidget {
  const _ImageCollage();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 7,
          child: AspectRatio(
            aspectRatio: 4 / 3,
            child: const _ImagePlaceholder(),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 5,
          child: Column(
            children: const [
              AspectRatio(aspectRatio: 4 / 3, child: _ImagePlaceholder()),
              SizedBox(height: 16),
              AspectRatio(aspectRatio: 4 / 3, child: _ImagePlaceholder()),
            ],
          ),
        ),
      ],
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
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
        Text('Condition', style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
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
  const _SellerCard();

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
                const CircleAvatar(
                  radius: 26,
                  backgroundColor: Color(0xFFD9D9D9),
                  child: Icon(Icons.person, color: Colors.white70, size: 30),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Seller Name',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Text('4.12', style: TextStyle(fontSize: 13, color: Colors.black87)),
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
            const Text('posting for 7 months',
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

class _LoremIpsum extends StatelessWidget {
  const _LoremIpsum();

  @override
  Widget build(BuildContext context) {
    const text =
        'Lorem Ipsum is simply dummy text of the printing and typesetting industry.';
    return Text(
      text,
      style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
    );
  }
}