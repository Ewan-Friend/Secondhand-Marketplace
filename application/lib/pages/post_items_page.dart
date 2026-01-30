import 'package:application/pages/profile_page.dart';
import 'package:flutter/material.dart';

class PostItemsPage extends StatefulWidget {
  const PostItemsPage({super.key});

  @override
  State<PostItemsPage> createState() => _PostItemsPage();
}

class _PostItemsPage extends State<PostItemsPage> {
  String? condition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isWide = constraints.maxWidth > 900;
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                children: [
                  Header(),
                  const SizedBox(height: 24),
                  Expanded(
                    child: SingleChildScrollView(
                      child: isWide
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: _buildForm(context)),
                                const SizedBox(width: 48),
                                const _SideButtons(),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildForm(context),
                                const SizedBox(height: 24),
                                const _SideButtons(),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upload photo',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        _UploadArea(),
        const SizedBox(height: 20),

        /// Title + AI
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _FieldLabel('Title'),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'What are you selling?',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'AI Title & Description',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: StadiumBorder(
                        side: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      backgroundColor: const Color(0xFFF8F8F8),
                    ),
                    onPressed: () {},
                    child: const Text(
                      'Generate',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        const SizedBox(height: 18),

        /// Description
        const _FieldLabel('Description'),
        const SizedBox(height: 4),
        TextFormField(
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'Describe what are you selling',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide:
                  const BorderSide(color: Color(0xFFFF6C6C), width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 18),

        /// Price + Location
        Row(
          children: [
            SizedBox(
              width: 180,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _FieldLabel('Price'),
                  const SizedBox(height: 4),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border:
                          Border.all(color: const Color(0xFFE0E0E0), width: 1),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        const Text(
                          'CHF',
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey, height: 1.4),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: '0.00',
                            ),
                            keyboardType:
                                const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _FieldLabel('Location'),
                  SizedBox(height: 4),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Start typing location',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),

        /// Condition + Category
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _FieldLabel('Condition'),
                  const SizedBox(height: 4),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      hintText: 'Pick a condition',
                    ),
                    value: condition,
                    items: const [
                      DropdownMenuItem(value: 'new', child: Text('New')),
                      DropdownMenuItem(
                          value: 'like_new', child: Text('Like New')),
                      DropdownMenuItem(value: 'good', child: Text('Good')),
                      DropdownMenuItem(value: 'used', child: Text('Used')),
                    ],
                    onChanged: (value) {
                      setState(() => condition = value);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: _CategoryField(),
            ),
          ],
        ),
      ],
    );
  }
}

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
          IconButton(
            onPressed: () {
              // Navigate to wishlist page
            },
            tooltip: 'Wishlist',
            icon: const Icon(Icons.favorite_border, size: 30),
          ),
          IconButton(
            onPressed: () {
              // Navigate to messages page
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

class _UploadArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFDADCE0),
          width: 1.3,
        ), 
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: const Icon(Icons.file_upload_outlined, size: 26),
            ),
            const SizedBox(height: 8),
            const Text(
              'Click or drag files to upload',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 13, color: Colors.black87),
    );
  }
}

class _CategoryField extends StatelessWidget {
  const _CategoryField();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _FieldLabel('Category'),
        SizedBox(height: 4),
        TextField(
          decoration: InputDecoration(
            hintText: 'Start typing',
          ),
        ),
      ],
    );
  }
}

class _SideButtons extends StatelessWidget {
  const _SideButtons();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: const StadiumBorder(),
              backgroundColor: const Color(0xFFFF6C6C),
              elevation: 6,
              shadowColor: const Color(0x55FF6C6C),
            ),
            onPressed: () {},
            child: const Text(
              'Publish',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: const StadiumBorder(),
              side: const BorderSide(color: Color(0xFFE0E0E0)),
              backgroundColor: const Color(0xFFF2F2F2),
            ),
            onPressed: () {},
            child: const Text(
              'Preview',
              style: TextStyle(color: Colors.black87, fontSize: 15),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: const StadiumBorder(),
              side: const BorderSide(color: Color(0xFFF0F0F0)),
              backgroundColor: const Color(0xFFF6F6F6),
            ),
            onPressed: () {},
            child: const Text(
              'Save Draft',
              style: TextStyle(color: Colors.black87, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
