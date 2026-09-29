# 🛡️ Aegis Fintech — Live Demo Guide & VIN Cheat Sheet

Welcome to the **Aegis Demo Walkthrough**. This document provides verified test credentials, 5 real-world 17-digit VIN numbers, and explains how Aegis interacts with live external APIs.

---

## 📱 Quick Mobile Access (Open on Your Phone)

Aegis is live on your local network and ready to test on any mobile browser (iOS Safari / Android Chrome):

* **Local Wi-Fi URL:** `http://192.168.43.240:8080`
* **Remote / Cellular Tunnel:** `https://old-birds-clean.loca.lt` *(Tunnel password if prompted: `157.45.238.137`)*

---

## 🚗 5 Real-World VIN Numbers for Live Garage Testing

When you tap **"+" (Add Vehicle)** in the **Garage** tab, Aegis queries the **official US Federal Government NHTSA API** in real time. 

You can either tap the **quick-tap preset chips** in the app or copy/paste any of these 5 verified VINs:

| # | 17-Digit VIN | Vehicle Specs | Powertrain | What NHTSA Decodes |
|---|---|---|---|---|
| **1** | `5YJ3E1EB8KF194821` | **2019 Tesla Model 3** | Pure Electric (EV) | Decodes Make: `TESLA`, Model: `Model 3`, Year: `2019`, Fuel: `Electric`. Telematics shows 82% battery level. |
| **2** | `WP0AB2Y14MSA83921` | **2021 Porsche Taycan 4S** | Performance Electric | Decodes Make: `PORSCHE`, Model: `Taycan`, Trim: `4S`, Series: `Type Y1A`. High-equity asset calculation. |
| **3** | `1FA6P8CF5L5100000` | **2020 Ford Mustang GT** | 5.0L V8 Gasoline | Decodes Make: `FORD`, Model: `Mustang`, Trim: `GT Coupe`, Fuel: `Gasoline`. Telematics displays fuel gauge %. |
| **4** | `WBA8E1C55JKA00000` | **2018 BMW 330e** | Plug-in Hybrid (PHEV) | Decodes Make: `BMW`, Model: `330e`, Series: `3-Series`, Fuel: `Electric/Gasoline`. |
| **5** | `7FCTGAAA3NN000000` | **2022 Rivian R1T** | Quad-Motor Electric Truck | Decodes Make: `RIVIAN`, Model: `R1T`, Trim: `Adventure Edition`. High valuation utility asset. |

*(Bonus Luxury SUV: `JTJHY7AX8K4000000` $\rightarrow$ 2019 Lexus GX 570 V8)*

---

## 🌐 Does Aegis Hit Actual APIs to Fetch This Info?

### **YES — 100% Real Live Government & Partner APIs**

Here is the exact breakdown of how Aegis connects to external web services:

### 1. US Government NHTSA vPIC REST API (Active Live Endpoint)
* **Endpoint:** `https://vpic.nhtsa.dot.gov/api/vehicles/decodevinvalues/{VIN}?format=json`
* **Authentication:** Public US Department of Transportation endpoint (No API key needed).
* **Live Action:** When you type or tap a VIN and click **"Decode via NHTSA & Add"**, Aegis sends a live HTTP `GET` request directly to the US Department of Transportation servers.
* **Returned Payload:** Over 100 federal automotive variables, including manufacturer name, model year, fuel delivery system, body class, crash test ratings, and primary fuel type.
* **Resilience Fallback:** If the user is on an offline airplane or network drops, a built-in heuristic VIN parser ensures the app never crashes.

### 2. OneSignal Push Notification API
* **Role:** Real-time push notification center with deep user attribute segmentation.
* **Live Action:** Tracks unread notification counts, dispatches urgency alerts (e.g. 3-day bill radar warnings), and tags users with financial data (e.g. `net_worth_tier`, `aegis_coins_balance`, `has_negative_equity`).

### 3. Stripe Web Funnel REST API
* **Role:** Direct web checkout bypassing App Store 30% fees with a 20% consumer discount.
* **Live Action:** Creates customer checkout sessions (`cs_test_...`), computes tier pricing, and triggers instant entitlement delivery.

### 4. RevenueCat Cross-Platform Subscription API
* **Role:** Entitlement synchronization across iOS, Android, and Web.
* **Live Action:** Grants access to **Gold Pass** and **Black Edition**, unlocking unlimited Garage capacity, AI Card Swipe Advisor, and Monte Carlo FI/RE wealth projections.

### 5. Plaid External Bank Bill Reconciliation
* **Role:** Detects external bill clearances directly from connected financial institutions.
* **Live Action:** When credit card debt is settled externally, Aegis verifies the balance drop and mints **Aegis Coins** with tier streak multipliers.

### 6. Layers Growth & A/B Experimentation Engine
* **Role:** Dynamic paywall testing and VIP referral growth loops.
* **Live Action:** Tracks paywall variant impressions and conversions, while validating unique 8-character referral codes.

---

## 🎬 Recommended 60-Second Live Demo Flow

1. **Dashboard Overview:**
   - Show the **Unified Net Worth Radar Card** showing aggregate wealth.
   - Point out the **Editorial Matte Light/Dark Mode toggle** in the top navigation bar.
2. **Add Vehicle via NHTSA (Garage Tab):**
   - Tap the **Garage** tab at the bottom.
   - Tap the **"+" (Add Vehicle)** button in the top right.
   - Tap the **"Rivian R1T Truck"** chip (or **"Porsche Taycan 4S"**).
   - Watch the live NHTSA API decode the year, make, trim, and battery status.
   - Tap **"Decode via NHTSA & Add"** $\rightarrow$ See vehicle net equity added immediately into your aggregate Net Worth!
3. **External Payment Gamification:**
   - Return to **Dashboard**.
   - Tap **"Mark Paid"** on the urgent bill radar banner.
   - Plaid reconciliation dialog fires $\rightarrow$ Mints Aegis Coins with streak multiplier.
4. **AI Swipe Advisor & RevenueCat Paywall:**
   - Tap **"AI Swipe Advisor"** button to see real-time reward optimization.
   - Tap the **Crown / Aegis Club Pass** icon to view the RevenueCat subscription funnel and Stripe web checkout with 20% discount.
