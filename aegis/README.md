# Aegis: Credit, Garage & Asset Command Center

Built for the **RevenueCat Shipaton 2026** Hackathon.

Aegis is the dark-luxury command center for American consumers, unifying **Multi-Card Credit Due-Date Tracking**, **Automotive Garage Equity & Telematics**, and **Non-Custodial Gamified Bill Payments** into a single high-net-worth mobile app.

---

## Key Features

1. **Urgent Due Date Radar:** Aggregated statement liabilities across Chase, Amex, and Capital One with dynamic credit utilization meters.
2. **Unified Net Worth Engine:** Real-time net worth calculation aggregating liquid cash, investment portfolios, real estate, and vehicle equity minus credit debt and auto loans.
3. **Zero-MTL Gamified Rewards Loop:** Non-custodial verification of external bill payments via balance-drop tracking, minting Aegis Coins without financial transmitter liability.
4. **The Aegis Garage:** Real-time 17-digit VIN decoding via the official US Government NHTSA vPIC REST API, tracking vehicle equity vs. auto loan balances and safety recall bulletins.
5. **RevenueCat In-App Monetization:** Multi-tier subscriptions ("Gold Pass" & "Black Edition") unlocking the AI Card Swipe Advisor, unlimited portfolio cards, and VIP mystery drops.

---

## 🏆 RevenueCat Shipaton 2026: Sponsor & Partner Awards

Aegis implements deeply integrated features tailored specifically for 5 hackathon partner award tracks:

### 1. OneSignal — "Keep Them Coming Back Award" (\$25,000)
* **OneSignal Radar Inbox:** Full in-app notification center (`lib/screens/notifications_inbox_screen.dart`) displaying past push journeys, bill countdown alerts, and recall advisories.
* **Rich User Segmentation Tags:** Automatically syncs user financial attributes (`wealth_tier`, `nearest_due_days`, `garage_vehicles`, `subscription_tier`) into OneSignal for hyper-personalized push targeting.
* **Interactive Push Simulator:** Allows judges and reviewers to simulate real-time push delivery and verify retention journeys with 1 tap.

### 2. Samsung Galaxy — "Best App for Galaxy" (\$20,000)
* **Galaxy Z Fold Dual-Pane Mode:** Dynamically splits into master-detail layout when unfolded on Samsung Galaxy Z Fold or Galaxy Tab (screen width >= 720dp).
* **Continuous Adaptive Responsiveness:** Master radar remains interactive on the left pane while deep-dive analytics or garage telematics display on the companion right pane.

### 3. Stripe — "Funnel Vision Award" (\$20,000)
* **Direct Web Checkout Funnel:** Dedicated web checkout (`lib/screens/stripe_web_funnel_screen.dart`) powered by Stripe Elements, offering a 20% discount on Aegis Club Passes.
* **RevenueCat Web Billing Sync:** Bypasses 30% app store platform fees while maintaining unified entitlement status synchronized directly into RevenueCat.

### 4. Layers — "The Growth Loop Award" (\$20,000)
* **Paywall A/B Experimentation Engine:** Dynamic multi-variant testing (`lib/services/layers_growth_service.dart`) testing Variant A (*"Asset Shield & Defense"*) against Variant B (*"Luxury Status & Multipliers"*) with live impression and conversion rate metrics.
* **VIP Referral Growth Loop:** Embedded invite loop (`lib/widgets/referral_growth_loop_widget.dart`) rewarding both referrer and referee with 500 Aegis Coins upon their first cleared statement.

### 5. Noise — "Most Viral App Award" (\$20,000)
* **"Flex Your Shield" 9:16 Vertical Story Generator:** High-fashion, dark-luxury vertical brag card (`lib/widgets/viral_shield_story_card.dart`) designed specifically for Instagram Stories, TikTok, and X.
* **Smart Privacy Masking:** 1-tap privacy toggle allows users to mask exact dollar amounts while showing off their tier status, 5x multiplier, and streak badges.

---

## Tech Stack

* **Frontend:** Flutter 3.x (Dart) with Impeller hardware acceleration
* **Monetization:** RevenueCat Purchases SDK (`purchases_flutter` v10)
* **Web Billing:** Stripe Web Funnel integration
* **Push Notifications:** OneSignal Flutter SDK v5 (`onesignal_flutter` v5.7)
* **Automotive Intelligence:** US NHTSA vPIC REST API
* **State Management:** Provider with reactive ChangeNotifiers
* **License:** MIT License

---

## Running Locally

```bash
# Get dependencies
flutter pub get

# Run tests (19 passing unit & widget tests)
flutter test

# Run static analysis (0 issues)
flutter analyze

# Run on Chrome
flutter run -d chrome

# Build for Web
flutter build web --release

# Build for Android
flutter build appbundle
```
