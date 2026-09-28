import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/theme.dart';
import '../models/asset_model.dart';

class NetWorthChartWidget extends StatefulWidget {
  final List<NetWorthSnapshot> history;

  const NetWorthChartWidget({super.key, required this.history});

  @override
  State<NetWorthChartWidget> createState() => _NetWorthChartWidgetState();
}

class _NetWorthChartWidgetState extends State<NetWorthChartWidget> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    if (widget.history.isEmpty) return const SizedBox.shrink();

    final currency = NumberFormat.compactSimpleCurrency();
    final selected = _selectedIndex != null ? widget.history[_selectedIndex!] : widget.history.last;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${selected.monthLabel.toUpperCase()} TRAJECTORY',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    currency.format(selected.netWorth),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.emeraldAccent,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.emeraldAccent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.emeraldAccent.withValues(alpha: 0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.trending_up, size: 14, color: AppTheme.emeraldAccent),
                    SizedBox(width: 4),
                    Text(
                      '6-MO TREND',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppTheme.emeraldAccent),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Chart Canvas
          GestureDetector(
            onPanUpdate: (details) => _updateSelection(details.localPosition.dx),
            onTapDown: (details) => _updateSelection(details.localPosition.dx),
            child: SizedBox(
              height: 140,
              width: double.infinity,
              child: CustomPaint(
                painter: _NetWorthChartPainter(
                  history: widget.history,
                  selectedIndex: _selectedIndex ?? (widget.history.length - 1),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // X-Axis Month Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: widget.history.asMap().entries.map((entry) {
              final idx = entry.key;
              final item = entry.value;
              final isCurrent = idx == (_selectedIndex ?? (widget.history.length - 1));
              return GestureDetector(
                onTap: () => setState(() => _selectedIndex = idx),
                child: Text(
                  item.monthLabel,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isCurrent ? FontWeight.w900 : FontWeight.w500,
                    color: isCurrent ? AppTheme.emeraldAccent : AppTheme.textMuted,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _updateSelection(double localX) {
    if (widget.history.isEmpty) return;
    const padding = 16.0;
    final chartWidth = MediaQuery.of(context).size.width - 64; // Approx padding
    final step = chartWidth / (widget.history.length - 1);
    int index = ((localX - padding) / step).round();
    if (index < 0) index = 0;
    if (index >= widget.history.length) index = widget.history.length - 1;
    setState(() {
      _selectedIndex = index;
    });
  }
}

class _NetWorthChartPainter extends CustomPainter {
  final List<NetWorthSnapshot> history;
  final int selectedIndex;

  _NetWorthChartPainter({required this.history, required this.selectedIndex});

  @override
  void paint(Canvas canvas, Size size) {
    if (history.length < 2) return;

    final values = history.map((h) => h.netWorth).toList();
    final minVal = values.reduce((a, b) => a < b ? a : b) * 0.96;
    final maxVal = values.reduce((a, b) => a > b ? a : b) * 1.04;
    final range = maxVal - minVal;

    final stepX = size.width / (history.length - 1);

    final points = <Offset>[];
    for (int i = 0; i < history.length; i++) {
      final x = i * stepX;
      final normalizedY = (history[i].netWorth - minVal) / range;
      final y = size.height - (normalizedY * (size.height - 20)) - 10;
      points.add(Offset(x, y));
    }

    // Gradient fill path below line
    final fillPath = Path();
    fillPath.moveTo(points.first.dx, size.height);
    fillPath.lineTo(points.first.dx, points.first.dy);
    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final controlX = (p0.dx + p1.dx) / 2;
      fillPath.cubicTo(controlX, p0.dy, controlX, p1.dy, p1.dx, p1.dy);
    }
    fillPath.lineTo(points.last.dx, size.height);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          AppTheme.emeraldAccent.withValues(alpha: 0.25),
          AppTheme.emeraldAccent.withValues(alpha: 0.0),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(fillPath, fillPaint);

    // Line stroke path
    final linePath = Path();
    linePath.moveTo(points.first.dx, points.first.dy);
    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final controlX = (p0.dx + p1.dx) / 2;
      linePath.cubicTo(controlX, p0.dy, controlX, p1.dy, p1.dx, p1.dy);
    }

    final linePaint = Paint()
      ..color = AppTheme.emeraldAccent
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(linePath, linePaint);

    // Draw circular dots
    for (int i = 0; i < points.length; i++) {
      final isSelected = i == selectedIndex;
      final p = points[i];

      if (isSelected) {
        // Glowing halo for selected point
        final haloPaint = Paint()
          ..color = AppTheme.emeraldAccent.withValues(alpha: 0.3)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(p, 9, haloPaint);

        final dotPaint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;
        canvas.drawCircle(p, 5, dotPaint);

        final ringPaint = Paint()
          ..color = AppTheme.emeraldAccent
          ..strokeWidth = 2.5
          ..style = PaintingStyle.stroke;
        canvas.drawCircle(p, 5, ringPaint);
      } else {
        final dotPaint = Paint()
          ..color = AppTheme.surfaceCardElevated
          ..style = PaintingStyle.fill;
        canvas.drawCircle(p, 3.5, dotPaint);

        final borderPaint = Paint()
          ..color = AppTheme.emeraldAccent.withValues(alpha: 0.7)
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke;
        canvas.drawCircle(p, 3.5, borderPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _NetWorthChartPainter oldDelegate) {
    return oldDelegate.selectedIndex != selectedIndex || oldDelegate.history != history;
  }
}
