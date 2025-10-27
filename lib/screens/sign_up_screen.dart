import 'package:flutter/material.dart';
import 'package:twitch_clone/firebase/auth_method.dart';
import 'package:twitch_clone/screens/login_screen.dart';
import 'package:twitch_clone/widgets/custom_button.dart';
import 'package:twitch_clone/widgets/custom_textfield.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = '/signup';
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  AuthMethod authMethod = AuthMethod();
  signUpUser() async {
    bool res = await authMethod.signUpUser(
      _emailController.text.trim(),
      _passwordController.text,

      _usernameController.text,
      context,
    );
    if (res) {
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.1),
              Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: CustomTextField(controller: _emailController),
              ),
              SizedBox(height: 20),
              Text('Username', style: TextStyle(fontWeight: FontWeight.bold)),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: CustomTextField(controller: _usernameController),
              ),
              SizedBox(height: 20),
              Text('Password', style: TextStyle(fontWeight: FontWeight.bold)),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: CustomTextField(controller: _passwordController),
              ),
              SizedBox(height: 20),
              CustomButton(
                onTap: () {
                  print('Email entered: ${_emailController.text}');
                  signUpUser();
                },
                text: 'Sign Up',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
