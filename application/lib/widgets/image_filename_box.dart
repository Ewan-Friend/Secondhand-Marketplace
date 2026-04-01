import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ImageFilenameBox extends StatelessWidget {
  final String filename;

  const ImageFilenameBox({super.key, required this.filename});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final boxWidth = (screenWidth * 0.23).clamp(84.0, 100.0);
    final boxHeight = (screenWidth * 0.032).clamp(30.0, 42.0);

    return Container(
      height: boxHeight,
      width: boxWidth,
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 221, 224, 223),
        border: Border.all(color: Colors.black, width: 1.3),
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Center(
        child: Text(
          filename,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.firaCode(
            color: Colors.black,
            fontSize: (boxHeight * 0.20).clamp(8.0, 11.0),
            fontWeight: FontWeight.w500,
            letterSpacing: 0.15,
          ),
        ),
      ),
    );
  }
}
