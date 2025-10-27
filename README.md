# 🎥 Live Streaming App (Twitch Clone)

A Flutter-based live streaming app built using **Agora**, **Firebase**, and **Supabase**.  
This project lets users **go live**, **watch streams**, and **chat in real-time**.

---

## 🚀 Features

- Go Live / Watch Live Streams  
- Real-time chat using Supabase  
- Firebase Authentication  
- Live Video & Audio using Agora SDK  
- Role-based Broadcaster and Viewer modes  
- Local or Hosted Node.js backend support  

---

## 🔧 Setup Steps

### 1️⃣ **Clone the project**
```bash
git clone https://github.com/yourusername/twitch_clone.git
cd twitch_clone

````
2️⃣ **Add Agora Credentials**

Go to Agora Console

Create a new project and copy:

App ID

Temporary Token

Add them into your Flutter file:
```bash
// lib/utils/agora_config.dart
const String appId = "YOUR_AGORA_APP_ID";
const String tempToken = "YOUR_TEMP_TOKEN";
```
3️⃣ Add Firebase Configuration

Create a Firebase project from Firebase Console

Add your Flutter app (with your actual package name)

Download google-services.json and place it in:
```bash
android/app/google-services.json
```

For iOS:
```bash
ios/Runner/GoogleService-Info.plist
```

4️⃣ Add Supabase Credentials

Go to Supabase

Create a new project

Copy:

Project URL

Anon Key

Add them to your Flutter config:
```bash
// lib/utils/supabase_config.dart
const String supabaseUrl = "YOUR_SUPABASE_URL";
const String supabaseAnonKey = "YOUR_SUPABASE_KEY";
```
5️⃣ Set Your IP and Port

Find your PC’s IP address:

Windows: Run ipconfig in CMD

Mac/Linux: Run ifconfig in Terminal

Update your base URL in Flutter:
```bash
String baseUrl = "http://YOUR_IP:YOUR_PORT/";
```
6️⃣ Install Dependencies
```bash
flutter pub get
```
7️⃣ Run the App
```bash
flutter run
```

8️⃣ **Start Broadcasting** 🎬

Enter your IP and Port on the “Go Live” screen

Tap Go Live to start broadcasting

Join the same channel from another device to watch
```

```
## 📸 App Screenshots

<p align="center">
  <img src="https://github.com/user-attachments/assets/f493506d-5b9e-4363-8a60-9b0b9a859fdb" width="220" />
  <img src="https://github.com/user-attachments/assets/5298ad4f-57d6-4070-b3a4-6ac92b1c2844" width="220" />
  <img src="https://github.com/user-attachments/assets/51eb3767-3c78-4cd8-84b9-dbb7db881254" width="220" />
  <img src="https://github.com/user-attachments/assets/b4d05f00-0692-4ff5-a1fe-081bed01fe7c" width="220" />
</p>









