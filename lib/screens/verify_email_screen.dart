import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:green_market_test/components/bottom_bar.dart';
import 'package:green_market_test/components/constants.dart';
import 'package:green_market_test/screens/create_profile_screen.dart';
import 'package:green_market_test/screens/login_screen.dart';
import 'package:green_market_test/screens/reset_password_screen.dart';
import 'package:pinput/pinput.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen(
      {super.key, required this.email, required this.password});

  final String email;
  final String password;

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final _auth = FirebaseAuth.instance;
  TextEditingController otpController = TextEditingController();
  bool showSendProgress = false;
  bool showResend = false;
  late Timer timer;
  int countdown = 120;

  void startTimer() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.green,
        content: Center(child: Text("OTP has been sent to your email"))));
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (countdown > 0) {
          countdown--;
        } else {
          otpController.clear();
          timer.cancel();
        }
      });
    });
  }

  sendOtp() async {
    setState(() {
      showResend = true;
    });
    if (await EmailOTP.sendOTP(email: widget.email)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          content: Center(child: Text("OTP has been sent to your email"))));
      setState(() {
        showResend = false;
        countdown = 120;
      });
      startTimer();
    } else {
      setState(() {
        showResend = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Center(child: Text("OTP sent failed"))));
    }
  }

  verifyOtp() async {
    if (otpController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Center(
              child: Text("Enter the OTP which has been sent to your email"))));
      return;
    }

    bool verify = EmailOTP.verifyOTP(otp: otpController.text);

    setState(() {
      showSendProgress = true;
    });

    if (verify) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          content: Center(child: Text("Your email is verified successfully"))));

      await _auth.createUserWithEmailAndPassword(
        email: widget.email,
        password: widget.password,
      );
      _auth
          .signInWithEmailAndPassword(
              email: widget.email, password: widget.password)
          .then((signedUser) => {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateProfileScreen(),
                    ))
              });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Center(child: Text("Registration failed"))));
    }
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/logo.png",
                    width: MediaQuery.of(context).size.height * 0.2,
                    height: MediaQuery.of(context).size.height * 0.2,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  const Text(
                    "VERIFY EMAIL",
                    style: TextStyle(
                        fontSize: 20,
                        letterSpacing: 3,
                        fontStyle: FontStyle.normal,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                  const Text('Didn\'t receive the otp code?'),
                  const SizedBox(height: 10),
                  showResend
                      ? const CircularProgressIndicator(
                          color: kColor,
                        )
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kColor,
                            padding: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              showSendProgress = true;
                            });
                            sendOtp();
                          },
                          child: Text("Resend OTP",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                  const SizedBox(height: 20),
                  const Text(
                    'Verification Code',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 20),
                  Pinput(
                    controller: otpController,
                    length: 6,
                    defaultPinTheme: PinTheme(
                      textStyle:
                          const TextStyle(fontSize: 30, color: Colors.black),
                      width: 50,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: kColor4, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    focusedPinTheme: PinTheme(
                      textStyle:
                          const TextStyle(fontSize: 30, color: Colors.black),
                      width: 50,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                            color: const Color.fromARGB(255, 63, 145, 65),
                            width: 2.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  showSendProgress
                      ? const CircularProgressIndicator(
                          color: kColor,
                        )
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kColor,
                            padding: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            verifyOtp();
                          },
                          child: Text("Verify Email",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                  const SizedBox(height: 10),
                  Text(
                    'OTP is expired in $countdown seconds',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
