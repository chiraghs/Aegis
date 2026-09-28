# Aegis: Credit, Garage & Asset Command Center

Built for the **RevenueCat Shipaton 2026** Hackathon.

Aegis is the dark-luxury command center for American consumers, unifying **Multi-Card Credit Due-Date Tracking**, **Automotive Garage Equity & Telematics**, and **Non-Custodial Gamified Bill Payments** into a single high-net-worth mobile app.

---

## Key Features

1. **Urgent Due Date Radar:** Aggregated statement liabilities across Chase, Amex, and Capital One with dynamic credit utilization meters.
2. **Zero-MTL Gamified Rewards Loop:** Non-custodial verification of external bill payments via balance-drop tracking, minting Aegis Coins without financial transmitter liability.
3. **The Aegis Garage:** Real-time 17-digit VIN decoding via the official US Government NHTSA vPIC REST API, tracking vehicle equity vs. auto loan balances and safety recall bulletins.
4. **RevenueCat In-App Monetization:** Multi-tier subscriptions ("Gold Pass" & "Black Edition") unlocking the AI Card Swipe Advisor, unlimited portfolio cards, and VIP mystery drops.
5. **OneSignal Retention Engine:** Automated 3-day bill due-date countdown alerts, payment verification celebrations, and urgent vehicle recall pushes.

---

## Tech Stack

* **Frontend:** Flutter 3.x (Dart) with Impeller hardware acceleration
* **Monetization:** RevenueCat Purchases SDK (`purchases_flutter` v10)
* **Push Notifications:** OneSignal Flutter SDK v5 (`onesignal_flutter` v5.7)
* **Automotive Intelligence:** US NHTSA vPIC REST API
* **License:** MIT License

---

## Running Locally

```bash
# Get dependencies
flutter pub get

# Run on Chrome
flutter run -d chrome

# Run tests
flutter test

# Build for Web
flutter build web

# Build for Android
flutter build appbundle
```
