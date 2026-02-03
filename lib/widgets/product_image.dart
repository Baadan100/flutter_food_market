import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Widget ذكي لعرض صور المنتجات
/// يدعم كل من:
/// - الصور المحلية (assets)
/// - الصور من Firebase Storage (URLs)
class ProductImage extends StatelessWidget {
  final String imagePath; // يمكن أن يكون asset path أو URL
  final BoxFit fit;
  final double? width;
  final double? height;
  final Widget? placeholder;
  final Widget? errorWidget;

  const ProductImage({
    super.key,
    required this.imagePath,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.placeholder,
    this.errorWidget,
  });

  /// التحقق إذا كان المسار هو URL (من Firebase Storage)
  bool get isNetworkImage {
    return imagePath.startsWith('http://') ||
        imagePath.startsWith('https://') ||
        imagePath.startsWith('gs://');
  }

  @override
  Widget build(BuildContext context) {
    // إذا كان URL من Firebase Storage أو HTTP
    if (isNetworkImage) {
      return CachedNetworkImage(
        imageUrl: imagePath,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => placeholder ??
            Container(
              color: Colors.grey[200],
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        errorWidget: (context, url, error) => errorWidget ??
            Container(
              color: Colors.grey[300],
              child: const Icon(
                Icons.image_not_supported,
                color: Colors.grey,
              ),
            ),
      );
    }

    // إذا كان asset path محلي
    return Image.asset(
      imagePath,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) =>
          errorWidget ??
          Container(
            color: Colors.grey[300],
            child: const Icon(
              Icons.image_not_supported,
              color: Colors.grey,
            ),
          ),
    );
  }
}
