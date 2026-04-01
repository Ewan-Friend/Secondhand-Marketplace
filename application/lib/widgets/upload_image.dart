import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'image_filename_box.dart';

class UploadImage extends StatelessWidget {
  const UploadImage({
    super.key,
    required List<PlatformFile> images,
    required this.onImagesChanged,
  }) : _images = images;

  final List<PlatformFile> _images;

  // Reports that the images value has changed (added / remove chosen image)
  final ValueChanged<List<PlatformFile>> onImagesChanged;

  // Max slots is 10, can grow no larger
  static const maxSlots = 10;

  // Picks images from desktop file system
  Future<void> _pick() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
      withData: true,
    );

    if (result == null) return;

    // Combine lists using the parent-owned image list so resize/rebuilds do not
    // clear the selection.
    final combinedList = List<PlatformFile>.from(_images);
    combinedList.addAll(result.files);

    // Remove all the (older) images that dont fit within the max slots
    final startNo = (combinedList.length - maxSlots).clamp(
      0,
      combinedList.length,
    );
    final latestImages = combinedList.sublist(startNo);

    debugPrint('Selected image count: ${latestImages.length}');
    for (final image in latestImages) {
      debugPrint('Selected image: ${image.path ?? image.name}');
    }

    // Sends out the images on a call
    onImagesChanged(List.unmodifiable(latestImages));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDADCE0), width: 1.3),
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
              'Select up to 10 images for your listing',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            Text(
              '${_images.length}/$maxSlots images selected',
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
            Padding(padding: const EdgeInsets.only(top: 24.0)),
            Expanded(
              child: _images.isEmpty
                  ? const Center(
                      child: Text(
                        'No images selected yet',
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      itemCount: _images.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Align(
                          child: ImageFilenameBox(
                            filename: _images[index].name,
                          ),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 8),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
