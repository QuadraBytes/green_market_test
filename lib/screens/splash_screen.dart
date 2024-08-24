import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:green_market_test/components/bottom_bar.dart';
import 'package:green_market_test/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool hasInternet = true;
  bool isSignIn = false;

  Future<void> loadModeState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isSignIn = prefs.getBool('isSignIn') ?? false;
    });
  }

  Future<void> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        hasInternet = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "No internet connection. The app will close.",
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
      Future.delayed(const Duration(seconds: 3), () {
        SystemNavigator.pop();
      });
    } else {
      setState(() {
        hasInternet = true;
      });

      if (isSignIn) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BottomBarScreen()),
          );
        });
      } else {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Login()),
          );
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    loadModeState();
    checkInternetConnection();

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                "assets/images/logo1.png",
                width: MediaQuery.of(context).size.height * 0.4,
                height: MediaQuery.of(context).size.height * 0.4,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            const Text(
              "CUSTOMER | BUYER | AI",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
