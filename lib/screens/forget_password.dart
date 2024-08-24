import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:green_market_test/components/bottom_bar.dart';
import 'package:green_market_test/components/constants.dart';
import 'package:green_market_test/screens/login_screen.dart';
import 'package:green_market_test/screens/reset_password_screen.dart';
import 'package:pinput/pinput.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  bool showOtp = false;
  bool showSendProgress = false;
  bool showResend = false;
  late Timer timer;
  int countdown = 120;

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (countdown > 0) {
          countdown--;
        } else {
          showOtp = false;
          emailController.clear();
          otpController.clear();
          timer.cancel();
        }
      });
    });
  }

  sendOtp() async {
    if (emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Center(child: Text("Email is required"))));
      return;
    }
    if (emailController.text.contains('@') == false ||
        emailController.text.contains('.') == false) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Center(child: Text("Enter a valid email"))));
      return;
    }
    setState(() {
      showSendProgress = true;
    });

    await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: emailController.text)
        .get()
        .then((value) async {
      if (value.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.red,
            content: Center(child: Text("Email not found"))));
        setState(() {
          showSendProgress = false;
        });
        return;
      } else {
        if (await EmailOTP.sendOTP(email: emailController.text)) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.green,
              content: Center(child: Text("OTP has been sent to your email"))));
          setState(() {
            showSendProgress = false;
            showOtp = true;
            countdown = 120;
          });
          startTimer();
        } else {
          setState(() {
            showSendProgress = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.red,
              content: Center(child: Text("OTP sent failed"))));
        }
      }
    });
  }

  verifyOtp() {
    if (otpController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Center(
              child: Text("Enter the OTP which has been sent to your email"))));
      return;
    }
    bool verify = EmailOTP.verifyOTP(otp: otpController.text);
    if (verify) {
      FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          content:
              Center(child: Text("Password reset email sent to your email"))));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Center(child: Text("OTP failed"))));
    }
  }

  @override
  void dispose() {
    timer.cancel();
    emailController.dispose();
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
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "Enter your email",
                      hintStyle: TextStyle(
                        color: kColor4,
                      ),
                      labelStyle: TextStyle(
                        color: kColor4,
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: kColor4)),
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  showOtp
                      ? const Text('Didn\'t receive the otp code?')
                      : Container(),
                  showOtp ? const SizedBox(height: 10) : Container(),
                  showSendProgress
                      ? const CircularProgressIndicator(
                          color: kColor,
                        )
                      : showOtp
                          ? ElevatedButton(
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
                              onPressed: sendOtp,
                              child: Text("Send OTP",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                  const SizedBox(height: 20),
                  showOtp
                      ? const Text(
                          'Verification Code',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        )
                      : Container(),
                  showOtp ? const SizedBox(height: 20) : Container(),
                  showOtp
                      ? Pinput(
                          controller: otpController,
                          length: 6,
                          defaultPinTheme: PinTheme(
                            textStyle: const TextStyle(
                                fontSize: 30, color: Colors.black),
                            width: 50,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(color: kColor4, width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          focusedPinTheme: PinTheme(
                            textStyle: const TextStyle(
                                fontSize: 30, color: Colors.black),
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
                        )
                      : Container(),
                  showOtp ? const SizedBox(height: 20) : Container(),
                  showOtp
                      ? ElevatedButton(
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
                        )
                      : Container(),
                  showOtp ? const SizedBox(height: 10) : Container(),
                  showOtp
                      ? Text(
                          'OTP is expired in $countdown seconds',
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
