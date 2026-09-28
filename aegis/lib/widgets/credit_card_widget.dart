import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/credit_card_model.dart';
import '../constants/theme.dart';

class CreditCardWidget extends StatefulWidget {
  final CreditCardModel card;
  final VoidCallback? onSimulatePayment;

  const CreditCardWidget({
    super.key,
    required this.card,
    this.onSimulatePayment,
  });

  @override
  State<CreditCardWidget> createState() => _CreditCardWidgetState();
}

class _CreditCardWidgetState extends State<CreditCardWidget> with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _flipAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _toggleFlip() {
    if (_isFront) {
      _flipController.forward();
    } else {
      _flipController.reverse();
    }
    setState(() {
      _isFront = !_isFront;
    });
  }

  LinearGradient _getCardGradient() {
    switch (widget.card.themePreset) {
      case CardThemePreset.amexGold:
        return AppTheme.goldGradient;
      case CardThemePreset.chaseSapphire:
        return AppTheme.chaseGradient;
      case CardThemePreset.ventureX:
        return AppTheme.ventureGradient;
      case CardThemePreset.appleTitanium:
        return AppTheme.blackEditionGradient;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.simpleCurrency();

    return AnimatedBuilder(
      animation: _flipAnimation,
      builder: (context, child) {
        final angle = _flipAnimation.value * pi;
        final isFrontSide = angle < (pi / 2);

        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle),
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: _toggleFlip,
            child: Container(
              width: double.infinity,
              height: 220,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: _getCardGradient(),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: isFrontSide ? _buildFront(currency) : _buildBack(currency),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFront(NumberFormat currency) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top Row: Issuer & Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.white30),
                    ),
                    child: const Icon(Icons.credit_card, size: 16, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.card.issuer.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: widget.card.isPaidThisCycle
                      ? AppTheme.emeraldAccent.withOpacity(0.2)
                      : Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: widget.card.isPaidThisCycle
                        ? AppTheme.emeraldAccent
                        : Colors.white24,
                  ),
                ),
                child: Text(
                  widget.card.isPaidThisCycle
                      ? '✓ BILL CLEARED'
                      : 'DUE IN ${widget.card.daysUntilDue} DAYS',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: widget.card.isPaidThisCycle
                        ? AppTheme.emeraldAccent
                        : Colors.white,
                  ),
                ),
              ),
            ],
          ),

          // Middle: Masked Number & Card Name
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '•••• •••• •••• ${widget.card.lastFour}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 3,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.card.cardName,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withOpacity(0.85),
                ),
              ),
            ],
          ),

          // Bottom: Balance & Utilization Bar
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CURRENT BALANCE',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                      Text(
                        currency.format(widget.card.currentBalance),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'UTILIZATION',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                      Text(
                        '${(widget.card.utilizationRate * 100).toStringAsFixed(1)}%',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: widget.card.utilizationRate,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    widget.card.utilizationRate > 0.3
                        ? AppTheme.crimsonAccent
                        : (widget.card.utilizationRate > 0.1
                            ? AppTheme.amberAccent
                            : AppTheme.emeraldAccent),
                  ),
                  minHeight: 4,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBack(NumberFormat currency) {
    // Rotated 180 degrees back to normal readable text
    return Transform(
      transform: Matrix4.identity()..rotateY(pi),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'STATEMENT & BENEFITS',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                Text(
                  'APR ${widget.card.apr}%',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.card.topPerks.map((perk) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 14, color: AppTheme.goldAccentLight),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          perk,
                          style: const TextStyle(fontSize: 11, color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'STATEMENT DUE',
                        style: TextStyle(fontSize: 9, color: Colors.white.withOpacity(0.7)),
                      ),
                      Text(
                        currency.format(widget.card.statementBalance),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!widget.card.isPaidThisCycle)
                  ElevatedButton.icon(
                    onPressed: widget.onSimulatePayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      elevation: 4,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.bolt, size: 16, color: Colors.orange),
                    label: const Text(
                      'Simulate Bank Pay',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
                    ),
                  )
                else
                  const Chip(
                    label: Text(
                      '✓ Cleared & Rewarded',
                      style: TextStyle(fontSize: 11, color: AppTheme.emeraldAccent, fontWeight: FontWeight.w700),
                    ),
                    backgroundColor: Colors.black45,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
