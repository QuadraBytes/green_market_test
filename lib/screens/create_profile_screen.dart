import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:green_market_test/components/bottom_bar.dart';
import 'package:green_market_test/components/constants.dart';
import 'package:green_market_test/models/models.dart';
import 'package:green_market_test/screens/login_screen.dart';

late User? loggedInUser;

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  TextEditingController displayNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool showLoading = false;

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() async {
    final user = await _auth.currentUser;
    if (user != null) {
      loggedInUser = user;
    }
  }

  void createProfile() async {
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
          .doc(loggedInUser!.email)
          .set({
        'displayName': displayNameController.text,
        'phoneNumber': phoneNumberController.text,
        'about': aboutController.text,
        'district': districtController.text,
        'email': loggedInUser!.email,
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const BottomBarScreen(),
        ),
      );
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/logo.png",
                width: MediaQuery.of(context).size.height * 0.25,
                height: MediaQuery.of(context).size.height * 0.25,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              const Text(
                "CREATE PROFILE",
                style: TextStyle(
                    fontSize: 20,
                    letterSpacing: 2,
                    fontStyle: FontStyle.normal,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
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
                            child: Text(type, style: TextStyle(fontSize: 16)),
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
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: createProfile,
                              child: Text("Create Profile",
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
      ),
    );
  }
}
