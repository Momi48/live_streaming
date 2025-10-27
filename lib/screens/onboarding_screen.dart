import 'package:flutter/material.dart';
import 'package:twitch_clone/screens/login_screen.dart';
import 'package:twitch_clone/screens/sign_up_screen.dart';
import 'package:twitch_clone/widgets/custom_button.dart';

class OnboardingScreen extends StatelessWidget {
  static final routeName = '/onboarding';
  const OnboardingScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello'),
        centerTitle: true,
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
         
          children: [
            SizedBox(
              height: 60,
            ),
             Text(
                  'Welcome to \nFluskLive',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                  
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: CustomButton(
                    onTap: () {
                     Navigator.pushNamed(context, LoginScreen.routeName);
                    },
                    text: 'Log in',
                  ),
                ),
                CustomButton(onTap: (){
                   Navigator.pushNamed(context, SignUpScreen.routeName);
                }, text: 'Sign up')
          ],
        ),
      ),
    );
  }
}