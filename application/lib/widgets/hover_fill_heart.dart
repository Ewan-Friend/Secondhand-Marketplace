import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Reusable heart icon that transitions from outline to filled on hover.
///
/// Purely visual: no persistent favourite state. Uses theme primary (brand) color
/// for the filled heart. Wrap in [Tooltip] or pass [tooltip] for accessibility.
class HoverFillHeart extends StatefulWidget {
  const HoverFillHeart({
    super.key,
    this.onPressed,
    this.tooltip,
    this.iconSize = 30,
    this.duration,
    this.curve,
  });

  /// Called when the heart is tapped. Optional; when null, no tap handler is added.
  final VoidCallback? onPressed;

  /// Optional tooltip message. When set, wraps the widget in [Tooltip].
  final String? tooltip;

  /// Size of the heart icon. Defaults to 30 to match typical header icon size.
  final double iconSize;

  /// Animation duration for the fill transition. Defaults to 180ms.
  final Duration? duration;

  /// Animation curve. Defaults to [Curves.easeOut].
  final Curve? curve;

  @override
  State<HoverFillHeart> createState() => _HoverFillHeartState();
}

class _HoverFillHeartState extends State<HoverFillHeart> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filledColor = theme.colorScheme.primary;
    final outlineColor = theme.iconTheme.color ?? theme.colorScheme.onSurface;
    final duration = widget.duration ?? const Duration(milliseconds: 180);
    final curve = widget.curve ?? Curves.easeOut;

    

    if (widget.tooltip != null && widget.tooltip!.isNotEmpty) {
      content = Tooltip(
        message: widget.tooltip!,
        child: content,
      );
    }

    if (widget.onPressed != null) {
      content = GestureDetector(
        onTap: widget.onPressed,
        behavior: HitTestBehavior.opaque,
        child: content,
      );
    }

    return content;
  }
}
