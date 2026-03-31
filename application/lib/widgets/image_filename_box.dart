import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ImageFilenameBox extends StatelessWidget {
  final String filename;

  const ImageFilenameBox({
    super.key, 
    required this.filename
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 120,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 216, 216, 216),
          border: Border.all(
            color: Colors.black, 
            width: 2.0),
          borderRadius: BorderRadius.circular(6.0)
        ),
        child: Center(
            child: Text(
              filename,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.firaCode(
                color: Colors.black,
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.4,
              ),
            )
        )
      ),
    );   
  }
}