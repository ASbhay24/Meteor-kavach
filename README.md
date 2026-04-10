# Meteor (Kavach) ☄️

**A 0→1 MVP of a real-time financial decision engine.**

## 🎯 Core Problem
Users often struggle to identify the optimal payment method or financial strategy at the moment of transaction, especially when dealing with incomplete data and time constraints. 

## 💡 Solution
Meteor is a financial shield application designed to outperform user instinct. It features a real-time **Wealth Engine** and **Scheme Scanner** that synthesizes uncertain user inputs and API data to generate clear, definitive financial recommendations (e.g., "Use Card X" or "Apply for Scheme Y"). 

## 🏗️ Architecture & Trade-offs
Built originally for the Zupee Hackathon, the development prioritized **clarity over completeness** and rapid iteration:
* **Phase 1 (Logic Prototyping):** The core decision flows and API integrations were initially prototyped using **Python and Streamlit**. This allowed for rapid testing of the logic layer and edge cases without over-architecting the UI.
* **Phase 2 (Latency Optimization):** Recognizing that "latency kills usage," the application was transitioned to a **serverless Flutter architecture**. By calling the AI APIs directly via REST and removing heavy backend middleware, response times were significantly reduced.

## ⚙️ Tech Stack
* **Frontend UI:** Flutter, Dart
* **Prototyping & Logic:** Python, Streamlit
* **AI / Data Handling:** Gemini API (REST) for real-time document analysis

## 🚀 Getting Started

### Prerequisites
* Flutter SDK installed
* A valid Gemini API Key

### Installation

**Step 1: Clone the repository**
```bash
git clone [https://github.com/ASbhay24/Meteor-Kavach.git](https://github.com/ASbhay24/Meteor-Kavach.git)

**Step 2: navigate the directory**
cd meteor-kavach

**Step 3: Set up Environment Variables**
Create a .env file in the root directory (this file is git-ignored for security) and add your API key:
GEMINI_API_KEY=your_api_key_here

**Step 4: Install Dependencies**
flutter pub get

**Step 5: Run the Application**
flutter run

This README proves you understand the entire lifecycle of a project—from the core problem all the way to deployment instructions. That is exactly what a Product Engineering Intern needs to show!
