Here’s a professional and comprehensive **README.md** for your Recipe App project:

---

# 🍽️ Recipe App

A Flutter-based Recipe Sharing App that allows users to explore, upload, like, and comment on recipes. The app supports two types of users: **Normal Users** and an **Admin**. Built using Firebase for authentication and Firestore for real-time data management.

## ✨ Features

### 👤 Normal User

* **Signup & Login** via Firebase Authentication
* **Upload Recipes** with details and images
* **View All Recipes** on the home feed
* **Like Recipes** and view liked recipes in the profile
* **Comment** on any recipe
* **Profile Page** with logout and liked recipe list

### 🛡️ Admin (Hardcoded Email/Password)

* **Login** with predefined credentials
* **View All Recipes and Comments**
* **Delete** any recipe or comment deemed inappropriate


## 🚀 Getting Started

Follow these instructions to run the app on your local machine:

### Prerequisites

* Flutter SDK installed
* An Android/iOS emulator or physical device
* Firebase account ([https://console.firebase.google.com/](https://console.firebase.google.com/))

---

### 🔧 Firebase Setup (Required)

1. **Create a Firebase Project**

   * Go to [Firebase Console](https://console.firebase.google.com/)
   * Create a new project (e.g., `RecipeApp`)

2. **Add Firebase to Your Flutter App**

   * Click on **"Add App"** and choose Flutter (iOS/Android)
   * Download the `google-services.json` file for Android and place it in:

     ```
     android/app/google-services.json
     ```

3. **Enable Firebase Services**

   * Go to **Authentication → Sign-in method** → Enable **Email/Password**
   * Go to **Firestore Database** → Create a **Cloud Firestore** instance in test mode
   * Optional: Set up **Firebase Storage** if you plan to allow image uploads

4. **Update `android/build.gradle` and `android/app/build.gradle`**
   Ensure the following settings are in place (Firebase-specific):

   ```gradle
   // android/build.gradle
   classpath 'com.google.gms:google-services:4.3.10'

   // android/app/build.gradle
   apply plugin: 'com.google.gms.google-services'
   ```

---

### 🛠️ Run Locally

1. **Clone the Repository**

   ```bash
   git clone https://github.com/your-username/recipe-app.git
   cd recipe-app
   ```

2. **Install Dependencies**

   flutter pub get

3. **Run the App**

   flutter run

## 🔐 Admin Credentials

* **Email:** `shaheer@gmail.com`
* **Password:** `shaheer`
  *(These credentials are hardcoded. Update as needed in your code.)*

---

## 📁 Folder Structure Highlights

```
lib/
├── blocs/             # BLoC state management
├── models/            # Recipe and Comment models
├── screens/           # UI screens (login, home, recipe details, profile, admin)
├── widgets/           # Reusable widgets
├── main.dart          # App entry point
```

---

## 📌 Future Improvements

* Image upload support via Firebase Storage
* Search and filter recipes
* Push notifications for new comments/likes
* Admin panel UI enhancements

---

## 🤝 Contributing

Feel free to fork this repo and submit pull requests. Suggestions, issues, and improvements are welcome!


## 📸 Screenshots
