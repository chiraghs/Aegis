import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/credit_card_model.dart';

class CreditCardWidget extends StatefulWidget {
  final CreditCardModel card;
  final VoidCallback? onSimulatePayment;
  final VoidCallback? onPayNow;
  final VoidCallback? onMarkAsPaid;
  final VoidCallback? onSmartStatement;
  final VoidCallback? onPaymentHistory;
  final VoidCallback? onCardPerks;
  final VoidCallback? onRecentSpends;
  final VoidCallback? onMoreActions;
  final VoidCallback? onViewDetails;
  final bool isStacked;
  final double peekHeight;

  const CreditCardWidget({
    super.key,
    required this.card,
    this.onSimulatePayment,
    this.onPayNow,
    this.onMarkAsPaid,
    this.onSmartStatement,
    this.onPaymentHistory,
    this.onCardPerks,
    this.onRecentSpends,
    this.onMoreActions,
    this.onViewDetails,
    this.isStacked = false,
    this.peekHeight = 65.0,
  });

  @override
  State<CreditCardWidget> createState() => _CreditCardWidgetState();
}

class _CreditCardWidgetState extends State<CreditCardWidget> with SingleTickerProviderStateMixin {
  late AnimationController _swipeController;
  late Animation<double> _swipeAnimation;
  bool _isSwipedOpen = false;

