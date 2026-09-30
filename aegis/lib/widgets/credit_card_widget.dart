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
  bool _isSwipedOpen = false;

  @override
  void initState() {
    super.initState();
    _swipeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
  }

  @override
  void dispose() {
    _swipeController.dispose();
    super.dispose();
  }

  void _toggleSwipe([bool? open]) {
    final target = open ?? !_isSwipedOpen;
    _isSwipedOpen = target;
    if (target) {
      _swipeController.animateTo(
        1.0,
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeOutBack,
      );
    } else {
      _swipeController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    }
    setState(() {});
  }

  LinearGradient _getCardGradient() {
    switch (widget.card.themePreset) {
      case CardThemePreset.amexGold:
        return const LinearGradient(
          colors: [Color(0xFFD4AF37), Color(0xFFECCB7A), Color(0xFFC59B3C), Color(0xFF8B6508)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case CardThemePreset.chaseSapphire:
        return const LinearGradient(
          colors: [Color(0xFF071B3E), Color(0xFF0F326E), Color(0xFF133E82), Color(0xFF040C1A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case CardThemePreset.ventureX:
        return const LinearGradient(
          colors: [Color(0xFF141720), Color(0xFF222736), Color(0xFF181B24), Color(0xFF0D0E13)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case CardThemePreset.appleTitanium:
        return const LinearGradient(
          colors: [Color(0xFFF7F7FA), Color(0xFFECECF0), Color(0xFFDDDEE5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case CardThemePreset.mintGreen:
        return const LinearGradient(
          colors: [Color(0xFF86EA45), Color(0xFF7DE43A), Color(0xFF5ABF1C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case CardThemePreset.charcoal:
        return const LinearGradient(
          colors: [Color(0xFF2B2B2B), Color(0xFF1E1E1E), Color(0xFF121212)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  Widget _buildEmvChip(CardThemePreset preset) {
    final List<Color> chipColors;
    final Color borderColor;
    final Color lineTone;

    if (preset == CardThemePreset.chaseSapphire) {
      chipColors = [const Color(0xFFE0E3E8), const Color(0xFFB5BAC5), const Color(0xFFD0D5DE)];
      borderColor = const Color(0xFF9EA5B2);
      lineTone = Colors.black.withValues(alpha: 0.3);
    } else if (preset == CardThemePreset.appleTitanium) {
      chipColors = [const Color(0xFFFED6E3), const Color(0xFFA8EDEA), const Color(0xFFFEE140)];
      borderColor = const Color(0xFFCCD1D9);
      lineTone = Colors.black.withValues(alpha: 0.25);
    } else if (preset == CardThemePreset.ventureX) {
      chipColors = [const Color(0xFF5A606D), const Color(0xFF383C44), const Color(0xFF4A4F59)];
      borderColor = const Color(0xFF6B7280);
      lineTone = Colors.white.withValues(alpha: 0.25);
    } else {
      chipColors = [const Color(0xFFF6D365), const Color(0xFFFDA085), const Color(0xFFE2B867)];
      borderColor = Colors.amber.shade200;
      lineTone = Colors.brown.withValues(alpha: 0.4);
    }

    return Container(
      width: 42,
      height: 32,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        gradient: LinearGradient(
          colors: chipColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 3,
            offset: const Offset(1, 1),
          ),
        ],
        border: Border.all(color: borderColor, width: 0.8),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 11,
            top: 0,
            bottom: 0,
            child: Container(width: 1, color: lineTone),
          ),
          Positioned(
            right: 11,
            top: 0,
            bottom: 0,
            child: Container(width: 1, color: lineTone),
          ),
          Positioned(
            top: 9,
            left: 0,
            right: 0,
            child: Container(height: 1, color: lineTone),
          ),
          Positioned(
            bottom: 9,
            left: 0,
            right: 0,
            child: Container(height: 1, color: lineTone),
          ),
          Center(
            child: Container(
              width: 13,
              height: 11,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                border: Border.all(color: lineTone, width: 0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardBrandHeader(CreditCardModel card, Color textColor, Color iconBg, Color iconColor) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: _buildCardBrandHeaderContent(card, textColor, iconBg, iconColor),
    );
  }

  Widget _buildCardBrandHeaderContent(CreditCardModel card, Color textColor, Color iconBg, Color iconColor) {
    final preset = card.themePreset;

    if (preset == CardThemePreset.amexGold) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          border: Border.all(color: textColor.withValues(alpha: 0.6), width: 1.2),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          'AMERICAN EXPRESS',
          style: TextStyle(
            color: textColor,
            fontSize: 10.5,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
          ),
        ),
      );
    } else if (preset == CardThemePreset.chaseSapphire) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomPaint(
            size: const Size(18, 18),
            painter: _ChasePinwheelPainter(color: textColor),
          ),
          const SizedBox(width: 7),
          Text(
            'CHASE',
            style: TextStyle(
              color: textColor,
              fontSize: 13.5,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.2,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'RESERVE',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 8.0,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ],
      );
    } else if (preset == CardThemePreset.ventureX) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Capital One',
            style: TextStyle(
              color: textColor,
              fontSize: 13,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(width: 5),
          Transform.rotate(
            angle: -0.3,
            child: Container(
              width: 12,
              height: 3,
              decoration: BoxDecoration(
                color: const Color(0xFFD92D20),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            'venture X',
            style: TextStyle(
              color: textColor.withValues(alpha: 0.85),
              fontSize: 10,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
              letterSpacing: 0.8,
            ),
          ),
        ],
      );
    } else if (preset == CardThemePreset.appleTitanium) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.apple, size: 22, color: textColor),
          const SizedBox(width: 4),
          Text(
            'Apple Card',
            style: TextStyle(
              color: textColor,
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
            ),
          ),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: iconBg,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.shield_outlined,
            size: 14,
            color: iconColor,
          ),
        ),
        const SizedBox(width: 7),
        Text(
          card.issuer.toUpperCase(),
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: textColor,
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildNetworkBadge(CardNetwork network, CardThemePreset preset, Color textColor) {
    if (preset == CardThemePreset.appleTitanium) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade400.withValues(alpha: 0.6),
            ),
          ),
          Transform.translate(
            offset: const Offset(-5, 0),
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade500.withValues(alpha: 0.6),
              ),
            ),
          ),
        ],
      );
    } else if (preset == CardThemePreset.amexGold || network == CardNetwork.amex) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        decoration: BoxDecoration(
          color: const Color(0xFF261904).withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: const Color(0xFF261904).withValues(alpha: 0.35), width: 0.8),
        ),
        child: const Text(
          'AMEX',
          style: TextStyle(
            fontSize: 9.5,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            color: Color(0xFF261904),
          ),
        ),
      );
    } else if (network == CardNetwork.visa) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'VISA',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              letterSpacing: 1.2,
              color: textColor,
            ),
          ),
          Text(
            'Infinite',
            style: TextStyle(
              fontSize: 7.0,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic,
              letterSpacing: 0.5,
              color: textColor.withValues(alpha: 0.85),
            ),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFEB001B),
            ),
          ),
          Transform.translate(
            offset: const Offset(-5, 0),
            child: Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF79E1B),
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildActionItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required int staggerIndex,
  }) {
    return AnimatedBuilder(
      animation: _swipeController,
      builder: (context, child) {
        final startTime = (staggerIndex * 0.12).clamp(0.0, 0.6);
        final endTime = (startTime + 0.4).clamp(0.0, 1.0);
        final itemProgress = ((_swipeController.value - startTime) / (endTime - startTime)).clamp(0.0, 1.0);

        final scale = 0.5 + 0.5 * Curves.easeOutBack.transform(itemProgress);
        final opacity = Curves.easeIn.transform(itemProgress);
        final slideX = (1.0 - Curves.easeOutCubic.transform(itemProgress)) * 20.0;

        return Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: Offset(slideX, 0),
            child: Transform.scale(
              scale: scale,
              child: child,
            ),
          ),
        );
      },
      child: InkWell(
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
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
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
      ),
    );
  }

  Widget _buildActionDrawer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      alignment: Alignment.centerRight,
      child: FittedBox(
        fit: BoxFit.scaleDown,
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
                staggerIndex: 0,
              ),
              _buildActionItem(
                icon: Icons.history_rounded,
                title: 'payment history',
                onTap: widget.onPaymentHistory ?? () {},
                staggerIndex: 1,
              ),
              _buildActionItem(
                icon: Icons.sync_rounded,
                title: 'recent spends',
                onTap: widget.onRecentSpends ?? () {},
                staggerIndex: 2,
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
                staggerIndex: 1,
              ),
              _buildActionItem(
                icon: Icons.percent_rounded,
                title: 'card offers',
                onTap: widget.onCardPerks ?? () {},
                staggerIndex: 2,
              ),
              _buildActionItem(
                icon: Icons.grid_view_rounded,
                title: 'more actions',
                onTap: widget.onMoreActions ?? () {},
                staggerIndex: 3,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.simpleCurrency();
    final dueMonthDay = DateFormat('d MMM').format(widget.card.dueDate).toUpperCase();
    final preset = widget.card.themePreset;
    final isMint = preset == CardThemePreset.mintGreen;
    final isApple = preset == CardThemePreset.appleTitanium;
    final isAmex = preset == CardThemePreset.amexGold;

    final Color cardTextColor;
    final Color cardTextSecondary;
    final Color cardIconBg;
    final Color cardIconColor;
    final Color payBtnBg;
    final Color payBtnFg;

    if (isMint) {
      cardTextColor = const Color(0xFF1E2818);
      cardTextSecondary = const Color(0xFF2C3925);
      cardIconBg = Colors.black.withValues(alpha: 0.12);
      cardIconColor = const Color(0xFF1E2818);
      payBtnBg = const Color(0xFF2B2B2B);
      payBtnFg = Colors.white;
    } else if (isApple) {
      cardTextColor = const Color(0xFF1C1C1E);
      cardTextSecondary = const Color(0xFF6E6E73);
      cardIconBg = Colors.black.withValues(alpha: 0.08);
      cardIconColor = const Color(0xFF1C1C1E);
      payBtnBg = const Color(0xFF1C1C1E);
      payBtnFg = Colors.white;
    } else if (isAmex) {
      cardTextColor = const Color(0xFF261904);
      cardTextSecondary = const Color(0xFF4C330B);
      cardIconBg = const Color(0xFF261904).withValues(alpha: 0.12);
      cardIconColor = const Color(0xFF261904);
      payBtnBg = const Color(0xFF261904);
      payBtnFg = const Color(0xFFECCB7A);
    } else {
      cardTextColor = Colors.white;
      cardTextSecondary = Colors.white.withValues(alpha: 0.82);
      cardIconBg = Colors.white.withValues(alpha: 0.18);
      cardIconColor = Colors.white;
      payBtnBg = Colors.white;
      payBtnFg = Colors.black;
    }

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        final screenWidth = MediaQuery.of(context).size.width;
        final maxDrag = screenWidth * 0.58;
        final deltaProgress = -details.primaryDelta! / maxDrag;
        _swipeController.value = (_swipeController.value + deltaProgress).clamp(0.0, 1.0);
      },
      onHorizontalDragEnd: (details) {
        final velocity = details.primaryVelocity ?? 0;
        if (velocity < -250) {
          _toggleSwipe(true);
        } else if (velocity > 250) {
          _toggleSwipe(false);
        } else {
          if (_swipeController.value > 0.35) {
            _toggleSwipe(true);
          } else {
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
            animation: _swipeController,
            builder: (context, child) {
              final screenWidth = MediaQuery.of(context).size.width;
              final t = _swipeController.value;
              final offset = -t * (screenWidth * 0.58);
              final rotateY = -t * (pi / 22);
              final rotateZ = -t * 0.02;
              final scale = 1.0 - (t * 0.025);

              final shadowBlur = 18.0 + (t * 10.0);
              final shadowOffset = Offset(-t * 8.0, 10.0 + (t * 6.0));
              final shadowAlpha = isMint ? (0.25 + (t * 0.1)) : (0.45 + (t * 0.15));

              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.0012)
                  ..setTranslationRaw(offset, 0.0, 0.0)
                  ..rotateY(rotateY)
                  ..rotateZ(rotateZ)
                  ..scaleByDouble(scale, scale, 1.0, 1.0),
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
                          color: Colors.black.withValues(alpha: shadowAlpha),
                          blurRadius: shadowBlur,
                          offset: shadowOffset,
                        ),
                      ],
                      border: Border.all(
                        color: isMint
                            ? Colors.black.withValues(alpha: 0.12)
                            : Colors.white.withValues(alpha: 0.22 + (t * 0.1)),
                        width: 1.2,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Opacity(
                              opacity: isMint ? 0.12 : 0.08,
                              child: CustomPaint(
                                painter: _CardTexturePainter(
                                  patternType: widget.card.themePreset,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Dynamic specular sheen light sweep that follows the swipe gesture
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment(-1.5 + (t * 2.8), -1.0),
                                  end: Alignment(-0.5 + (t * 2.8), 1.0),
                                  colors: [
                                    Colors.white.withValues(alpha: 0.0),
                                    Colors.white.withValues(alpha: 0.15 * t),
                                    Colors.white.withValues(alpha: 0.0),
                                  ],
                                  stops: const [0.0, 0.5, 1.0],
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
                                    child: _buildCardBrandHeader(widget.card, cardTextColor, cardIconBg, cardIconColor),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        currency.format(widget.card.statementBalance),
                                        style: TextStyle(
                                          color: cardTextColor,
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
                                              ? (isMint ? const Color(0xFF1B6A20) : const Color(0xFF68D391))
                                              : cardTextSecondary,
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
                                  _buildEmvChip(widget.card.themePreset),
                                  const SizedBox(width: 14),
                                  Text(
                                    '•• ${widget.card.lastFour}',
                                    style: TextStyle(
                                      color: cardTextColor,
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
                                            color: cardTextColor,
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
                                            color: cardTextSecondary,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      _buildNetworkBadge(widget.card.network, widget.card.themePreset, cardTextColor),
                                      const SizedBox(width: 10),
                                      ElevatedButton(
                                        onPressed: widget.card.isPaidThisCycle
                                            ? null
                                            : (widget.onPayNow ?? widget.onSimulatePayment),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: payBtnBg,
                                          foregroundColor: payBtnFg,
                                          elevation: 3,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 7,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          disabledBackgroundColor: payBtnBg.withValues(alpha: 0.4),
                                          disabledForegroundColor: payBtnFg.withValues(alpha: 0.5),
                                        ),
                                        child: Text(
                                          widget.card.isPaidThisCycle ? 'Paid' : 'Pay now',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 0.4,
                                            color: payBtnFg,
                                          ),
                                        ),
                                      ),
                                    ],
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
    if (patternType == CardThemePreset.chaseSapphire) {
      _paintSapphireFacets(canvas, size);
    } else if (patternType == CardThemePreset.amexGold) {
      _paintAmexGuillocheAndCenturion(canvas, size);
    } else if (patternType == CardThemePreset.ventureX) {
      _paintVentureBrushedGrain(canvas, size);
    } else if (patternType == CardThemePreset.appleTitanium) {
      _paintTitaniumBrushedMetal(canvas, size);
    } else {
      _paintGeometricWaves(canvas, size);
    }
  }

  void _paintSapphireFacets(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF63B3ED).withValues(alpha: 0.35)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final glowPaint = Paint()
      ..color = const Color(0xFF3182CE).withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;
    final center = Offset(w * 0.72, h * 0.40);

    final nodes = [
      center,
      Offset(w * 0.45, h * 0.10),
      Offset(w * 0.95, h * 0.05),
      Offset(w * 0.98, h * 0.65),
      Offset(w * 0.65, h * 0.90),
      Offset(w * 0.35, h * 0.70),
      Offset(w * 0.20, h * 0.30),
      Offset(w * 0.50, h * 0.95),
      Offset(w * 0.85, h * 0.95),
    ];

    for (int i = 1; i < nodes.length; i++) {
      canvas.drawLine(center, nodes[i], paint);
      canvas.drawLine(nodes[i], nodes[(i % (nodes.length - 1)) + 1], paint);
    }

    final facetPath = Path()
      ..moveTo(nodes[1].dx, nodes[1].dy)
      ..lineTo(nodes[2].dx, nodes[2].dy)
      ..lineTo(center.dx, center.dy)
      ..close();
    canvas.drawPath(facetPath, glowPaint);
  }

  void _paintAmexGuillocheAndCenturion(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final strokePaint = Paint()
      ..color = const Color(0xFF543806).withValues(alpha: 0.28)
      ..strokeWidth = 1.1
      ..style = PaintingStyle.stroke;

    // 1. Dual Outer Guilloche Borders with indented corner frets
    const inset = 7.0;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTRB(inset, inset, w - inset, h - inset), const Radius.circular(13)),
      strokePaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTRB(inset + 4, inset + 4, w - inset - 4, h - inset - 4), const Radius.circular(10)),
      strokePaint,
    );

    // 2. Centered Roman Centurion Cameo Watermark
    final center = Offset(w * 0.50, h * 0.52);
    const cameoRadius = 38.0;

    canvas.drawCircle(center, cameoRadius, strokePaint);
    canvas.drawCircle(center, cameoRadius - 4, strokePaint);

    final centurionPaint = Paint()
      ..color = const Color(0xFF543806).withValues(alpha: 0.22)
      ..style = PaintingStyle.fill;

    // Helmet plume / crest
    final crestPath = Path();
    crestPath.moveTo(center.dx - 18, center.dy - 10);
    crestPath.quadraticBezierTo(center.dx, center.dy - 32, center.dx + 20, center.dy - 12);
    crestPath.quadraticBezierTo(center.dx + 4, center.dy - 22, center.dx - 18, center.dy - 10);
    crestPath.close();
    canvas.drawPath(crestPath, centurionPaint);

    // Helmet & face profile
    final profilePath = Path();
    profilePath.moveTo(center.dx - 12, center.dy - 8);
    profilePath.lineTo(center.dx + 12, center.dy - 8);
    profilePath.lineTo(center.dx + 14, center.dy + 8);
    profilePath.lineTo(center.dx + 8, center.dy + 14);
    profilePath.lineTo(center.dx + 2, center.dy + 22);
    profilePath.lineTo(center.dx - 10, center.dy + 18);
    profilePath.close();
    canvas.drawPath(profilePath, centurionPaint);
  }

  void _paintVentureBrushedGrain(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.045)
      ..strokeWidth = 0.8;

    for (double y = 4; y < size.height; y += 4) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  void _paintTitaniumBrushedMetal(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.04)
      ..strokeWidth = 0.6;

    for (double y = 2; y < size.height; y += 3) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  void _paintGeometricWaves(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.15)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    for (int i = 0; i < 5; i++) {
      path.moveTo(0, size.height * (i / 4));
      path.quadraticBezierTo(
        size.width * 0.5,
        size.height * ((i + 1) / 5),
        size.width,
        size.height * (i / 4),
      );
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ChasePinwheelPainter extends CustomPainter {
  final Color color;

  _ChasePinwheelPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);

    for (int i = 0; i < 4; i++) {
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(i * (pi / 2));

      final blade = Path()
        ..moveTo(0, -h * 0.45)
        ..lineTo(w * 0.35, -h * 0.45)
        ..lineTo(w * 0.45, -h * 0.15)
        ..lineTo(w * 0.12, -h * 0.15)
        ..close();

      canvas.drawPath(blade, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
