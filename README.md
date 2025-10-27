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

### 1️⃣ Clone the project
```bash
git clone https://github.com/yourusername/twitch_clone.git
cd twitch_clone

````
**Add Agora credentials**

Go to Agora Console

Create a new project and copy:

App ID

Temporary Token

Add them to:
```bash
// lib/utils/agora_config.dart
const String appId = "YOUR_AGORA_APP_ID";
const String tempToken = "YOUR_TEMP_TOKEN";
```
**Add Firebase configuration**

Create a Firebase project

Add your Flutter app (use your package name)

Download google-services.json → put it in:
```bash
android/app/google-services.json
```

For iOS:
```bash
ios/Runner/GoogleService-Info.plist
```

**Add Supabase credentials**

Go to Supabase

Create a new project

Copy:

Project URL

Anon Key

Add them to:
```bash
// lib/utils/supabase_config.dart
const String supabaseUrl = "YOUR_SUPABASE_URL";
const String supabaseAnonKey = "YOUR_SUPABASE_KEY";
```
**Set your IP and Port**

Find your PC’s IP using ipconfig (Windows) or ifconfig (Mac/Linux).
Update your base URL in Flutter:
```bash
String baseUrl = "http://YOUR_IP:YOUR_PORT/";
```
Install dependencies
```bash
flutter pub get
```
Run the app
```bash
flutter run
```

**Start Broadcasting ** 🎬

Enter your IP and Port on the “Go Live” screen

Tap Go Live to start broadcasting

Join the same channel from another device to watch
```
