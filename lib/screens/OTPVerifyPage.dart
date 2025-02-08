import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat2/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';



class OTPVerificationScreen extends StatefulWidget {
  //final String phoneNumber;
  String verificationId;

  OTPVerificationScreen({required this.verificationId});

  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  bool isCurrentBoxEmpty = true;

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _nextField(String value, int index) {
    if (value.length == 1 && index < 5) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    } else if (value.length == 1 && index == 5) {
      FocusScope.of(context).unfocus();
    }
  }

  void _previousField(int index) {
    if (index > 0) {
      _controllers[index - 1].clear();
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          reverse: true,
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20),
              Text(
                'Verify Mobile Number',
                style: GoogleFonts.arimo(
                  textStyle: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'We sent a verification code \n Enter the code below',
                textAlign: TextAlign.center,
                style: GoogleFonts.arimo(
                  textStyle: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(height: 60),
              Image.asset(
                'assets/phone_verification.png', // Ensure you have the image asset
                height: 180,
              ),
              SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return _buildOtpBox(index);
                }),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async {
                  String cont = _controllers[0].text.toString() +
                      _controllers[1].text.toString() +
                      _controllers[2].text.toString() +
                      _controllers[3].text.toString()+
                      _controllers[4].text.toString() +
                      _controllers[5].text.toString();
                  try {
                    PhoneAuthCredential credential =
                        await PhoneAuthProvider.credential(
                            verificationId: widget.verificationId,
                            smsCode: cont);
                    FirebaseAuth.instance.signInWithCredential(credential).then((value){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen()));
                    });
                  } catch (ex) {
                    log(ex.toString() as num);
                  }
                  // Navigator.pushNamed(
                  //   context,
                  //   '/userInfo',
                  // );
                },
                child: Text(
                  'VERIFY & PROCEED',
                  style: GoogleFonts.arimo(
                    textStyle:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Didn't receive code?",
                    style: GoogleFonts.arimo(
                      textStyle: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Add your resend OTP logic here
                    },
                    child: Text(
                      "Resend code",
                      style: GoogleFonts.arimo(
                        textStyle: TextStyle(
                            fontSize: 15,
                            color: Colors.blue,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpBox(int index) {
    return SizedBox(
      width: 50,
      height: 60,
      child: RawKeyboardListener(
          focusNode: FocusNode(),
          onKey: (RawKeyEvent event) {
            if (event is RawKeyDownEvent &&
                event.logicalKey == LogicalKeyboardKey.backspace &&
                _controllers[index].text.isEmpty) {
              if (index > 0) {
                _previousField(index);
              }
            }
          },
          // child : TextFormField(
          //   controller: _controllers[index],
          //   focusNode: _focusNodes[index],
          // )
          child: TextFormField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1,
              decoration: InputDecoration(
                counterText: "",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(
                    color: Colors.blue,
                  ),
                ),
              ),
              onChanged: (value) {
                if (value.length == 1) {
                  _nextField(value, index);
                  isCurrentBoxEmpty = false;
                }
                // else if (value.isEmpty) {
                //   _previousField(value, index);
                //   isCurrentBoxEmpty = true;
                // }
              },
              onTap: () {
                _controllers[index].selection = TextSelection(
                  baseOffset: _controllers[index].text.length,
                  extentOffset: _controllers[index].text.length,
                );
              })
          // child : Text("a")
          // child: TextField(
          //   controller: _controllers[index],
          //   focusNode: _focusNodes[index],
          //   keyboardType: TextInputType.number,
          //   textAlign: TextAlign.center,
          //   maxLength: 1,
          //   decoration: InputDecoration(
          //     counterText: "",
          //     enabledBorder: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(5.0),
          //       borderSide: BorderSide(
          //         color: Colors.grey,
          //       ),
          //     ),
          //     focusedBorder: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(5.0),
          //       borderSide: BorderSide(
          //         color: Colors.blue,
          //       ),
          //     ),
          //   ),
          //   onChanged: (value) {
          //     if (value.length == 1) {
          //       _nextField(value, index);
          //       isCurrentBoxEmpty = false;
          //     }
          //   },
          //   onTap: () {
          //     _controllers[index].selection = TextSelection(
          //       baseOffset: _controllers[index].text.length,
          //       extentOffset: _controllers[index].text.length,
          //     );
          //   },
          // ),
          ),
    );
  }
}
