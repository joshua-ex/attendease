# AttendEase

A Flutter-based attendance management application that enables seamless tracking of attendance with modern UI, secure authentication, and cloud integration.

---

##  Key Highlights

- **Cross-platform Flutter app** supporting both Android and iOS.
- **Real-time attendance attendance tracking** using biometric or QR-based methods.
- **Firebase integration** for backend operations, including authentication, database, and notifications.
- **Admin & User roles** allowing differentiated access and dashboards.
- **Clean and modular architecture**, making it scalable and easy to extend.

---

##  Getting Started

### Prerequisites

- Install Flutter SDK (v3.0+ recommended).
- Set up Android Studio or Xcode for platform-specific build tools.
- A working [Firebase project](https://console.firebase.google.com) configured with:
  - Firebase Authentication (Email/Google)
  - Firestore Database (or Realtime DB)
  - Cloud Firestore or Cloud Messaging (for notifications)

### Installation Steps

1. Clone the repository:
    ```bash
    git clone https://github.com/joshua-ex/attendease.git
    cd attendease
    ```

2. Install dependencies:
    ```bash
    flutter pub get
    ```

3. Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) files into the respective folders.

4. Run the app:
    ```bash
    flutter run
    ```

---

##  Features

- **User Management**: Secure login/signup using Firebase Auth.
- **Role-based Access**:
  - **Admin Dashboard**: View attendance records, generate reports, manage users.
  - **User Dashboard**: Mark attendance, view history, and receive notifications.
- **Real-time Data Sync**: Instant updates via Firestore or Realtime Database.
- **Notifications**: (Optional) Alerts when marking attendance or for announcements.
- **Modular UI Components**: Reusable widgets for buttons, forms, and cards.

---


