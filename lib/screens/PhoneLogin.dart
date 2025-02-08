import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:google_fonts/google_fonts.dart';
import 'OTPVerifyPage.dart';

class PhoneLoginScreen extends StatefulWidget {
  static const  String id = 'phone_login';

  @override
  _PhoneLoginScreenState createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {

  final TextEditingController controller = TextEditingController();
  String initialCountry = 'IN';
  PhoneNumber number = PhoneNumber(isoCode: 'IN');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          reverse: true,
          padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: <Widget>[
              //     Text(
              //       'Welcome to ',
              //       style : GoogleFonts.arimo(
              //         textStyle: TextStyle(
              //           fontSize: 32,
              //           fontWeight: FontWeight.w700,
              //           color: Colors.grey
              //         ),
              //       ),
              //     ),
              //     Text(
              //       'Galen',
              //       style : GoogleFonts.abel(
              //         textStyle: TextStyle(
              //           fontSize: 40,
              //           fontWeight: FontWeight.w900,
              //
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              // SizedBox(height: 20),
              Text(
                'Continue With Phone',
                style: GoogleFonts.arimo(
                  textStyle: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                child: Text(
                  'We will send a One Time Password on this phone number.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.arimo(
                    textStyle: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                width: MediaQuery.of(context).size.width * 0.7,
              ),

              SizedBox(height: 60),
              Image.asset(
                'assets/phone_verification.png', // Ensure you have the image asset
                height: 180,
                // width : 150
              ),
              SizedBox(height: 60),
              Text(
                'Enter your phone number',
                style: GoogleFonts.arimo(
                  textStyle: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(height: 10),
              InternationalPhoneNumberInput(
                onInputChanged: (PhoneNumber number) {
                  print(number.phoneNumber);
                },
                selectorConfig: SelectorConfig(
                  selectorType: PhoneInputSelectorType.DROPDOWN,
                  trailingSpace: false,
                ),
                ignoreBlank: false,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                selectorTextStyle: TextStyle(color: Colors.black),
                initialValue: number,
                textFieldController: controller,
                formatInput: false,
                textStyle: GoogleFonts.arimo(
                  textStyle: TextStyle(
                    fontSize: 24,
                  ),
                ),
                keyboardType: TextInputType.numberWithOptions(
                    signed: true, decimal: true),
                inputDecoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: '9876504321',

                  // labelStyle:  GoogleFonts.arimo(
                  //   textStyle: TextStyle(
                  //     fontSize: 30,
                  //   ),
                  // )
                ),
              ),
              SizedBox(height: 40),
               ElevatedButton(
                onPressed: ()  {
                  String s = "+91";
                  FirebaseAuth.instance.verifyPhoneNumber(
                      verificationCompleted:
                          (PhoneAuthCredential credential) {},
                      verificationFailed: (FirebaseAuthException ex) {},
                      codeSent: (String verificationId, int? resendtoken) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => OTPVerificationScreen(verificationId: verificationId,)));
                      },
                      codeAutoRetrievalTimeout: (String verificationId) {},
                      phoneNumber: s+controller.text.toString());
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => OTPVerificationScreen(verificationId: "3",)));
                },
                child: Text(
                  'SEND OTP',
                  style: GoogleFonts.arimo(
                    textStyle:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  // primary: Color(0xff00BEBD),
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
