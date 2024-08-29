import 'package:device_preview/device_preview.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:green_market_test/components/bottom_bar.dart';
import 'package:green_market_test/components/bottom_bar.dart';
import 'package:green_market_test/screens/reset_password_screen.dart';
import 'package:green_market_test/screens/signin_screen.dart';
import 'package:green_market_test/screens/splash_screen.dart';

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
  // runApp(
  //   DevicePreview(
  //     enabled: !kReleaseMode,
  //     builder: (context) => const GreenMarket(),
  //   ),
  // );
  runApp(const GreenMarket());
}

class GreenMarket extends StatelessWidget {
  const GreenMarket({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Green Market',
      home: SplashScreen(),
    );
  }
}


// import 'package:device_preview/device_preview.dart';
// import 'package:email_otp/email_otp.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:green_market_test/screens/splash_screen.dart';

// void main() async {
//   EmailOTP.config(
//     appName: 'GreenMarket',
//     expiry: 1000 * 60 * 2,
//     otpLength: 6,
//     otpType: OTPType.numeric,
//     emailTheme: EmailTheme.v4,
//   );

//   WidgetsFlutterBinding.ensureInitialized();
//   if (kIsWeb) {
//     await Firebase.initializeApp(
//         options: const FirebaseOptions(
//             apiKey: "AIzaSyBJUNKdSZCJ7wp2Z7suoLZTleLfQxZUl7E",
//             authDomain: "green-market-4.firebaseapp.com",
//             projectId: "green-market-4",
//             storageBucket: "green-market-4.appspot.com",
//             messagingSenderId: "750742413285",
//             appId: "1:750742413285:web:bd03d8351ccfbaa515190c"));
//   } else {
//     await Firebase.initializeApp(
//         options: const FirebaseOptions(
//             apiKey: "AIzaSyBJUNKdSZCJ7wp2Z7suoLZTleLfQxZUl7E",
//             projectId: "green-market-4",
//             messagingSenderId: "750742413285",
//             appId: "1:750742413285:android:1b1ac00de1c4314415190c"));
//   }

//   runApp(const GreenMarket());
//   // runApp(
//   //   DevicePreview(
//   //     enabled: !kReleaseMode,
//   //     builder: (context) => const GreenMarket(),
//   //   ),
//   // );
// }

// class GreenMarket extends StatelessWidget {
//   const GreenMarket({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Green Market',
//       // theme: ThemeData(
//       //   colorScheme: ColorScheme.fromSeed(seedColor: kColor),
//       //   useMaterial3: true,
//       // ),
//       home: SplashScreen(),
//     );
//   }
// }


