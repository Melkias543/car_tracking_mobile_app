# 🚌 TransitTrack — Public Transport Tracker

A Flutter mobile application that provides real-time public transport tracking for Addis Ababa, Ethiopia. Users can view live bus and train arrivals, filter by status, save favorite routes, and see their current GPS location — all in a clean, dark-themed UI.

---

## 📱 Screenshots

> Run the app on a real Android device to see the full experience.

---

## ✨ Features

| Feature             | Description                                                                         |
| ------------------- | ----------------------------------------------------------------------------------- |
| Live Arrivals       | Fetches real-time bus and train data from a public API                              |
| Status Filtering    | Filter routes by On Time, Delayed, or Cancelled                                     |
| Favorites           | Save and manage favorite routes, persisted across sessions                          |
| Route Detail        | View full route info including origin, destination, arrival time, and stop timeline |
| Station Search      | Search all stations dynamically from live API data                                  |
| GPS Location        | Displays the user's current coordinates using device GPS                            |
| Permission Handling | Properly requests and handles location permission responses                         |
| Error Handling      | Shows error messages when API or location fails                                     |
| Loading Indicators  | CircularProgressIndicator shown during all async operations                         |

---

## 🏗️ Project Structure

```
lib/
├── main.dart                          # App entry point, theme setup
├── models/
│   └── transport.dart                 # Transport data model (fromJson, toJson)
├── services/
│   ├── transport_service.dart         # API fetching + SharedPreferences storage
│   └── location_service.dart          # Geolocator permission + GPS logic
├── screens/
│   ├── home_screen.dart               # Home screen (state + layout)
│   ├── live_list_screen.dart          # Live arrivals list with filter support
│   ├── detail_screen.dart             # Route detail + favorite toggle
│   └── favorites_screen.dart          # Saved favorites from SharedPreferences
└── widgets/
    ├── location_card.dart             # GPS location display card
    ├── station_search_bar.dart        # Search input with live dropdown
    ├── station_card.dart              # Horizontal scroll station card
    ├── action_buttons.dart            # ActionButton + StatusButton widgets
    ├── nearby_stations_section.dart   # Nearby stations horizontal list
    ├── quick_actions_section.dart     # Live Arrivals + Favorites buttons
    └── status_filter_section.dart     # On Time / Delayed / Cancelled filter row
```

---

## 🖥️ Screens

### 1. Home Screen

- Displays the user's current GPS coordinates
- Search bar that searches real station names fetched from the API
- Horizontal scrollable list of all unique stations (origins + destinations)
- Quick Action buttons: Live Arrivals and Favorites
- Status Filter buttons: On Time, Delayed, Cancelled

### 2. Live Arrivals Screen

- Fetches all routes from the API on load
- Shows a loading spinner while fetching
- Displays each route with name, origin → destination, arrival time, and status badge
- Each tile has a star button to toggle favorites inline
- Supports optional status filter passed from the Home screen
- Refresh button to re-fetch data

### 3. Detail Screen

- Receives a full `Transport` object from the previous screen
- Shows all route fields: name, destination, origin, arrival time, status, type
- Displays a visual stop timeline
- Star button in the appbar toggles favorite with Snackbar confirmation

### 4. Favorites Screen

- Reads saved routes from SharedPreferences
- Shows name, origin → destination, and arrival time per item
- Tapping a favorite navigates to its Detail Screen
- Delete button removes the route from storage and refreshes the list instantly

---

## 🔌 API

- **Endpoint:** `https://api.npoint.io/0240de8bc22e678b690e`
- **Method:** GET
- **Response:** JSON array of transport objects

### Sample Response

```json
[
  {
    "id": "anb-01",
    "name": "Anbessa 01",
    "type": "bus",
    "origin": "Bole",
    "status": "On Time",
    "arrivalTime": "10:15 AM",
    "destination": "Piazza"
  },
  {
    "id": "aart-01",
    "name": "LRT Blue Line",
    "type": "train",
    "origin": "Menelik II Square",
    "status": "On Time",
    "arrivalTime": "10:20 AM",
    "destination": "Kality"
  }
]
```

