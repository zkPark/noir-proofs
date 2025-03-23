# 🅿️ zkPark: A Privacy-Preserving P2P Smart Parking Platform

## Repositories Description -
- [zkPark](https://github.com/zkPark) - zkPark Organization for all below repositories. 
- [This repo (noir-proofs)](https://github.com/zkPark/noir-proofs) - All noir proofs used in other repos are combined in  one repo.
- [zkPark-User](https://github.com/zkPark/zkPark-User) - zkPark User React Native App.
- [zkPark-Provider](https://github.com/zkPark/zkPark-Provider) - zkPark Provider React Native App.
- [raspberrypi-proofs](https://github.com/zkPark/raspberrypi-proofs) - Repo for parking meter running on raspberry pi for session logging.

## 🚗 Problem

Urban cities face growing congestion, much of it caused by drivers circling in search of parking. Studies show that up to **30% of traffic in dense areas** is due to this issue. On-street parking is often limited, expensive, and strictly enforced—leading to fines even for brief overstays. Public garages, while available, are frequently costly, inconveniently located, or full during peak times.

At the same time, **thousands of homeowners and businesses** have unused parking spaces that sit idle for most of the day. While these could offer valuable alternatives, they often go untapped due to trust issues, security concerns, and a lack of a simple system to manage bookings and payments.

## ✅ Solution

**zkPark** is a **peer-to-peer (P2P) parking platform** powered by **zero-knowledge (zk) proofs**, decentralized identity (DID), and IoT sensors. It enables:

- Drivers to find, book, and use nearby parking spots with full transparency, privacy, and trust.
- Property owners to list and monetize unused spaces while keeping their personal information secure.

The platform consists of:
1. A **Driver App** to search, book, and use parking spots.
2. An **Owner App** to verify and list parking spaces.
3. A **Raspberry Pi-based smart parking meter** to detect and record sessions.

All activity is secured and logged **on-chain** using **zk proofs**, ensuring privacy and tamper-proof records.

---

## 🔧 How It's Made

This project combines **zero-knowledge cryptography**, **decentralized storage**, **IoT hardware**, and **mobile development** to build a fully trustless, privacy-preserving smart parking platform.

### ⚙️ Core Technologies

- **Noir**: A zkDSL used to build circuits for:
  - Document & ID verification
  - zk-based user login with `noir-jwt`
  - Parking session validation
  - Time-based pricing calculation—all without revealing sensitive data.

- **React Native**: Two mobile apps:
  - **Driver App**: Find & book parking
  - **Owner App**: Verify identity & manage listings

- **0G Decentralized Storage**:
  - Stores off-chain data like user profiles, session records, zk proof metadata, and real-time heartbeat logs from parking meters.
  - Provides availability status in real time.

- **Raspberry Pi Smart Meter**:
  - Equipped with an **IR sensor** to detect vehicle presence.
  - Starts/stops sessions automatically.
  - Calculates session time and bundles data into zk proofs.

- **Solidity Smart Contracts**:
  - Deployed on **Sepolia Testnet**.
  - Verifies zk proofs for:
    - Session validation
    - Ownership claims
    - Secure logins
  - Ensures actions are verifiable on-chain without exposing private data.

---

## 🧠 Unique Implementations

- 🔒 **zk-based Login**: Using `noir-jwt`, user credentials are verified without exposure.
- 📄 **Trustless Owner Onboarding**: Lease docs and ID are verified via zk circuits.
- ⏱ **Privacy-Preserving Pricing**: A minimal Noir circuit validates session duration and cost without revealing timestamps.
- 📡 **Real-time Monitoring**: Heartbeat signals from Raspberry Pi enable live availability tracking.
- 🧾 **End-to-End zk Flow**: From booking to payment, every interaction is verifiable and secure without ever revealing raw user data.

---

## 💡 Why zkPark?

- 🧩 Combines **blockchain, zk-proofs, and IoT** into a real-world application.
- 🔐 **Privacy-first** architecture: No raw data exposure.
- 🤝 Empowers communities to share unused space and reduce congestion.
- 💸 Turns passive parking spaces into **on-chain income assets**.