  @override
  void initState() {
    super.initState();
    _swipeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _swipeAnimation = CurvedAnimation(
      parent: _swipeController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _swipeController.dispose();
    super.dispose();
  }

  void _toggleSwipe([bool? open]) {
    final target = open ?? !_isSwipedOpen;
    if (target) {
      _swipeController.forward();
    } else {
      _swipeController.reverse();
    }
    setState(() {
      _isSwipedOpen = target;
    });
  }

  LinearGradient _getCardGradient() {
    switch (widget.card.themePreset) {
      case CardThemePreset.amexGold:
        return const LinearGradient(
          colors: [Color(0xFFC6923C), Color(0xFFDFBA68), Color(0xFF9E7124)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case CardThemePreset.chaseSapphire:
        return const LinearGradient(
          colors: [Color(0xFF0F326E), Color(0xFF1B4E9B), Color(0xFF091F47)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case CardThemePreset.ventureX:
        return const LinearGradient(
          colors: [Color(0xFF1B2E4B), Color(0xFF2A4365), Color(0xFF101B2E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case CardThemePreset.appleTitanium:
        return const LinearGradient(
          colors: [Color(0xFF2B2D30), Color(0xFF1E1F22), Color(0xFF141517)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  Widget _buildEmvChip() {
    return Container(
      width: 44,
      height: 34,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        gradient: const LinearGradient(
          colors: [Color(0xFFF6D365), Color(0xFFFDA085), Color(0xFFE2B867)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 3,
            offset: const Offset(1, 1),
          ),
        ],
        border: Border.all(color: Colors.amber.shade200, width: 0.8),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 12,
            top: 0,
            bottom: 0,
            child: Container(width: 1, color: Colors.brown.withValues(alpha: 0.35)),
          ),
          Positioned(
            right: 12,
            top: 0,
            bottom: 0,
            child: Container(width: 1, color: Colors.brown.withValues(alpha: 0.35)),
          ),
          Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: Container(height: 1, color: Colors.brown.withValues(alpha: 0.35)),
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Container(height: 1, color: Colors.brown.withValues(alpha: 0.35)),
          ),
          Center(
            child: Container(
              width: 14,
              height: 12,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                border: Border.all(color: Colors.brown.withValues(alpha: 0.4), width: 0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () {
        _toggleSwipe(false);
        onTap();
      },
      borderRadius: BorderRadius.circular(25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: Colors.black.withValues(alpha: 0.08), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.black87, size: 18),
          ),
          const SizedBox(height: 3),
          SizedBox(
            width: 64,
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 8.5,
                fontWeight: FontWeight.w600,
                height: 1.1,
                letterSpacing: -0.1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionDrawer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionItem(
                icon: Icons.check_circle_outline_rounded,
                title: 'mark as paid',
                onTap: widget.onMarkAsPaid ?? widget.onSimulatePayment ?? () {},
              ),
              _buildActionItem(
                icon: Icons.history_rounded,
                title: 'payment history',
                onTap: widget.onPaymentHistory ?? () {},
              ),
              _buildActionItem(
                icon: Icons.sync_rounded,
                title: 'recent spends',
                onTap: widget.onRecentSpends ?? () {},
              ),
            ],
          ),
          const SizedBox(width: 14),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionItem(
                icon: Icons.description_outlined,
                title: 'smart statement',
                onTap: widget.onSmartStatement ?? () {},
              ),
              _buildActionItem(
                icon: Icons.percent_rounded,
                title: 'card perks',
                onTap: widget.onCardPerks ?? () {},
              ),
              _buildActionItem(
                icon: Icons.grid_view_rounded,
                title: 'more actions',
                onTap: widget.onMoreActions ?? () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.simpleCurrency();
    final dueMonthDay = DateFormat('d MMM').format(widget.card.dueDate).toUpperCase();

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity != null) {
          if (details.primaryVelocity! < -150) {
            _toggleSwipe(true);
          } else if (details.primaryVelocity! > 150) {
            _toggleSwipe(false);
          }
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: _buildActionDrawer(),
          ),
          AnimatedBuilder(
            animation: _swipeAnimation,
            builder: (context, child) {
              final screenWidth = MediaQuery.of(context).size.width;
              final offset = -_swipeAnimation.value * (screenWidth * 0.58);
              final angle = -_swipeAnimation.value * (pi / 32);

              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..setTranslationRaw(offset, 0.0, 0.0)
                  ..rotateY(angle),
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    if (_isSwipedOpen) {
                      _toggleSwipe(false);
                    }
                  },
                  child: Container(
                    height: 220,
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: _getCardGradient(),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.45),
                          blurRadius: 18,
                          offset: const Offset(0, 10),
                        ),
                      ],
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.22),
                        width: 1.2,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Opacity(
                              opacity: 0.08,
                              child: CustomPaint(
                                painter: _CardTexturePainter(
                                  patternType: widget.card.themePreset,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(alpha: 0.18),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.shield_outlined,
                                            size: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            widget.card.issuer.toUpperCase(),
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w900,
                                              letterSpacing: 1.5,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        currency.format(widget.card.statementBalance),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        widget.card.isPaidThisCycle
                                            ? '✓ PAID'
                                            : 'DUE ON $dueMonthDay',
                                        style: TextStyle(
                                          color: widget.card.isPaidThisCycle
                                              ? const Color(0xFF68D391)
                                              : Colors.white.withValues(alpha: 0.8),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  _buildEmvChip(),
                                  const SizedBox(width: 14),
                                  Text(
                                    '•• ${widget.card.lastFour}',
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.9),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 3,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'CHIRAG HS',
                                          style: TextStyle(
                                            color: Colors.white.withValues(alpha: 0.95),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 1.5,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          widget.card.cardName,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.white.withValues(alpha: 0.65),
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: widget.card.isPaidThisCycle
                                        ? null
                                        : (widget.onPayNow ?? widget.onSimulatePayment),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                      elevation: 3,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      disabledBackgroundColor: Colors.white.withValues(alpha: 0.4),
                                      disabledForegroundColor: Colors.black45,
                                    ),
                                    child: Text(
                                      widget.card.isPaidThisCycle ? 'Paid' : 'Pay now',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CardTexturePainter extends CustomPainter {
  final CardThemePreset patternType;

  _CardTexturePainter({required this.patternType});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    if (patternType == CardThemePreset.chaseSapphire) {
      for (double r = 40; r < size.width; r += 35) {
        canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.2), r, paint);
      }
    } else {
      final path = Path();
      for (int i = 0; i < 6; i++) {
        path.moveTo(0, size.height * (i / 5));
        path.lineTo(size.width, size.height * ((i + 1) / 6));
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
