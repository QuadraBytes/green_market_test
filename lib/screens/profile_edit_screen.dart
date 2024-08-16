import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:green_market_test/components/bottom_bar.dart';
import 'package:green_market_test/components/constants.dart';
import 'package:green_market_test/models/models.dart';
import 'package:green_market_test/screens/login_screen.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';

late User? loggedInUser;

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _auth = FirebaseAuth.instance;
  String? displayName;
  String? about;
  String? phoneNumber;
  String? district;
  bool showLoading = false;
  TextEditingController displayNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  List crops = [];
  List requirements = [];

  Future<void> getUserData() async {
    loggedInUser = _auth.currentUser!;
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(loggedInUser?.email)
        .get();

    setState(() {
      displayName = userSnapshot['displayName'];
      about = userSnapshot['about'];
      phoneNumber = userSnapshot['phoneNumber'];
      district = userSnapshot['district'];

      displayNameController.text = displayName!;
      aboutController.text = about!;
      phoneNumberController.text = phoneNumber!;
      districtController.text = district!;
    });
  }

  void editProfile() async {
    try {
      if (displayNameController.text.isEmpty ||
          phoneNumberController.text.isEmpty ||
          districtController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('All fields are required'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (phoneNumberController.text.length != 9) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid phone number'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        showLoading = true;
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(loggedInUser?.email)
          .update({
        'displayName': displayNameController.text,
        'about': aboutController.text,
        'phoneNumber': phoneNumberController.text,
        'district': districtController.text,
      });

      var cropDocs = await FirebaseFirestore.instance
          .collection('crops')
          .where('userId', isEqualTo: loggedInUser?.email)
          .get();
      for (var element in cropDocs.docs) {
        await FirebaseFirestore.instance
            .collection('crops')
            .doc(element.id)
            .update({
          'farmerName': displayNameController.text,
        });
      }

      var requirementDocs = await FirebaseFirestore.instance
          .collection('requirements')
          .where('userId', isEqualTo: loggedInUser?.email)
          .get();
      for (var element in requirementDocs.docs) {
        await FirebaseFirestore.instance
            .collection('requirements')
            .doc(element.id)
            .update({
          'buyerName': displayNameController.text,
        });
      }

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => BottomBarScreen()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
                top: -50, child: Image.asset('assets/images/appbar2.png')),
            Positioned(
                top: 20,
                left: 10,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BottomBarScreen()));
                  },
                )),
            Positioned(
              top: 25,
              left: size.width * 0.33,
              right: size.width * 0.3,
              child: Text('Edit Profile',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)),
            ),
            displayName == null
                ? Center(
                    child: CircularProgressIndicator(
                      color: kColor,
                    ),
                  )
                : Positioned(
                    top: 100,
                    left: 0,
                    right: 0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/profile.png',
                          height: size.height * 0.1,
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          child: Form(
                            child: Column(
                              children: [
                                TextField(
                                  controller: displayNameController,
                                  decoration: InputDecoration(
                                    labelText: "Display Name",
                                    hintText: "Enter your dispaly name",
                                    prefixIcon: Icon(Icons.person),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                TextFormField(
                                  controller: aboutController,
                                  decoration: InputDecoration(
                                    labelText: "About",
                                    hintText: "Enter your about",
                                    prefixIcon: Icon(Icons.edit_calendar_sharp),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                DropdownButtonFormField<String>(
                                  menuMaxHeight: 250,
                                  decoration: InputDecoration(
                                    labelText: "District",
                                    hintText: "Select your district",
                                    prefixIcon: Icon(Icons.location_on),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  icon: Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Icon(
                                      Icons.keyboard_arrow_down_outlined,
                                      size: 25,
                                    ),
                                  ),
                                  items: districts.map((String type) {
                                    return DropdownMenuItem<String>(
                                      value: type,
                                      child: Text(type,
                                          style: TextStyle(fontSize: 16)),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      districtController.text = value!;
                                    });
                                  },
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextField(
                                  enableSuggestions: false,
                                  controller: phoneNumberController,
                                  maxLength: 9,
                                  decoration: InputDecoration(
                                    labelText: "Phone Number",
                                    hintText: "+94 7X XXX XXXX",
                                    prefixIcon: Icon(Icons.phone),
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
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        onPressed: editProfile,
                                        child: Text("Save Profile",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
