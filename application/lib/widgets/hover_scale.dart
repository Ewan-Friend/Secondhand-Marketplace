import 'package:flutter/material.dart';

/// Reusable widget that applies a smooth scale animation on mouse hover.
///
/// Use for icons, buttons, cards, and other UI elements. Adds no visual
/// styling (color, padding, background). For visually centred scaling,
/// wrap the child in a fixed-size container if needed.
class HoverScale extends StatefulWidget {
  /// The widget to animate on hover.
  final Widget child;

  /// Scale factor when hovered. Defaults to 1.1.
  final double hoverScale;

  /// Animation duration. Defaults to 120ms.
  final Duration duration;

  /// Animation curve. Defaults to [Curves.easeOut].
  final Curve curve;

  const HoverScale({
    super.key,
    required this.child,
    this.hoverScale = 1.1,
    this.duration = const Duration(milliseconds: 120),
    this.curve = Curves.easeOut,
  });

  @override
  State<HoverScale> createState() => _HoverScaleState();
}

class _HoverScaleState extends State<HoverScale> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? widget.hoverScale : 1.0,
        duration: widget.duration,
        curve: widget.curve,
        child: widget.child,
      ),
    );
  }
}
