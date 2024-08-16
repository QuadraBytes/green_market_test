import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:green_market_test/components/constants.dart';
import 'package:green_market_test/screens/crop_favourites_screen.dart';
import 'package:green_market_test/screens/require_favourites_screen.dart';

late User? loggedInUser;

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  int _currentIndex = 0;
  final PageController _page = PageController();

  final List<Widget> _screens = [
    CropFavouritesScreen(),
    RequireFavouritesScreen(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _page.jumpToPage(index);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _page,
          onPageChanged: (value) {
            setState(() {
              _currentIndex = value;
            });
          },
          children: _screens,
        ),
        bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
          child: BottomAppBar(
            shadowColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            color: kColor,
            notchMargin: 0,
            elevation: 0,
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.local_florist_sharp, "Crops", 0),
                _buildNavItem(Icons.handshake_rounded, "Requirements", 1),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final size = MediaQuery.of(context).size;

    return InkWell(
      onTap: () {
        navigateToPage(index);
      },
      child: Container(
        padding: EdgeInsets.zero,
        // width: size.width * 0.18,
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: size.height * 0.03,
                    color: Colors.white,
                  ),
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.height * 0.0125,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            // SizedBox(
            //   height: 1,
            // ),
            if (index == _currentIndex)
              Container(
                height: 2,
                width: size.width * 0.15,
                color: Colors.white,
              ),
          ],
        ),
      ),
    );
  }

  void navigateToPage(int page) {
    setState(() {
      _currentIndex = page;
      _page.animateToPage(
        page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }
}
