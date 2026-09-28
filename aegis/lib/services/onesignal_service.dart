import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalService {
  static final OneSignalService instance = OneSignalService._internal();
  OneSignalService._internal();

  // App ID provided by the user
  static const String appId = 'd9515184-c70b-438c-8d11-92905402c913';

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  bool _isInitialized = false;
  bool _hasShownVerificationDialog = false;

  // Framework-retained reference to prevent weak-reference deallocation
  late final dynamic _pushSubscriptionObserver;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

      // 1. Initialize OneSignal with user-specified App ID
      OneSignal.initialize(appId);

      _isInitialized = true;
      debugPrint('OneSignal initialized with App ID: $appId');

      // 2. Set up retained push subscription observer for verification
      _setupPushSubscriptionObserver();

      // 3. Notification click listener
      OneSignal.Notifications.addClickListener((event) {
        debugPrint('NOTIFICATION CLICKED: ${event.notification.title} - ${event.notification.body}');
      });
    } catch (e) {
      debugPrint('OneSignal initialization notice: $e');
    }
  }

  void _setupPushSubscriptionObserver() {
    // Retain observer callback to prevent weak-reference garbage collection
    _pushSubscriptionObserver = (OSPushSubscriptionChangedState state) {
      final subId = state.current.id;
      _checkSubscriptionAndPrompt(subId);
    };

    OneSignal.User.pushSubscription.addObserver(_pushSubscriptionObserver);

    // 4. Evaluate current subscription ID immediately at observer-registration time
    final currentId = OneSignal.User.pushSubscription.id;
    _checkSubscriptionAndPrompt(currentId);
  }

  void _checkSubscriptionAndPrompt(String? subscriptionId) {
    if (_hasShownVerificationDialog) return;

    // Must be non-empty and NOT prefixed with 'local-'
    if (subscriptionId != null &&
        subscriptionId.isNotEmpty &&
        !subscriptionId.startsWith('local-')) {
      _hasShownVerificationDialog = true;
      _showVerificationDialog();
    }
  }

  void _showVerificationDialog() {
    final context = navigatorKey.currentContext;
    if (context == null) {
      // If navigator context isn't mounted yet, retry shortly
      Future.delayed(const Duration(milliseconds: 500), _showVerificationDialog);
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Your OneSignal SDK integration is complete!'),
        content: const Text(
          'You can now send Push Notifications & In-App Messages through OneSignal. Tap below to enable push notifications.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              // On button tap, request push permission
              OneSignal.Notifications.requestPermission(true);
            },
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  /// Tag user attributes for automated segment campaigns
  void setUserSegments({
    required String tier,
    required int streakDays,
    required double totalLiabilities,
  }) {
    if (!_isInitialized) return;
    try {
      OneSignal.User.addTags({
        'subscription_tier': tier,
        'streak_days': streakDays.toString(),
        'has_due_bill': totalLiabilities > 0 ? 'true' : 'false',
      });
    } catch (e) {
      debugPrint('OneSignal tag error: $e');
    }
  }
}
