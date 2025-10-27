import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:twitch_clone/firebase/auth_method.dart';
import 'package:twitch_clone/provider/user_provider.dart';
import 'package:twitch_clone/screens/home_screen.dart';
import 'package:twitch_clone/screens/login_screen.dart';
import 'package:twitch_clone/screens/onboarding_screen.dart';
import 'package:twitch_clone/screens/sign_up_screen.dart';
import 'package:twitch_clone/utils/colors.dart';
import 'package:twitch_clone/utils/global_variables.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyBLUNS-G_sQILTNKlz1TTko9xi2DAum_rg",
        authDomain: "twitch-fc515.firebaseapp.com",
        projectId: "twitch-fc515",
        storageBucket: "twitch-fc515.firebasestorage.app",
        messagingSenderId: "958764320171",
        appId: "1:958764320171:web:f7b8c7b8adf7a17591feee",
        measurementId: "G-3EQ0DBKMWK",
      ),
    );
  }
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => UserProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: AppBarTheme.of(context).copyWith(
          backgroundColor: backgroundColor,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          elevation: 0,
        ),

        iconTheme: IconThemeData(color: primaryColor),
      ),
      routes: {
        OnboardingScreen.routeName: (context) => OnboardingScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
        SignUpScreen.routeName: (context) => SignUpScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
      },
      debugShowCheckedModeBanner: false,

      home: FutureBuilder(
        future: AuthMethod().getCurrentUser(context),

        builder: (context, snaphot) {
          if (snaphot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (snaphot.hasData) {
            print('Snaps  ${snaphot.hasData}');
            return HomeScreen();
          }
          print('Snapshot is ${snaphot.hasData}');
          return OnboardingScreen();
        },
      ),
    );
  }
}
