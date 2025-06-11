# 🌍 Earthquake Tracker App

## 📖 Description

The **Earthquake Tracker App** is a real-time earthquake monitoring application built using **Flutter**. It utilizes the **USGS Earthquake API** to fetch real-time data on earthquakes happening worldwide. Users can select a specific date range to view earthquakes within that period, including details such as magnitude, location, time, and severity levels represented by different colors. The app also supports both **light mode** and **dark mode** for enhanced user experience.

## 🛠️ Tech Stack & Packages Used

- **Flutter**: Frontend framework for building the application.
- **USGS Earthquake API**: For fetching real-time earthquake data.
- **Provider**: State management solution for managing app-wide state.
- **HTTP**: For making API requests.
- **Geolocator**: For fetching user location.
- **Geocoding**: To convert latitude and longitude into readable location names.

## ✨ Features

✅ **Real-time Earthquake Data** - Fetches real-time earthquake data from USGS.

✅ **Date-based Filtering** - Users can select a start date and end date to view past earthquake data.

✅ **Detailed Earthquake Info** - Displays magnitude, time, location, and severity.

✅ **Danger Level Indication** - Uses **Red** (high risk) and **Green** (low risk) colors for severity indication.

✅ **Dark Mode Support** - Seamlessly switch between light and dark themes.

✅ **User Location Tracking** - Allows users to find earthquakes near their location.

## 🚀 How It Works

1. **Fetch Data**: The app fetches earthquake data using the **USGS API**.
2. **Filter by Date**: Users can pick a date range to filter earthquake records.
3. **Display Earthquake Details**: Shows earthquake magnitude, time, location, and severity.
4. **Severity Indication**: Earthquakes above a certain magnitude appear in **Red**; others appear in **Green**.
5. **Dark/Light Mode**: Users can toggle between dark and light themes for a better experience.

## 🔮 Future Scope

🔹 **Push Notifications**: Alerts for nearby or significant earthquakes.

🔹 **Map Integration**: Visual representation of earthquakes on a world map.

🔹 **More Filtering Options**: Sorting based on intensity, location, etc.

🔹 **Offline Mode**: Save recent earthquake data for offline access.

## 📂 Installation & Setup

1. Clone the repository:
   ```sh
   git clone https://github.com/Fenirok/Earthquake_app.git
   ```
2. Navigate to the project directory:
   ```sh
   cd Earthquake_app
   ```
3. Install dependencies:
   ```sh
   flutter pub get
   ```
4. Run the app:
   ```sh
   flutter run
   ```

## 📜 License

This project is open-source and available under the **MIT License**.

---

Made with ❤️ using Flutter.
