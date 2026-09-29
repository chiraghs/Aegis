import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/theme.dart';
import '../models/subscription_tier.dart';
import '../providers/app_state.dart';
import '../services/stripe_web_funnel_service.dart';
import '../widgets/glass_container.dart';

class StripeWebFunnelScreen extends StatefulWidget {
  final SubscriptionTier initialTier;

  const StripeWebFunnelScreen({super.key, this.initialTier = SubscriptionTier.gold});

  @override
  State<StripeWebFunnelScreen> createState() => _StripeWebFunnelScreenState();
}

class _StripeWebFunnelScreenState extends State<StripeWebFunnelScreen> {
  late SubscriptionTier _selectedTier;
  bool _isProcessing = false;
  final _cardCtrl = TextEditingController(text: '4242 •••• •••• 4242');
  final _expCtrl = TextEditingController(text: '12/28');
  final _cvcCtrl = TextEditingController(text: '882');

  @override
  void initState() {
    super.initState();
    _selectedTier = widget.initialTier;
  }

  @override
  void dispose() {
    _cardCtrl.dispose();
    _expCtrl.dispose();
    _cvcCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleStripeCheckout(AppState appState) async {
    setState(() => _isProcessing = true);
    final success = await StripeWebFunnelService.instance.processStripeWebCheckout(
      tier: _selectedTier,
      cardNumber: _cardCtrl.text,
      expDate: _expCtrl.text,
      cvc: _cvcCtrl.text,
    );
    if (!mounted) return;
    setState(() => _isProcessing = false);

    if (success && context.mounted) {
      appState.debugSetTier(_selectedTier);
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppTheme.surfaceCardElevated,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: AppTheme.emeraldAccent),
              SizedBox(width: 8),
              Text('STRIPE WEB FUNNEL COMPLETE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
            ],
          ),
          content: Text(
            'Your direct web subscription via Stripe succeeded with a 20% discount. RevenueCat Web Entitlements are now live on your account!',
            style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pop();
              },
              child: const Text('EXPLORE PERKS', style: TextStyle(color: AppTheme.goldAccent, fontWeight: FontWeight.w800)),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isGold = _selectedTier == SubscriptionTier.gold;
    final webPrice = isGold ? StripeWebFunnelService.goldWebPrice : StripeWebFunnelService.blackWebPrice;
    final appStorePrice = isGold ? 4.99 : 9.99;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text(
          'STRIPE DIRECT WEB FUNNEL',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 1.5),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stripe Funnel Vision Award Banner
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF635BFF), Color(0xFF4338CA)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF635BFF).withValues(alpha: 0.3),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white24,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.flash_on, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'STRIPE FUNNEL VISION DISCOUNT',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Bypass 30% App Store fees. 20% discount passed directly to you via RevenueCat Web Billing + Stripe.',
                          style: TextStyle(fontSize: 11, color: Colors.white70, height: 1.3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Tier Selector
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTier = SubscriptionTier.gold),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isGold ? AppTheme.goldAccent.withValues(alpha: 0.15) : AppTheme.surfaceCard,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isGold ? AppTheme.goldAccent : AppTheme.surfaceBorder,
                          width: isGold ? 1.5 : 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('GOLD PASS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppTheme.goldAccent)),
                          const SizedBox(height: 4),
                          Text('\$3.99/mo', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white)),
                          const SizedBox(height: 2),
                          const Text('Save \$12/yr', style: TextStyle(fontSize: 10, color: AppTheme.emeraldAccent)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTier = SubscriptionTier.black),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: !isGold ? AppTheme.goldAccent.withValues(alpha: 0.15) : AppTheme.surfaceCard,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: !isGold ? AppTheme.goldAccent : AppTheme.surfaceBorder,
                          width: !isGold ? 1.5 : 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('BLACK EDITION', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppTheme.goldAccent)),
                          const SizedBox(height: 4),
                          Text('\$7.99/mo', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white)),
                          const SizedBox(height: 2),
                          const Text('Save \$24/yr', style: TextStyle(fontSize: 10, color: AppTheme.emeraldAccent)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Stripe Checkout Form Mock
            GlassContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'SECURE STRIPE CHECKOUT',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.2, color: AppTheme.textSecondary),
                      ),
                      Row(
                        children: [
                          Icon(Icons.lock, size: 12, color: AppTheme.emeraldAccent),
                          SizedBox(width: 4),
                          Text('End-to-End Encrypted', style: TextStyle(fontSize: 10, color: AppTheme.emeraldAccent)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _cardCtrl,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: InputDecoration(
                      labelText: 'Card Number',
                      labelStyle: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                      prefixIcon: const Icon(Icons.credit_card, size: 18, color: Color(0xFF635BFF)),
                      filled: true,
                      fillColor: AppTheme.surface,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _expCtrl,
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                          decoration: InputDecoration(
                            labelText: 'Expires (MM/YY)',
                            labelStyle: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                            filled: true,
                            fillColor: AppTheme.surface,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _cvcCtrl,
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                          decoration: InputDecoration(
                            labelText: 'CVC',
                            labelStyle: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                            filled: true,
                            fillColor: AppTheme.surface,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Web Funnel Rate:', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                      Row(
                        children: [
                          Text('\$$appStorePrice', style: const TextStyle(fontSize: 12, color: AppTheme.textMuted, decoration: TextDecoration.lineThrough)),
                          const SizedBox(width: 6),
                          Text('\$$webPrice/mo', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppTheme.emeraldAccent)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isProcessing ? null : () => _handleStripeCheckout(appState),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF635BFF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: _isProcessing
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text(
                              'PAY \$$webPrice WITH STRIPE',
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 1),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
