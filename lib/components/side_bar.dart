import 'package:flutter/material.dart';
import 'package:green_market_test/components/bottom_bar.dart';
import 'package:green_market_test/screens/availability_screen.dart';
import 'package:green_market_test/screens/how_it_works_screen.dart';
import 'package:green_market_test/screens/social_media_screen.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Drawer(
      width: size.width * 0.6,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: ClipOval(
              child: Image.asset(
                "assets/images/logo.png",
                fit: BoxFit.contain,
                width: size.width * 0.4,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BottomBarScreen()), (route) => true);
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Social Media'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SocialMedia()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('How It Works'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HowItWorks()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.local_shipping_sharp),
            title: const Text('Available Supply'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AvailabilityScreen()));
            },
          ),
        ],
      ),
    );
  }
}


