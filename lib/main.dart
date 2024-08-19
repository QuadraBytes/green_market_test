import 'package:device_preview/device_preview.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:green_market_test/components/bottom_bar.dart';
import 'package:green_market_test/components/bottom_bar.dart';
import 'package:green_market_test/screens/signin_screen.dart';
import 'package:green_market_test/screens/social_media_screen.dart';

void main() async {
  EmailOTP.config(
    appName: 'GreenMarket',
    expiry: 1000 * 60 * 2,
    otpLength: 6,
    otpType: OTPType.numeric,
    emailTheme: EmailTheme.v4,
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const GreenMarket(),
    ),
  );
}

class GreenMarket extends StatelessWidget {
  const GreenMarket({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Green Market',
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: kColor),
      //   useMaterial3: true,
      // ),
      home: SocialMedia(),
    );
  }
}