---

## 💾 Data Persistence

Uses `shared_preferences` to store favorites locally on the device.

- Each favorite is serialized to a JSON string using `Transport.toJsonString()`
- Stored as a `List<String>` under the key `'favs'`
- On read, each string is deserialized back to a `Transport` object using `Transport.fromJsonString()`
- Duplicate prevention: checks `id` before saving

---

## 📍 Device Feature — Location (Geolocator)

Uses the `geolocator` plugin to access the device GPS.

Permission flow:

1. Check if location services are enabled on the device
2. Check current permission status
3. If denied, request permission from the user (shows system dialog)
4. If permanently denied, show a Snackbar with instructions
5. If granted, fetch current position and display coordinates

Permissions declared in `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.INTERNET"/>
```

---

## 🛠️ Tech Stack

| Technology                  | Purpose                               |
| --------------------------- | ------------------------------------- |
| Flutter                     | UI framework                          |
| Dart                        | Programming language                  |
| `http` ^1.2.0               | HTTP requests to the API              |
| `shared_preferences` ^2.2.3 | Local key-value storage for favorites |
| `geolocator` ^12.0.0        | Device GPS and location permissions   |

---

## 🚀 How to Run

### Prerequisites

- Flutter SDK installed (`flutter --version` to verify)
- Android device or emulator connected
- Internet connection

### Steps

```bash
# 1. Clone the repository
git clone https://github.com/Melkias543/car_tracking_mobile_app/
cd car_tracking_app

# 2. Install dependencies
flutter pub get

# 3. Run on connected Android device
flutter run

# 4. Build release APK
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

---

## 📋 Requirements Coverage

| Requirement                  | Status | Implementation                                                                      |
| ---------------------------- | ------ | ----------------------------------------------------------------------------------- |
| Flutter framework            | ✅     | Entire app built in Flutter/Dart                                                    |
| 3–5 Screens                  | ✅     | 4 screens: Home, LiveList, Detail, Favorites                                        |
| Stateless widgets            | ✅     | `LocationCard`, `StationCard`, `_InfoCard`, `_StopTile`, etc.                       |
| Stateful widgets             | ✅     | `HomeScreen`, `LiveListScreen`, `_TransportTile`, `DetailScreen`, `FavoritesScreen` |
| Layout structure             | ✅     | Row, Column, ListView, Stack, Expanded, SingleChildScrollView                       |
| Form / input field           | ✅     | `StationSearchBar` with live filtering                                              |
| Snackbar feedback            | ✅     | On favorite save, remove, and location permission denial                            |
| Navigation push/pop          | ✅     | Between all 4 screens using `Navigator.push`                                        |
| Data passed between screens  | ✅     | `Transport` object passed to `DetailScreen`                                         |
| setState()                   | ✅     | Used in every stateful widget                                                       |
| Data persistence             | ✅     | SharedPreferences stores full Transport JSON                                        |
| Stored data used in app      | ✅     | Favorites screen reads and displays stored data                                     |
| API fetch                    | ✅     | `http.get()` to `api.npoint.io`                                                     |
| JSON parsing                 | ✅     | `Transport.fromJson()` maps API response                                            |
| Loading indicator            | ✅     | `CircularProgressIndicator` in LiveList and Home                                    |
| Error handling               | ✅     | `snapshot.hasError` displays error message                                          |
| Flutter plugin               | ✅     | `geolocator` ^12.0.0                                                                |
| Device feature               | ✅     | GPS location via `Geolocator.getCurrentPosition()`                                  |
| Permission request           | ✅     | `Geolocator.requestPermission()`                                                    |
| Permission response handling | ✅     | Handles denied, deniedForever, and granted states                                   |

---

## 👥 Group Members

Ashenaf Feleke..................................................................0168/15
Melkiyas Teshoma ...............................................................0719/15
Andualem Argo...................................................................0149/15
Natnael Abebaw….................................................................0840/15
Sifan Geremu .................................................................. 0941/15

> Fill in your names and IDs above before submission.

---

## 📄 License

This project was developed as a university course assignment.
