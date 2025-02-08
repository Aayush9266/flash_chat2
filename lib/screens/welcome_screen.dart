import 'package:flash_chat2/screens/login_screen.dart';
import 'package:flash_chat2/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../widgets/rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  static const  String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{
late AnimationController controller;
late Animation animation;
late Animation animation1;
  @override
  @override

  void initState() {

    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,);
    //animation = CurvedAnimation(parent: controller, curve: Curves.decelerate);
    animation1 = ColorTween(begin: Colors.blueGrey , end: Colors.white).animate(controller);
  // controller.reverse(from: 1);
    controller.forward();
    // controller.addStatusListener((status){
    //   print(status);
    //   if(status == AnimationStatus.dismissed){
    //     controller.forward();
    //   }else if( status == AnimationStatus.completed){
    //     controller.reverse(from: 1);
    //   }
    // }
      
    // );
    controller.addListener((){
      print(controller.value);
      setState(() {

      });
    });
  }
void dispose() {
  controller.dispose();
  super.dispose();
}
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation1.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),

                DefaultTextStyle(
                  style: TextStyle(
                    fontSize:45 ,
                    color: Colors.black
                  ),
                  child: AnimatedTextKit(

                   animatedTexts: [
                     TypewriterAnimatedText( 'Flash Chat',),


                   ]

                    ),
                ),

              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(color: Colors.lightBlueAccent,title: "Log In",onPressed: (){
              Navigator.pushNamed(context, LoginScreen.id);
            },),
          RoundedButton(color: Colors.blueAccent, onPressed: (){
            Navigator.pushNamed(context, RegistrationScreen.id);
          }, title: "Register")
          ],
        ),
      ),
    );
  }


}
