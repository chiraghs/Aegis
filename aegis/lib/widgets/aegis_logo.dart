import 'package:flutter/material.dart';

/// Official Aegis Logo Component
/// Displays the signature matte black rounded tile with the vibrant emerald geometric shield glyph
class AegisLogo extends StatelessWidget {
  final double size;
  final double borderRadius;
  final bool showContainer;

  const AegisLogo({
    super.key,
    this.size = 28.0,
    this.borderRadius = 8.0,
    this.showContainer = true,
  });

  @override
  Widget build(BuildContext context) {
    final imageWidget = Image.asset(
      'assets/images/aegis_logo.jpg',
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _buildVectorLogo(),
    );

    if (!showContainer) {
      return _buildVectorLogo();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: size,
        height: size,
        color: const Color(0xFF16181D),
        child: imageWidget,
      ),
    );
  }

  Widget _buildVectorLogo() {
    return CustomPaint(
      size: Size(size, size),
      painter: _AegisLogoPainter(),
    );
  }
}

class _AegisLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF7DE43A) // Aegis Mint Green
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final w = size.width;
    final h = size.height;

    // Left steep chevron / triangle-parallelogram
    final leftPath = Path()
      ..moveTo(w * 0.50, h * 0.22) // Apex top
      ..lineTo(w * 0.61, h * 0.38)
      ..lineTo(w * 0.37, h * 0.76)
      ..lineTo(w * 0.26, h * 0.60)
      ..close();

    // Right diamond polygon
    final rightPath = Path()
      ..moveTo(w * 0.63, h * 0.42)
      ..lineTo(w * 0.74, h * 0.58)
      ..lineTo(w * 0.63, h * 0.76)
      ..lineTo(w * 0.52, h * 0.60)
      ..close();

    canvas.drawPath(leftPath, paint);
    canvas.drawPath(rightPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
