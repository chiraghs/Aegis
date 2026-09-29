# 🛡️ Aegis: Credit, Garage & Asset Command Center
> **Official Submission for the RevenueCat Shipaton 2026 Hackathon**

<p align="center">
  <img src="assets/aegis_app_icon_1024x1024.jpg" width="140" alt="Aegis Icon" style="border-radius: 28px;" />
</p>

Aegis is an ultra-luxury, non-custodial command center unifying **Multi-Card Credit Due-Date Tracking**, **Automotive Garage Equity & Telematics**, and **Gamified External Bill Payments** into a single high-net-worth mobile app.

---

## 🏆 Hackathon Target Categories

* **The HAMM Award (Help Apps Make Money)** — RevenueCat multi-tier subscription engine (`gold_pass` & `black_edition`)
* **Keep Them Coming Back Award (OneSignal)** — Intelligent 3-day due date countdowns, payment celebrations & recall pushes (App ID: `d9515184-c70b-438c-8d11-92905402c913`)
* **RevenueCat Design Award** — Flat matte dark obsidian UI, 3D flip card physics & real-time utilization meters
* **Best App for Galaxy** — Samsung Galaxy Store release
* **The Grand Prize** ($100,000)

---

## 📸 App Preview

<p align="center">
  <img src="assets/aegis_screenshot_1179x2556.jpg" width="320" alt="Aegis App UI" />
</p>

---

## ✨ Core Pillars

### 1. Multi-Card Due Date Radar
* **Aggregated Countdown:** Real-time countdown to the earliest statement due date across all cards (Amex, Chase, Capital One).
* **3D Flip Cards:** Interactive 3D cards displaying current balances, available credit, statement balances, APRs, and utilization ratios.
* **Credit Utilization Shield:** Smart alerts when revolving credit utilization crosses 10% or 30%, protecting credit scores.

### 2. Zero-MTL Gamified Rewards Loop
* **Non-Custodial Tracking:** Eliminates costly Money Transmitter Licenses (MTLs) by tracking external payments rather than moving money directly.
* **Balance Drop Verification:** Detects when statement balances drop near due dates, verifying external payments and minting **Aegis Coins**.
* **Curated Perks:** Redeem coins for Apple Gift Cards, Uber Black vouchers, and Equinox guest passes.

### 3. The Aegis Garage
* **NHTSA 17-Digit VIN Decoder:** Official US Government NHTSA vPIC REST API integration for instant vehicle specs, trim, and safety recalls.
* **Equity Calculator:** Real-time vehicle resale valuation against auto loan balances.
* **Telematics:** Battery/fuel level indicators, mileage tracking, and maintenance schedules.

### 4. RevenueCat Monetization & Paywalls
* **Member (Free):** Up to 2 cards, 1 garage vehicle, basic due date radar.
* **Gold Pass ($4.99/mo or $39.99/yr):** Unlimited cards, multi-car garage, NHTSA safety recall alerts, 2x coin multiplier.
* **Black Edition ($9.99/mo or $79.99/yr):** AI Card Swipe Advisor (recommends optimal card per merchant category for 3x–5x points), 5x coin multiplier, VIP reward drops.

### 5. OneSignal Retention Engine
* **Urgent Radar Push:** 3-day due-date warnings preventing $40 late fees and APR penalties.
* **Payment Celebrations:** Instant push notifications confirming verified balance drops.
* **Safety Bulletins:** High-priority pushes for NHTSA vehicle recalls.

### 6. Unified Net Worth Engine
* **Multi-Asset Balance Sheet:** Live aggregate balance tracking across liquid cash, high-yield savings (4.4% APY), stock market index funds, real estate equity, physical vehicles, and crypto cold storage.
* **6-Month Trajectory Curve:** Custom-painted interactive canvas line chart with touch point inspection.
* **Asset Allocation Bar:** Stacked proportional distribution breakdown.
* **Wealth Health Audit (RevenueCat Gated):** Calculates liquid living runway (months of living expenses covered by cash) and debt-to-asset ratios.

---

## 🌐 External APIs & Data Integrations

Aegis connects to production-grade external REST APIs and SDK services to power real-time valuations, notifications, and balance sheet monitoring:

| External Service / API | Integration Endpoint | Data Fetched / Functionality | Code Location |
| :--- | :--- | :--- | :--- |
| **US Dept of Transportation (NHTSA vPIC API)** | `https://vpic.nhtsa.dot.gov/api/vehicles/DecodeVin/{vin}?format=json` | **Live 17-digit VIN Decoding**: Real-time vehicle make, model, year, trim level, fuel/EV classification, assembly plant, and safety recall checks. Zero API key required (public federal endpoint). | [`lib/services/nhtsa_vehicle_service.dart`](aegis/lib/services/nhtsa_vehicle_service.dart) |
| **RevenueCat Purchases API** | `https://api.revenuecat.com/v1/` (`purchases_flutter` v10) | **Subscription Offerings & Entitlements**: Fetches paywall packages (`gold_pass` \$4.99/mo, `black_edition` \$9.99/mo), manages subscriber status, purchase verification, and judge evaluation tier toggles. | [`lib/services/revenuecat_service.dart`](aegis/lib/services/revenuecat_service.dart) |
| **OneSignal Push Notification Gateway** | `https://onesignal.com/api/v1/` (`onesignal_flutter` v5.7) | **Device Subscription & Push Delivery**: App ID `d9515184-c70b-438c-8d11-92905402c913`. Manages push tokens, 3-day due date radar alerts, and balance drop reward celebration pushes. | [`lib/services/onesignal_service.dart`](aegis/lib/services/onesignal_service.dart) |
| **Plaid Open Banking Engine** | Plaid `/liabilities/get` & `/accounts/balance/get` Schema | **Credit Card Balances & APRs**: Fetches statement balances, due dates, minimum payments, and detects external balance drop events for non-custodial reward minting. | [`lib/services/plaid_credit_service.dart`](aegis/lib/services/plaid_credit_service.dart) |
| **Real Estate & Market Valuation Engine** | Automated Valuation Model (AVM) / Market Feeds | **Multi-Asset Equity Tracking**: Real-time valuation for residential real estate, liquid HYSA accounts (4.4% APY), stock market index funds (VOO/VTI), and crypto cold storage for Unified Net Worth. | [`lib/services/networth_service.dart`](aegis/lib/services/networth_service.dart) |

---

## 🛠️ Architecture & Tech Stack

* **Frontend:** Flutter 3.x (Dart) with Impeller hardware acceleration & centered responsive desktop frame
* **Monetization:** RevenueCat Purchases SDK (`purchases_flutter` v10)
* **Push Notifications:** OneSignal Flutter SDK v5 (`onesignal_flutter` v5.7)
* **Automotive Intelligence:** US Government NHTSA vPIC REST API
* **State Management:** Provider pattern with reactive entitlement streams
* **Net Worth Engine:** Custom canvas curved trajectory chart & multi-asset balance sheet tracker

---

## 🚀 Getting Started

### Prerequisites
* Flutter 3.20+ / Dart 3.x
* Android Studio / Xcode

### Setup & Run
```bash
# Clone the repository
git clone https://github.com/chiraghs/Aegis.git
cd Aegis/aegis

# Install dependencies
flutter pub get

# Run on Chrome
flutter run -d chrome

# Run tests
flutter test

# Build release bundle
flutter build appbundle
```

---

## 📄 License
This project is licensed under the MIT License - see the [LICENSE](aegis/LICENSE) file for details.
