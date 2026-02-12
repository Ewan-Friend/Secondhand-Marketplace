import 'package:flutter/widget_previews.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class UploadImage extends StatelessWidget{ 

const UploadImage({
  super.key,
});

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
                border: Border.all(color: const Color(0xFFDADCE0)),
              ),
              child: const Icon(Icons.file_upload_outlined, size: 26),
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

  @Preview(name: "upload image")
  static Widget preview() {
    return UploadImage();
  }
}