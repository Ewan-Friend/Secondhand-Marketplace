import 'package:application/widgets/header.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/upload_image.dart';
import '../models/item_model.dart';

const int xpPerPost = 50;
const String _testUserId = '55d89a2e-d30c-4b20-a51d-6a979ba6b7da';

class PostItemsPage extends StatefulWidget {
  const PostItemsPage({super.key});

  @override
  State<PostItemsPage> createState() => _PostItemsPage();
}

class _PostItemsPage extends State<PostItemsPage> {
  String? condition;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final locationController = TextEditingController();
  List<PlatformFile> selectedImages = [];

  Item createItem() {
    return Item(
      id: '',
      sellerId: _testUserId,
      title: titleController.text,
      description: descriptionController.text,
      rating: 0,
      price: double.tryParse(priceController.text) ?? 0.0,
      location: locationController.text,
      condition: condition ?? 'good',
      imageUrls: [],
      sellerInfo: {
        'seller_id': _testUserId,
        'seller_name': 'Upload Test User',
        'location': 'Bristol, UK'
      },
    );
  }

  Future<void> onPublish() async {
    final item = createItem();
    final apiService = APIService();
    try {
      await apiService.postItemWithSelectedImages(
        itemData: item.toJson(),
        selectedImages: selectedImages,
      );

      final profile = await apiService.getUserById(_testUserId);
      final data = profile['table_data'] ?? profile['data'] ?? profile;
      final currentXp = (data['xp'] as num?)?.toInt() ?? 0;
      final currentLevel = (data['level'] as num?)?.toInt() ?? 1;
      final newXp = currentXp + xpPerPost;

      await apiService.addXP(newXp, currentLevel);

      titleController.clear();
      descriptionController.clear();
      priceController.clear();
      locationController.clear();
      setState(() => condition = null);
      setState(() => selectedImages = []);

      if (mounted) {
        _showXpPopup(xpPerPost);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _showXpPopup(int xpEarned) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFFF6C6C).withOpacity(0.6)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF6C6C).withOpacity(0.15),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6C6C).withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Text('⭐', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Item posted!',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'You earned +$xpEarned XP',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6C6C).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '+$xpEarned XP',
                  style: const TextStyle(
                    color: Color(0xFFFF6C6C),
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Header(showSearch: false, showBackButton: true),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isWide = constraints.maxWidth > 900;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Expanded(
                    child: isWide
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  child: _buildForm(context),
                                ),
                              ),
                              const SizedBox(width: 48),
                              _SideButtons(
                                titleController,
                                descriptionController,
                                priceController,
                                locationController,
                                condition,
                                onPublish,
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildForm(context),
                              const SizedBox(height: 24),
                              _SideButtons(
                                titleController,
                                descriptionController,
                                priceController,
                                locationController,
                                condition,
                                onPublish,
                              ),
                            ],
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
          style: TextStyle(fontSize: 14, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        UploadImage(
          onImagesChanged: (images) {
            setState(() {
              selectedImages = images;
            });
          },
        ),
        const SizedBox(height: 20),
        _TitleField(titleController),
        const SizedBox(height: 18),
        _DescriptionField(descriptionController),
        const SizedBox(height: 18),
        Row(
          children: [
            SizedBox(
              width: 180,
              child: _PriceField(priceController),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _LocationField(locationController),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: _ConditionField(
                value: condition,
                onChanged: (value) {
                  setState(() => condition = value);
                },
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

class _TitleField extends StatelessWidget {
  final TextEditingController titleController;
  const _TitleField(this.titleController);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FieldLabel('Title'),
        TextFormField(
          decoration: const InputDecoration(hintText: 'What are you selling?'),
          controller: titleController,
        ),
      ],
    );
  }
}

class _DescriptionField extends StatelessWidget {
  final TextEditingController controller;
  const _DescriptionField(this.controller);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FieldLabel('Description'),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'Describe what are you selling',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFFF6C6C), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

class _PriceField extends StatelessWidget {
  final TextEditingController controller;
  const _PriceField(this.controller);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FieldLabel('Price'),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              const Text(
                '£',
                style: TextStyle(fontSize: 13, color: Colors.grey, height: 1.4),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '0.00',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LocationField extends StatelessWidget {
  final TextEditingController controller;

  const _LocationField(this.controller);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FieldLabel('Location'),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Start typing location'),
        ),
      ],
    );
  }
}

class _ConditionField extends StatelessWidget {
  final String? value;
  final void Function(String?) onChanged;
  const _ConditionField({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FieldLabel('Condition'),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(hintText: 'Pick a condition'),
          initialValue: value,
          items: const [
            DropdownMenuItem(value: 'New', child: Text('New')),
            DropdownMenuItem(value: 'Like New', child: Text('Like New')),
            DropdownMenuItem(value: 'Good', child: Text('Good')),
            DropdownMenuItem(value: 'Used', child: Text('Used')),
          ],
          onChanged: onChanged,
        ),
      ],
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
        TextField(decoration: InputDecoration(hintText: 'Start typing')),
      ],
    );
  }
}

class _SideButtons extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController priceController;
  final TextEditingController locationController;
  final String? condition;
  final VoidCallback onPublish;

  const _SideButtons(
    this.titleController,
    this.descriptionController,
    this.priceController,
    this.locationController,
    this.condition,
    this.onPublish,
  );

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
            onPressed: onPublish,
            child: const Text('Publish', style: TextStyle(color: Colors.white, fontSize: 15)),
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
            child: const Text('Preview', style: TextStyle(color: Colors.black87, fontSize: 15)),
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
            child: const Text('Save Draft', style: TextStyle(color: Colors.black87, fontSize: 15)),
          ),
        ],
      ),
    );
  }
}