import 'dart:ui';
import 'package:flutter/material.dart';

class Glass extends StatelessWidget {
  const Glass(
      {super.key,
      this.child,
      this.radius = 16,
      this.padding = const EdgeInsets.all(12),
      this.opacity = .15});
  final Widget? child;
  final double radius;
  final EdgeInsets padding;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            color: Theme.of(context).colorScheme.surface.withOpacity(opacity),
            border: Border.all(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(.08),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
