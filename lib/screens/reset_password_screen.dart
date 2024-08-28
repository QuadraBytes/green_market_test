import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:green_market_test/components/bottom_bar.dart';
import 'package:green_market_test/components/constants.dart';
import 'package:green_market_test/screens/forget_password.dart';
import 'package:green_market_test/screens/login_screen.dart';
import 'package:green_market_test/screens/signin_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key, required this.email});

  final String email;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool showLoading = false;
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  void resetPassword() async {
    try {
      if (passwordController.text.isEmpty || confirmController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('All fields are required'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      if (passwordController.text.length < 6) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password must be at least 6 characters'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (passwordController.text != confirmController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Passwords do not match'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      User? user = (await _auth.signInWithEmailAndPassword(
        email: widget.email,
        password: passwordController.text,
      ))
          .user;

      if (user != null) {
        await user.updatePassword(passwordController.text);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Password reset successful!'),
        ));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Login(),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${e.toString()}'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/logo.png",
                  width: MediaQuery.of(context).size.height * 0.25,
                  height: MediaQuery.of(context).size.height * 0.25,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                const Text(
                  "RESET PASSWORD",
                  style: TextStyle(
                      fontSize: 20,
                      letterSpacing: 3,
                      fontStyle: FontStyle.normal,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: Form(
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            labelText: "New Password",
                            hintText: "Enter a new password",
                            hintStyle: TextStyle(
                              color: kColor4,
                            ),
                            labelStyle: TextStyle(
                              color: kColor4,
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: kColor4)),
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: confirmController,
                          decoration: InputDecoration(
                            labelText: "Confirm New Password",
                            hintText: "Enter the new password again",
                            hintStyle: TextStyle(
                              color: kColor4,
                            ),
                            labelStyle: TextStyle(
                              color: kColor4,
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: kColor4)),
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        showLoading
                            ? CircularProgressIndicator(
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
                                  resetPassword();
                                },
                                child: Text("Save Password",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
