<div align="center">

# ☄️ Kavach <sub>by Meteor</sub>

### Your AI Financial Guardian — Scan Schemes to Detect Scams. Turn Daily Expenses into Generational Wealth.

[![Platform](https://img.shields.io/badge/platform-Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](.)
[![Language](https://img.shields.io/badge/language-Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](.)
[![AI Primary](https://img.shields.io/badge/AI-Gemini%202.5%20Flash-8E75B2?style=for-the-badge&logo=googlegemini&logoColor=white)](.)
[![AI Fallback](https://img.shields.io/badge/fallback-NVIDIA%20NIM%20(Llama%203.2%2090B)-76B900?style=for-the-badge&logo=nvidia&logoColor=white)](.)

</div>

---

> 🖼️ **[Insert Hero Banner here — dark navy (`#0A0E27`) background, teal shield icon centered, "KAVACH" wordmark in white with wide letter-spacing, "by Meteor" in gold beneath it — matches the actual in-app splash screen]**

<br>

> ### 🛡️ Why Kavach Exists
> Financial predation in India rarely looks like fraud — it looks like a professionally printed pamphlet with a logo, a "guaranteed returns" table, and an agent who's very friendly right up until the lock-in period kicks in.
> **Kavach is built to be the blunt friend who reads the fine print for you** — and then, in the same breath, tells you what to do with the money you *didn't* just lose.

---

## 📑 Table of Contents

- [Overview](#-overview)
- [Core Modules](#-core-modules)
- [Engineering Narrative — Architecture & Trade-offs](#️-engineering-narrative--architecture--trade-offs)
- [Tech Stack](#️-tech-stack)
- [Project Structure](#-project-structure)
- [Installation & Setup](#-installation--setup)
- [Security Notes](#-security-notes)
- [Roadmap](#️-roadmap)

---

## 🚀 Overview

**Kavach** ("shield" in Hindi/Sanskrit) is a Flutter-based financial protection app built for the **Zupee Hackathon**. It ships two AI-powered decision engines behind a single dark-themed, teal-and-gold interface:

| Module | One-line pitch |
|---|---|
| 🔍 **Scheme Scanner** | Photograph any investment scheme, chit fund, or insurance pamphlet — get a scam-risk verdict in seconds |
| 💰 **Wealth Engine** | Logs discretionary "leaked" spending and converts it into a ranked, real-return investment portfolio |
| 🕓 **History** | Every scan and every portfolio recommendation is persisted locally, per language, for later reference |

Both engines are backed by the same resilience pattern: a primary multimodal call to **Gemini 2.5 Flash**, with an automatic, silent fallback to **NVIDIA NIM's Llama 3.2 90B Vision** model if the primary call fails — so a single API hiccup never means a broken user experience.

> 🖼️ **[Insert Application GIF here — record the real flow: Landing screen → tap "Get Started" → Scheme Scanner tab → pick pamphlet image → tap "Analyze Scheme" → rendered Markdown verdict]**

---

## 🧩 Core Modules

### 🔍 Scheme Scanner
Users photograph or upload an investment scheme document. The image is base64-encoded and sent — alongside a tightly engineered prompt — to a vision-capable LLM, which returns a structured Markdown report:

- **🛡️ Kavach Safety Score** — a blunt `🟢 Safe / 🟡 Caution / 🔴 High Risk / ☠️ SCAM` verdict with one-sentence justification
- **🔍 The Fine Print Exposed** — lock-in period, hidden charges, and "guaranteed vs. illustrative" returns, explicitly flagged
- **💰 Real Expected Returns** — a rendered Markdown table comparing promised vs. realistic returns over a 5-year horizon
- **✅ Bottom Line** — one brutally honest sentence on whether the scheme is worth a middle-class family's money

### 💰 Wealth Engine
Rather than asking users to manually categorize a full budget, the Wealth Engine tracks small, specific **"leaks"** — Zomato, Swiggy, Netflix-style recurring discretionary spend — and asks a single question: *what could this money have become instead?*

- Simulates a UPI-linked expense feed (with manual "Add Transaction" entry as a fallback path)
- Computes total weekly "leaked" spend across tracked merchants
- Sends the leak total to the LLM with **explicit, hardcoded Indian market-rate anchors** (e.g., PPF ≈ 7.1%, Nifty 50 historical average ≈ 12%) so the model calculates compound growth against real benchmarks instead of inventing numbers
- Returns a ranked **Top 5 Portfolio** spanning government schemes, index funds, blue-chip stocks, and bonds, each with 5-year and 10-year projected value and a risk rating
- Closes with a 2-sentence, no-fluff **Action Plan** — which platform to open first, today

### 🕓 History
Every Scheme Scan and every Wealth Portfolio generation is serialized to JSON (title, content, date, and the language it was generated in) and persisted via `shared_preferences`, giving users a running, timestamped ledger of every piece of financial advice Kavach has ever given them — fully clearable on demand.

> 🖼️ **[Insert Screenshot Grid here — 3-panel layout: Scheme Scanner result card / Wealth Engine portfolio table / History list view]**

---

## 🏗️ Engineering Narrative — Architecture & Trade-offs

> 🖼️ **[Insert Architecture Diagram here — Flutter Client → (image/expense payload) → try: Gemini 2.5 Flash REST endpoint → on failure: NVIDIA NIM (Llama 3.2 90B Vision) REST endpoint → Markdown response → flutter_markdown render → shared_preferences persistence]**

Kavach's development was staged deliberately, prioritizing **clarity over completeness** at every phase:

**Phase 1 — Logic Prototyping.** The core scam-detection and portfolio-generation logic was first validated in Python + Streamlit, decoupling prompt engineering and edge-case handling from any UI commitment.

**Phase 2 — Latency Optimization.** The insight that shaped everything downstream: *latency kills usage.* A safety verdict on a scheme pamphlet is only useful if it arrives before the user's attention moves on. The app was rebuilt as a **serverless Flutter client that calls AI REST APIs directly** — no custom backend, no middleware, no extra network hop. The request path is exactly: *device → LLM provider → device.*

**Phase 3 — Resilience Without Middleware.** Going serverless removes a backend, but it also removes the place where you'd normally put retry logic. Kavach's answer is a **client-side try/catch failover**: every request first attempts Gemini 2.5 Flash; on any non-200 response or thrown exception, it transparently retries against NVIDIA NIM's Llama 3.2 90B Vision endpoint, using the same prompt and rendering the same Markdown schema regardless of which provider actually answered. The user never sees which model responded — they only see that it *did*.

<details>
<summary><strong>📐 Why this matters (click to expand)</strong></summary>

<br>

Multi-provider failover is normally justified as an enterprise SRE concern. Implementing it in a single-file hackathon MVP — with zero added infrastructure — demonstrates the same instinct at a much smaller scale: **treat the AI provider as a dependency that will occasionally fail, not a guarantee.** That's a production mindset applied under hackathon time constraints, not after them.

</details>

---

## ⚙️ Tech Stack

<div align="center">

| Layer | Technology |
|---|---|
| **Client Framework** | Flutter (Dart), single-activity architecture |
| **State Management** | Native `StatefulWidget` / `setState` |
| **Primary AI Model** | Gemini 2.5 Flash (multimodal — text + image) via direct REST |
| **Fallback AI Model** | NVIDIA NIM — `meta/llama-3.2-90b-vision-instruct` via direct REST |
| **Local Persistence** | `shared_preferences` (JSON-serialized history) |
| **Rendering** | `flutter_markdown` (renders LLM-generated tables and reports natively) |
| **Media Input** | `image_picker` (camera + gallery scheme document capture) |
| **Secrets Management** | `flutter_dotenv` (`.env` bundled as a Flutter asset, git-ignored) |
| **Localization** | Runtime prompt-level translation across 5+ Indian languages |

</div>

---

## 📁 Project Structure

```
meteor-kavach/
├── lib/
│   └── main.dart          # Full application: theming, navigation, both AI engines
├── android/ ios/ macos/    
├── linux/ windows/ web/    # Flutter multi-platform build targets
├── test/
│   └── widget_test.dart
├── pubspec.yaml            # Declares all Flutter/Dart dependencies
└── assets/.env             # GEMINI_API_KEY / NVIDIA_API_KEY (git-ignored)
```

> **Note on structure:** the entire application currently lives in a single `main.dart`. This is an intentional hackathon-stage trade-off — it kept iteration speed high while the prompt engineering and UX were still in flux. A natural next refactor (see [Roadmap](#️-roadmap)) is splitting this into `screens/`, `services/`, and `models/` once the feature set stabilizes.

---

## 💻 Installation & Setup

### Prerequisites

- [ ] **Flutter SDK** ≥ 3.11.4 installed (`flutter doctor` passes with no critical errors)
- [ ] A valid **Gemini API Key** ([Google AI Studio](https://aistudio.google.com/))
- [ ] A valid **NVIDIA NIM API Key** ([build.nvidia.com](https://build.nvidia.com/)) for fallback inference
- [ ] Android Studio / Xcode configured if targeting mobile emulators

<details>
<summary><strong>📦 Step-by-step installation (click to expand)</strong></summary>

<br>

**Step 1 — Clone the repository**

```bash
git clone https://github.com/ASbhay24/Meteor-kavach.git
cd Meteor-kavach
```

**Step 2 — Configure environment variables**

Create a `.env` file inside `assets/` (this path is required — it's the exact location `dotenv.load()` reads from in `main.dart`):

```bash
mkdir -p assets
touch assets/.env
```

Populate it:

```env
GEMINI_API_KEY=your_gemini_api_key_here
NVIDIA_API_KEY=your_nvidia_api_key_here
```

> ⚠️ **Security Warning:** `assets/.env` is bundled into the compiled app binary as a Flutter asset. This is convenient for hackathon builds but means the key ships inside the APK/IPA — **do not use this pattern for a production release build.** Confirm `assets/.env` is listed in `.gitignore` before your first commit, and rotate any key immediately if it is ever exposed in a commit, log, or screen share. For a production hardening path, see [Roadmap](#️-roadmap).

**Step 3 — Install dependencies**

```bash
flutter pub get
```

**Step 4 — Run the application**

```bash
flutter run
```

Select your target device (emulator, simulator, or connected hardware) when prompted.

</details>

---

## 🔒 Security Notes

- API keys are loaded at runtime via `flutter_dotenv` and referenced only through `dotenv.env[...]` — never hardcoded in source.
- `assets/.env` **must** remain in `.gitignore`. A committed key is a compromised key; rotate at the provider dashboard immediately if this ever happens.
- Because keys are bundled client-side, this architecture is appropriate for prototypes and hackathon demos, not for a public production release — see the Roadmap for the planned backend-proxy migration.

---

## 🗺️ Roadmap

- [ ] Extract `main.dart` into a proper `screens/ · services/ · models/` structure
- [ ] Move API calls behind a thin backend proxy to stop shipping keys inside the client binary
- [ ] Persist history to a cloud store (currently local-only via `shared_preferences`, lost on uninstall)
- [ ] Replace the simulated UPI connection with a real Account Aggregator / UPI data integration
- [ ] Add automated tests around the Gemini → NVIDIA failover path
- [ ] Expand language support beyond the current 5 Indian languages

---

<div align="center">

**Kavach demonstrates the full product lifecycle — from a sharply defined problem, through a deliberately staged architecture, to a resilient, shippable client.**

</div>
