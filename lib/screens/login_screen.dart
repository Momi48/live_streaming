import 'package:flutter/material.dart';
import 'package:twitch_clone/firebase/auth_method.dart';
import 'package:twitch_clone/screens/home_screen.dart';
import 'package:twitch_clone/widgets/custom_button.dart';
import 'package:twitch_clone/widgets/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  AuthMethod authMethod = AuthMethod();
  logInUser()async{
bool res = await  authMethod.logInUser(email: _emailController.text, password: _passwordController.text, context: context);
  
   if(res) {
    Navigator.pushReplacementNamed(context, HomeScreen.routeName);
   }
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text('Login',), centerTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.1),
              Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
              Padding(
                padding:  EdgeInsets.symmetric(vertical: 8.0),
                child: CustomTextField(controller: _emailController),
              ),
              SizedBox(height: 20),
              Text('Password', style: TextStyle(fontWeight: FontWeight.bold)),
              Padding(
                padding:  EdgeInsets.symmetric(vertical: 8.0),
                child: CustomTextField(controller: _passwordController),
              ),
               SizedBox(height: 20),
              CustomButton(onTap: () {
                logInUser();
              }, text: 'Log In'),
            ],
          ),
        ),
      ),
    );
  }
}
