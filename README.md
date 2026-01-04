# PETCONNECT

PetConnect is a comprehensive mobile application that connects pet owners and animal lovers through multiple integrated features. The app provides a unified platform for pet adoption, playdates, messaging between pet owners, vaccination reminders, and feeding point maps to support stray animals.

## Group Members

- Fatma İrem Ulusal – 32036
- Kaan Zenğel – 31922
- Mehmet Salcan – 32312
- Necati Emir Özyeşil – 32658
- Hilal Öngel – 32425

## Quick Start

### Prerequisites
- Flutter SDK (3.9.2+)
- Android Studio / Xcode
- Git

### Installation

```bash
# 1. Clone the repository
git clone <repository-url>
cd CS310-TERM-PROJECT

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run
```

Firebase is pre-configured and ready to use.

## Features

### Authentication
- Email/Password Sign Up
- Email/Password Login
- Logout functionality
- Password Reset
- User-friendly error messages

### Pet Management
- Add pets with detailed information (name, type, breed, gender, age)
- View all your pets in Profile
- Mark pets as available for adoption
- Full CRUD operations on pet data
- Real-time updates using Firestore streams

### Adoption System
- Browse pets available for adoption
- View detailed pet information
- Contact pet owners through integrated messaging
- Filter and discover adoptable pets

### Playdates
- Discover other pets for playdates
- Connect with pet owners
- Message owners directly to arrange meetings
- View pet details before initiating contact

### Messaging System
- Real-time chat between users
- Chat list with last message preview
- Direct messaging from Playdates or Adoption screens
- Message history persistence in Firestore
- Delete conversations

### Vaccination Reminders
- Track vaccinations for each pet
- Add vaccination records with dates
- Mark vaccinations as completed
- Warning badges for upcoming vaccinations
- Subcollection storage per pet

### Feeding Points Map
- Add feeding points for stray animals
- View all community feeding points
- Include location, description, and images
- Help support stray animals in your area

### Theme Support
- Light and Dark theme modes
- Toggle in Profile screen
- Preference saved locally with SharedPreferences
- Persists across app restarts

## Project Structure

```
lib/
├── main.dart                           # App entry point & routing
├── firebase_options.dart               # Firebase configuration
├── models/
│   ├── pet.dart                        # Pet data model
│   ├── feeding_point.dart              # Feeding point model
│   └── vaccination.dart                # Vaccination model
├── providers/
│   ├── auth_provider.dart              # Authentication state
│   ├── pet_provider.dart               # Pet CRUD operations
│   ├── feeding_point_provider.dart     # Feeding points management
│   ├── chat_provider.dart              # Chat & messaging
│   └── theme_provider.dart             # Theme preferences
├── screens/
│   ├── splash_screen.dart              # Initial splash screen
│   ├── login_screen.dart               # Login/Signup screen
│   ├── auth_wrapper.dart               # Authentication routing
│   ├── home_screen.dart                # Main dashboard
│   ├── profile_screen.dart             # User profile & pets
│   ├── available_animals_screen.dart   # Adoption listings
│   ├── playdates_screen.dart           # Playdate matches
│   ├── chat_list_screen.dart           # All conversations
│   ├── chat_screen.dart                # Individual chat
│   ├── reminder_screen.dart            # Vaccination reminders
│   ├── add_new_pet_screen.dart         # Add pet form
│   ├── pet_detail_screen.dart          # Pet details view
│   ├── feeding_point_screen.dart       # Feeding points map
│   └── add_feeding_point_screen.dart   # Add feeding point
├── utils/
│   └── app_theme.dart                  # Light & Dark themes
└── widgets/
    ├── custom_bottom_nav.dart          # Bottom navigation bar
    └── map_preview.dart                # Map widget
```

## Firebase Configuration

Firebase is already configured with:
- **Project ID**: cs310db
- **Authentication**: Email/Password enabled
- **Firestore Database**: Real-time database ready

### Firestore Collections

| Collection | Fields | Purpose |
|------------|--------|---------|
| `users` | id, name, email, createdAt, updatedAt | User profiles |
| `pets` | id, name, type, breed, gender, age, about, imagePath, isAvailableForAdoption, createdBy, createdAt | Pet information |
| `pets/{petId}/vaccinations` | title, dateText, completed, warning, createdAt | Vaccination records (subcollection) |
| `feeding_points` | id, title, description, imageUrl, buttonText, latitude, longitude, createdBy, createdAt | Community feeding points |
| `chats` | id, participants, participantNames, lastMessage, lastMessageAt, createdAt | Chat conversations |
| `chats/{chatId}/messages` | text, senderId, senderName, createdAt | Chat messages (subcollection) |

## Dependencies

- **firebase_core** (^3.8.1): Firebase initialization
- **firebase_auth** (^5.3.4): User authentication
- **cloud_firestore** (^5.6.0): Real-time database
- **provider** (^6.1.2): State management
- **shared_preferences** (^2.3.4): Local data persistence
- **cupertino_icons** (^1.0.8): iOS-style icons

## How to Use

### Getting Started
1. Launch the app and create an account
2. Complete the signup process with email and password
3. Login to access the main dashboard

### Managing Pets
1. Navigate to Profile screen
2. Tap "Add New Pet" button
3. Fill in pet details (name, type, breed, gender, age, description)
4. Toggle "Available for Adoption" if applicable
5. Save to add the pet to your profile

### Finding Pets for Adoption
1. Go to "Adoption" from home screen
2. Browse available pets
3. Tap on a pet card to view details
4. Use "Message Owner" to start a conversation

### Arranging Playdates
1. Select "Playdates" from home screen
2. Browse pets available for playdates
3. View pet details
4. Tap "Message" to contact the owner

### Using the Chat System
1. Access "Messages" from home screen
2. View all your conversations
3. Tap a chat to open conversation
4. Send messages in real-time
5. Swipe to delete conversations

### Tracking Vaccinations
1. Navigate to "Reminders" screen
2. Each pet shows its vaccination records
3. Tap "+ Add Vaccination" for a pet
4. Enter vaccination type and date
5. Toggle warning for upcoming vaccinations
6. Mark as complete when done

### Adding Feeding Points
1. Go to "Food point" from home screen
2. Tap "Add Feeding Point"
3. Enter title, description, and location details
4. Submit to share with the community

### Changing Theme
1. Go to Profile screen
2. Toggle the theme switch
3. Theme preference is saved automatically

## Troubleshooting

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

### Common Problems

**Firebase Connection Issues**: Ensure you have a stable internet connection and Firebase is properly initialized.

**Image Loading Errors**: Pet and feeding point images are loaded from local assets. Ensure images exist in `assets/images/` directory.

**Chat Not Loading**: Check that both users exist in the Firestore `users` collection.

## License

This project is for educational purposes (CS310 Term Project).
