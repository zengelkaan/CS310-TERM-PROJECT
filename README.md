# PETCONNECT

PetConnect is a mobile application designed to connect pet owners and animal lovers through three integrated features: pet mating, adoption listings, and feeding point maps. The app creates a unified platform where users can match pets for breeding, post and discover adoption opportunities, receive reminders for vaccinations and adoption follow-ups, and locate nearby food points to support stray animals — all in one place.

## Group Members

- Fatma İrem Ulusal – 32036
- Kaan Zenğel – 31922
- Mehmet Salcan – 32312
- Necati Emir Özyeşil – 32658
- Hilal Öngel – 32425

---

## 🚀 Quick Start (Step 3)

### Prerequisites
- Flutter SDK (3.9.0+)
- Android Studio / Xcode
- Git

### Installation

```bash
# 1. Clone the repository
git clone <repository-url>
cd CS310-TERM-PROJECT-development-2

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run
```

That's it! Firebase is pre-configured.

---

## 📱 Features (Step 3)

### ✅ Firebase Authentication
- Email/Password Sign Up
- Email/Password Login
- Logout
- Password Reset
- User-friendly error messages

### ✅ Cloud Firestore Database
- **Pets Collection**: Full CRUD operations
- **Feeding Points Collection**: Full CRUD operations
- **Users Collection**: User profiles
- Real-time updates using Streams
- Security rules for data protection

### ✅ State Management (Provider)
- `AuthProvider` - Authentication state
- `PetProvider` - Pet data management
- `FeedingPointProvider` - Feeding points management
- `ThemeProvider` - Theme preferences

### ✅ Local Persistence (SharedPreferences)
- Dark/Light mode preference
- Last selected tab

---

## 🏗️ Project Structure

```
lib/
├── main.dart                    # App entry point
├── firebase_options.dart        # Firebase configuration
├── models/
│   ├── pet.dart                 # Pet model
│   ├── feeding_point.dart       # Feeding point model
│   └── vaccination.dart         # Vaccination model
├── providers/
│   ├── auth_provider.dart       # Auth state management
│   ├── pet_provider.dart        # Pet CRUD operations
│   ├── feeding_point_provider.dart
│   └── theme_provider.dart      # Theme preferences
├── screens/
│   ├── splash_screen.dart
│   ├── login_screen.dart        # Login/Signup
│   ├── auth_wrapper.dart        # Auth routing
│   ├── home_screen.dart
│   ├── profile_screen.dart      # User profile + My Pets
│   ├── available_animals_screen.dart
│   ├── add_new_pet_screen.dart
│   ├── pet_detail_screen.dart
│   ├── feeding_point_screen.dart
│   ├── add_feeding_point_screen.dart
│   └── ...
├── utils/
│   └── app_theme.dart           # Light & Dark themes
└── widgets/
    ├── custom_bottom_nav.dart
    └── map_preview.dart
```

---

## 🔥 Firebase Configuration

Firebase is already configured with:
- **Project ID**: cs310db
- **Authentication**: Email/Password enabled
- **Firestore**: Database ready

### Firestore Collections

| Collection | Fields |
|------------|--------|
| `users` | id, name, email, createdAt, updatedAt |
| `pets` | id, name, type, breed, gender, age, about, imagePath, isAvailableForAdoption, createdBy, createdAt |
| `feeding_points` | id, title, description, imageUrl, buttonText, latitude, longitude, createdBy, createdAt |

---

## 🎨 Theme Support

The app supports both Light and Dark themes:
- Toggle in Profile screen
- Preference saved using SharedPreferences
- Persists across app restarts

---

## 📝 How to Test

1. **Sign Up**: Create a new account
2. **Add Pet**: Go to Profile → Add New Pet
3. **View Pets**: Check "My Pets" in Profile (real-time updates)
4. **Adoption**: Toggle "Available for Adoption" when adding a pet
5. **Feeding Points**: Add new feeding points
6. **Theme**: Toggle dark/light mode in Profile
7. **Logout**: Test logout and re-login

---

## 🔧 Troubleshooting

### Build Issues
```bash
flutter clean
flutter pub get
flutter run
```

### iOS Issues
```bash
cd ios
pod install --repo-update
cd ..
flutter run
```

### Android Issues
```bash
cd android
./gradlew clean
cd ..
flutter run
```

---

## 📄 License

This project is for educational purposes (CS310 Term Project).
