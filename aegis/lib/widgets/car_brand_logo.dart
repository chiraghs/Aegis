import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Authentic vector-drawn Car Brand Emblems for Aegis Garage
class CarBrandLogo extends StatelessWidget {
  final String make;
  final double size;

  const CarBrandLogo({
    super.key,
    required this.make,
    this.size = 36.0,
  });

  @override
  Widget build(BuildContext context) {
    final lower = make.toLowerCase();

    if (lower.contains('tesla')) {
      return _buildTeslaLogo();
    } else if (lower.contains('honda')) {
      return _buildHondaLogo();
    } else if (lower.contains('porsche')) {
      return _buildPorscheLogo();
    } else if (lower.contains('ford')) {
      return _buildFordLogo();
    } else if (lower.contains('bmw')) {
      return _buildBmwLogo();
    } else if (lower.contains('rivian')) {
      return _buildRivianLogo();
    }

    // Default stylized automotive badge
    return _buildGenericEmblem(make);
  }

  /// 1. Tesla "T" Emblem: Authentic curved top crossbar + tapered stem
  Widget _buildTeslaLogo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomPaint(
          size: Size(size, size * 0.85),
          painter: _TeslaLogoPainter(),
        ),
        const SizedBox(height: 3),
        const Text(
          'T E S L A',
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w900,
            letterSpacing: 3.5,
            color: Color(0xFFE82127),
          ),
        ),
      ],
    );
  }

  /// 2. Honda Trapezoid "H" Emblem: Authentic chrome/metallic automotive badge
  Widget _buildHondaLogo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomPaint(
          size: Size(size * 1.05, size * 0.9),
          painter: _HondaLogoPainter(),
        ),
        const SizedBox(height: 3),
        const Text(
          'H O N D A',
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.5,
            color: Color(0xFFC00000),
          ),
        ),
      ],
    );
  }

  /// 3. Porsche Stuttgart Crest: Authentic shield with antlers, red/black stripes & horse
  Widget _buildPorscheLogo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomPaint(
          size: Size(size * 0.8, size * 1.0),
          painter: _PorscheCrestPainter(),
        ),
        const SizedBox(height: 3),
        const Text(
          'P O R S C H E',
          style: TextStyle(
            fontSize: 8.5,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.8,
            color: Color(0xFFD4AF37),
          ),
        ),
      ],
    );
  }

  /// 4. Ford Blue Oval: Cobalt oval with chrome border & Spencerian Ford script
  Widget _buildFordLogo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size * 1.5,
          height: size * 0.85,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size),
            gradient: const LinearGradient(
              colors: [Color(0xFF002C6C), Color(0xFF00499C), Color(0xFF001B44)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            border: Border.all(color: const Color(0xFFD0D7DE), width: 1.8),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF002C6C).withValues(alpha: 0.4),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              'Ford',
              style: TextStyle(
                fontFamily: 'serif',
                fontStyle: FontStyle.italic,
                fontSize: size * 0.42,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        const SizedBox(height: 3),
        const Text(
          'F O R D',
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.5,
            color: Color(0xFF00499C),
          ),
        ),
      ],
    );
  }

  /// 5. BMW Roundel: Black outer ring with silver dividers and 4 quadrant blue/white roundel
  Widget _buildBmwLogo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomPaint(
          size: Size(size, size),
          painter: _BmwRoundelPainter(),
        ),
        const SizedBox(height: 3),
        const Text(
          'B M W',
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w900,
            letterSpacing: 3.0,
            color: Color(0xFF0066B1),
          ),
        ),
      ],
    );
  }

  /// 6. Rivian Compass: Diamond with concentric yellow chevrons
  Widget _buildRivianLogo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomPaint(
          size: Size(size * 0.9, size * 0.9),
          painter: _RivianLogoPainter(),
        ),
        const SizedBox(height: 3),
        const Text(
          'R I V I A N',
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.8,
            color: Color(0xFFE5A93C),
          ),
        ),
      ],
    );
  }

  Widget _buildGenericEmblem(String brand) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.directions_car, size: size * 0.8, color: Colors.white70),
        const SizedBox(height: 2),
        Text(
          brand.toUpperCase(),
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}

