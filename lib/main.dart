import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat2/screens/PhoneLogin.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat2/screens/welcome_screen.dart';
import 'package:flash_chat2/screens/login_screen.dart';
import 'package:flash_chat2/screens/registration_screen.dart';
import 'package:flash_chat2/screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute: WelcomeScreen.id,
      routes: {
        PhoneLoginScreen.id : (context) => PhoneLoginScreen(),
        WelcomeScreen.id : (context) => WelcomeScreen(),
        LoginScreen.id : (context) => LoginScreen(),
        RegistrationScreen.id : (context) => RegistrationScreen(),
        ChatScreen.id : (context) => ChatScreen(),

      },
    );
  }
}
