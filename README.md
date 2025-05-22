# 🏋️ Workout Tracker App

A beautifully designed Flutter fitness tracker that helps users complete guided workouts with a built-in timer, tracks daily and weekly progress, and stores everything offline.

> Built as part of the **OMVAD Internship Take-Home Challenge**.

---

## 🚀 Features

- 🔐 Firebase Authentication (Login & Signup)
- 🏠 Home screen with categorized workout programs
- ⏱ Workout detail screen with auto-running timers per exercise
- 📆 Calendar view with recorded sessions per day
- 📊 Weekly statistics & most frequent workout tracker
- 🌓 Dark mode support with state persistence
- 💾 Hive local storage (offline capable)
- 🧪 Includes unit & widget test samples

---

## 📸 Screenshots

| Login | Home | Timer | Calendar | Stats |
|-------|------|-------|----------|-------|
| ![WhatsApp Image 2025-05-22 at 19 31 44_d6f19418](https://github.com/user-attachments/assets/8c6c8c6d-6313-4628-9056-f4f3cda2c586)
| *(Insert Image)* | *(Insert Image)* | *(Insert Image)* | *(Insert Image)* |

_Add screenshots above in `/screens/` folder or embed external links._

---

## 📦 Getting Started

### 🔧 Installation

```bash
git clone https://github.com/saichunchu27/flutter-workout-tracker.git
cd flutter-workout-tracker
flutter pub get
flutter run

build your own:
```bash
flutter build apk --release

| Feature           | Tech Used               |
| ----------------- | ----------------------- |
| UI Framework      | Flutter (Material 3)    |
| Auth              | Firebase Auth           |
| State Persistence | Hive, SharedPreferences |
| Calendar          | TableCalendar           |
| Voice Support     | flutter\_tts            |
| Theme Switching   | Custom ThemeProvider    |

💡 Future Additions
📤 Workout history export (CSV/JSON)
🧘 GIF/video for each exercise
🧩 Custom workout planner
📈 Graphs showing monthly trends
🌐 Sync workouts across devices



