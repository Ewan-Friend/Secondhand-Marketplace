import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class UploadImage extends StatefulWidget{
  const UploadImage({
    super.key,
    required this.onImagesChanged,
    });

  // Reports that the images value has changed (added / remove choses image)
  final ValueChanged<List<PlatformFile>> onImagesChanged;

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> { 
  final List<PlatformFile> _images = [];

  // Picks images from desktop file system
  Future<void> _pick() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
      withData: true,
    );

    if (result == null) return;

    setState(() {
      // Max slots is 3, can grow no larger
      const maxSlots = 3;
      
      // Combine lists
      final combinedList = List.from(_images);
      combinedList.addAll(result.files);

      // Remove all the (older) images that dont fit within the max slots
      final startNo = (combinedList.length - maxSlots).clamp(0, combinedList.length);
      final latestImages = _images.sublist(startNo);

      // Clear and add to _images
      _images.clear();
      _images.addAll(latestImages); 
    });

    debugPrint('Selected image count: ${_images.length}');
    for (final image in _images) {
      debugPrint('Selected image: ${image.path ?? image.name}');
    }

    // Sends out the images on a call
    widget.onImagesChanged(List.unmodifiable(_images));
  }



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
            InkWell(
              onTap: _pick,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFDADCE0)),
                ),
                child: const Icon(Icons.file_upload_outlined, size: 26),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Select up to 3 images for your listing',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}