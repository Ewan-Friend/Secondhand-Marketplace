import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class UploadImage extends StatefulWidget{
  const UploadImage({super.key});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> { 
  final List<File> _images = [];

  // Picks images from desktop file system
  Future<void> _pick() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (result == null) return;

    setState(() {
      final availableSlots = 3 - _images.length;
      if (availableSlots > 0) {
        final newFiles = result.paths
            .where((path) => path != null)
            .take(availableSlots)
            .map((path) => File(path!))
            .toList();
        _images.addAll(newFiles);
      }
    });
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