/// Tesla T Vector Painter
class _TeslaLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE82127)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final w = size.width;
    final h = size.height;

    // Upper curved arc (eyebrow of Tesla T)
    final arcPath = Path();
    arcPath.moveTo(w * 0.05, h * 0.18);
    arcPath.quadraticBezierTo(w * 0.50, h * -0.05, w * 0.95, h * 0.18);
    arcPath.quadraticBezierTo(w * 0.82, h * 0.28, w * 0.70, h * 0.24);
    arcPath.quadraticBezierTo(w * 0.50, h * 0.12, w * 0.30, h * 0.24);
    arcPath.quadraticBezierTo(w * 0.18, h * 0.28, w * 0.05, h * 0.18);
    arcPath.close();
    canvas.drawPath(arcPath, paint);

    // Center T body and down stem
    final stemPath = Path();
    stemPath.moveTo(w * 0.12, h * 0.34);
    stemPath.quadraticBezierTo(w * 0.50, h * 0.20, w * 0.88, h * 0.34);
    stemPath.lineTo(w * 0.76, h * 0.44);
    stemPath.quadraticBezierTo(w * 0.60, h * 0.38, w * 0.56, h * 0.46);
    stemPath.lineTo(w * 0.53, h * 0.96);
    stemPath.lineTo(w * 0.47, h * 0.96);
    stemPath.lineTo(w * 0.44, h * 0.46);
    stemPath.quadraticBezierTo(w * 0.40, h * 0.38, w * 0.24, h * 0.44);
    stemPath.close();
    canvas.drawPath(stemPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Honda Trapezoid 'H' Vector Painter
class _HondaLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Chrome outer rounded trapezoid frame
    final framePaint = Paint()
      ..color = const Color(0xFFC00000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..isAntiAlias = true;

    final framePath = Path();
    framePath.moveTo(w * 0.15, h * 0.08);
    framePath.lineTo(w * 0.85, h * 0.08);
    framePath.quadraticBezierTo(w * 0.95, h * 0.08, w * 0.90, h * 0.30);
    framePath.lineTo(w * 0.80, h * 0.88);
    framePath.quadraticBezierTo(w * 0.77, h * 0.96, w * 0.65, h * 0.96);
    framePath.lineTo(w * 0.35, h * 0.96);
    framePath.quadraticBezierTo(w * 0.23, h * 0.96, w * 0.20, h * 0.88);
    framePath.lineTo(w * 0.10, h * 0.30);
    framePath.quadraticBezierTo(w * 0.05, h * 0.08, w * 0.15, h * 0.08);
    framePath.close();
    canvas.drawPath(framePath, framePaint);

    // Honda 'H' glyph
    final hPaint = Paint()
      ..color = const Color(0xFFC00000)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // Left vertical flare
    final leftH = Path();
    leftH.moveTo(w * 0.22, h * 0.16);
    leftH.lineTo(w * 0.33, h * 0.16);
    leftH.lineTo(w * 0.36, h * 0.86);
    leftH.lineTo(w * 0.28, h * 0.86);
    leftH.close();
    canvas.drawPath(leftH, hPaint);

    // Right vertical flare
    final rightH = Path();
    rightH.moveTo(w * 0.78, h * 0.16);
    rightH.lineTo(w * 0.67, h * 0.16);
    rightH.lineTo(w * 0.64, h * 0.86);
    rightH.lineTo(w * 0.72, h * 0.86);
    rightH.close();
    canvas.drawPath(rightH, hPaint);

    // Crossbar
    final barRect = RRect.fromRectAndRadius(
      Rect.fromLTRB(w * 0.32, h * 0.48, w * 0.68, h * 0.58),
      const Radius.circular(1.5),
    );
    canvas.drawRRect(barRect, hPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Porsche Stuttgart Crest Painter
class _PorscheCrestPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Gold Shield Base
    final shieldPath = Path();
    shieldPath.moveTo(w * 0.10, h * 0.06);
    shieldPath.lineTo(w * 0.90, h * 0.06);
    shieldPath.lineTo(w * 0.88, h * 0.60);
    shieldPath.quadraticBezierTo(w * 0.84, h * 0.88, w * 0.50, h * 0.98);
    shieldPath.quadraticBezierTo(w * 0.16, h * 0.88, w * 0.12, h * 0.60);
    shieldPath.close();

    final goldPaint = Paint()
      ..color = const Color(0xFFD4AF37)
      ..style = PaintingStyle.fill;
    canvas.drawPath(shieldPath, goldPaint);

    final borderPaint = Paint()
      ..color = const Color(0xFF1E1E1E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;
    canvas.drawPath(shieldPath, borderPaint);

    // Cross dividing lines (4 quarters)
    final linePaint = Paint()
      ..color = const Color(0xFF1E1E1E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawLine(Offset(w * 0.12, h * 0.52), Offset(w * 0.88, h * 0.52), linePaint);
    canvas.drawLine(Offset(w * 0.50, h * 0.18), Offset(w * 0.50, h * 0.98), linePaint);

    // Red and Black stripes in quarters
    final redPaint = Paint()
      ..color = const Color(0xFFB30000)
      ..style = PaintingStyle.fill;
    final blackPaint = Paint()
      ..color = const Color(0xFF1A1A1A)
      ..style = PaintingStyle.fill;

    // Top Right Stripes
    canvas.drawRect(Rect.fromLTRB(w * 0.54, h * 0.22, w * 0.84, h * 0.30), redPaint);
    canvas.drawRect(Rect.fromLTRB(w * 0.54, h * 0.34, w * 0.84, h * 0.42), blackPaint);

    // Bottom Left Stripes
    canvas.drawRect(Rect.fromLTRB(w * 0.16, h * 0.60, w * 0.46, h * 0.68), redPaint);
    canvas.drawRect(Rect.fromLTRB(w * 0.16, h * 0.72, w * 0.46, h * 0.80), blackPaint);

    // Center Stuttgart Mini Shield
    final miniShield = Path();
    miniShield.moveTo(w * 0.38, h * 0.38);
    miniShield.lineTo(w * 0.62, h * 0.38);
    miniShield.lineTo(w * 0.60, h * 0.64);
    miniShield.quadraticBezierTo(w * 0.58, h * 0.74, w * 0.50, h * 0.78);
    miniShield.quadraticBezierTo(w * 0.42, h * 0.74, w * 0.40, h * 0.64);
    miniShield.close();

    final miniShieldPaint = Paint()
      ..color = const Color(0xFFE5C158)
      ..style = PaintingStyle.fill;
    canvas.drawPath(miniShield, miniShieldPaint);
    canvas.drawPath(miniShield, linePaint);

    // Center Prancing Horse silhouette
    final horsePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w * 0.50, h * 0.48), 2.2, horsePaint);
    canvas.drawRect(Rect.fromLTRB(w * 0.48, h * 0.50, w * 0.52, h * 0.64), horsePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// BMW Roundel Vector Painter
class _BmwRoundelPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 1. Chrome outer border
    final chromePaint = Paint()
      ..color = const Color(0xFFD6DBE1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(center, radius - 1, chromePaint);

    // 2. Black outer ring
    final blackRingPaint = Paint()
      ..color = const Color(0xFF1A1A1A)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius - 2, blackRingPaint);

    // 3. Inner circle with 4 Bavarian quadrants (Blue & White)
    final innerRadius = radius * 0.64;
    final innerCenter = center;

    final bluePaint = Paint()
      ..color = const Color(0xFF0066B1)
      ..style = PaintingStyle.fill;
    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final rect = Rect.fromCircle(center: innerCenter, radius: innerRadius);

    // Quadrant 1 (Top-Left: Blue)
    canvas.drawArc(rect, math.pi, math.pi / 2, true, bluePaint);
    // Quadrant 2 (Top-Right: White)
    canvas.drawArc(rect, 3 * math.pi / 2, math.pi / 2, true, whitePaint);
    // Quadrant 3 (Bottom-Right: Blue)
    canvas.drawArc(rect, 0, math.pi / 2, true, bluePaint);
    // Quadrant 4 (Bottom-Left: White)
    canvas.drawArc(rect, math.pi / 2, math.pi / 2, true, whitePaint);

    // Inner chrome border & cross divider lines
    final dividerPaint = Paint()
      ..color = const Color(0xFFD6DBE1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawCircle(innerCenter, innerRadius, dividerPaint);
    canvas.drawLine(Offset(innerCenter.dx - innerRadius, innerCenter.dy), Offset(innerCenter.dx + innerRadius, innerCenter.dy), dividerPaint);
    canvas.drawLine(Offset(innerCenter.dx, innerCenter.dy - innerRadius), Offset(innerCenter.dx, innerCenter.dy + innerRadius), dividerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Rivian Compass Vector Painter
class _RivianLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final w = size.width;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(math.pi / 4); // 45 degree diamond rotation

    // Outer Yellow Diamond Frame
    final diamondPaint = Paint()
      ..color = const Color(0xFFE5A93C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeJoin = StrokeJoin.round;

    final half = w * 0.34;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset.zero, width: half * 2, height: half * 2),
      const Radius.circular(5),
    );
    canvas.drawRRect(rrect, diamondPaint);

    // Inner chevrons
    final innerPaint = Paint()
      ..color = const Color(0xFFE5A93C)
      ..style = PaintingStyle.fill;

    // Small interior center diamonds
    canvas.drawCircle(Offset.zero, 2.5, innerPaint);
    canvas.drawCircle(Offset(-half * 0.45, 0), 2.0, innerPaint);
    canvas.drawCircle(Offset(half * 0.45, 0), 2.0, innerPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
