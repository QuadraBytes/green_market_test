import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:green_market_test/components/bottom_bar.dart';
import 'package:green_market_test/components/constants.dart';
import 'package:green_market_test/screens/login_screen.dart';
import 'package:green_market_test/screens/profile_edit_screen.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';

late User? loggedInUser;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;
  String? displayName;
  String? about;
  String? phoneNumber;
  String? district;
  // List<String> crops = ["vrevw", 'rvrev', 'ewqdew'];
  List crops = [];
  List requirements = [];

  void saveModeState(bool isSignIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSignIn', isSignIn);
  }

  Future<void> getUserData() async {
    loggedInUser = _auth.currentUser!;
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(loggedInUser?.email)
        .get();

    var cropList = await FirebaseFirestore.instance.collection('crops').get();
    var requirementList =
        await FirebaseFirestore.instance.collection('requirements').get();

    for (var crop in cropList.docs) {
      if (crop['userId'] == loggedInUser?.uid && crop['isDeleted'] == false) {
        crops.add(crop);
      }
    }

    for (var requirement in requirementList.docs) {
      if (requirement['userId'] == loggedInUser?.uid &&
          requirement['isDeleted'] == false) {
        requirements.add(requirement);
      }
    }

    setState(() {
      displayName = userSnapshot['displayName'].toString();
      about = userSnapshot['about'].toString();
      phoneNumber = userSnapshot['phoneNumber'].toString();
      district = userSnapshot['district'].toString();
    });
  }

  void logout() async {
    await _auth.signOut();
    saveModeState(false);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
  }

  clickRetain(String id, bool isCrop) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: isCrop ? Text('Retain Crop') : Text('Retain Requirement'),
        content: isCrop
            ? Text(
                'Do you want to retain this crop for another 3 days from today onwards?')
            : Text(
                'Do you want to retain this requirement for another 3 days from today onwards?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              reatain(id, isCrop);
            },
            child: Text('Accept'),
          ),
        ],
      ),
    );
  }

  reatain(String id, bool isCrop) async {
    try {
      DateTime newExpiringDate = DateTime.now().add(Duration(days: 3));

      if (isCrop) {
        await FirebaseFirestore.instance
            .collection('crops')
            .doc(id)
            .update({'isExpired': false, 'expiringDate': newExpiringDate});
        setState(() {
          crops = [];
          requirements = [];
        });
        await getUserData();

        Navigator.pop(context);
      } else {
        await FirebaseFirestore.instance
            .collection('requirements')
            .doc(id)
            .update({'isExpired': false, 'requiredDate': newExpiringDate});
        setState(() {
          crops = [];
          requirements = [];
        });
        await getUserData();

        Navigator.pop(context);
      }
    } catch (e) {
      print(e);
    }
  }

  clickAccept(String id, bool isCrop) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: isCrop ? Text('Accept Crop') : Text('Accept Requirement'),
        content: isCrop
            ? Text('Are you sure you want to mark this crop as accepted?')
            : Text(
                'Are you sure you want to mark this requirement as accepted?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              accept(id, isCrop);
            },
            child: Text('Accept'),
          ),
        ],
      ),
    );
  }

  accept(String id, bool isCrop) async {
    try {
      if (isCrop) {
        await FirebaseFirestore.instance
            .collection('crops')
            .doc(id)
            .update({'isAccepted': true});
        setState(() {
          crops = [];
          requirements = [];
        });
        await getUserData();

        Navigator.pop(context);
      } else {
        await FirebaseFirestore.instance
            .collection('requirements')
            .doc(id)
            .update({'isAccepted': true});
        setState(() {
          crops = [];
          requirements = [];
        });
        await getUserData();

        Navigator.pop(context);
      }
    } catch (e) {
      print(e);
    }
  }

  clickDelete(String id, bool isCrop) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: isCrop ? Text('Delete Crop') : Text('Delete Requirement'),
        content: isCrop
            ? Text('Are you sure you want to delete this crop?')
            : Text('Are you sure you want to delete this requirement?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              delete(id, isCrop);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  delete(String id, bool isCrop) async {
    try {
      if (isCrop) {
        await FirebaseFirestore.instance
            .collection('crops')
            .doc(id)
            .update({'isDeleted': true});
        setState(() {
          crops = [];
          requirements = [];
        });
        await getUserData();
        Navigator.pop(context);
      } else {
        await FirebaseFirestore.instance
            .collection('requirements')
            .doc(id)
            .update({'isDeleted': true});
        setState(() {
          crops = [];
          requirements = [];
        });
        await getUserData();
        Navigator.pop(context);
      }
    } catch (e) {
      print(e);
    }
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  void showCropDetails(var data) {
    Timestamp availableDateTimestamp = data['availableDate'];
    Timestamp expireDateTimestamp = data['expiringDate'];

    String availableDate = _formatTimestamp(availableDateTimestamp);
    String expiredDate = _formatTimestamp(expireDateTimestamp);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        final size = MediaQuery.of(context).size;
        return Container(
          height: size.height * 0.45,
          child: Stack(children: [
            Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          data['cropType'],
                          style: TextStyle(
                            fontSize: size.height * 0.03,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: size.width * 0.9,
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 20,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              data['district'],
                              style: TextStyle(
                                  color: kColor4,
                                  fontSize: size.height * 0.02,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            'Weight :',
                            style: TextStyle(
                                color: kColor4,
                                fontSize: size.height * 0.02,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            '${data['weight']} kg',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: size.height * 0.02,
                                color: Color(0xFF222325)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            'Price :',
                            style: TextStyle(
                                color: kColor4,
                                fontSize: size.height * 0.02,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Rs. ${data['price']}',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: size.height * 0.02,
                                color: Color(0xFF222325)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            'Available Date :',
                            style: TextStyle(
                                color: kColor4,
                                fontSize: size.height * 0.02,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            availableDate,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: size.height * 0.02,
                                color: Color(0xFF222325)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            'Expired Date :',
                            style: TextStyle(
                                color: kColor4,
                                fontSize: size.height * 0.02,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            expiredDate,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: size.height * 0.02,
                                color: Color(0xFF222325)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          data['isAccepted']
                              ? Container()
                              : data['isExpired']
                                  ? Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          clickRetain(data.id, true);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 5),
                                          child: Text(
                                            'Retain',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                        ),
                                      ),
                                    )
                                  : Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          clickAccept(data.id, true);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 5),
                                          child: Text(
                                            'Accepted',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.amber[700],
                                        ),
                                      ),
                                    ),
                          data['isAccepted']
                              ? Container()
                              : SizedBox(
                                  width: 20,
                                ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: data['isAccepted'] ? 40 : 0,
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  clickDelete(data.id, true);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
                right: 15,
                top: 15,
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      size: 30,
                      Icons.close,
                      color: Colors.black,
                    ))),
            Positioned(
              left: 20,
              top: 20,
              child: Text(
                data['isAccepted']
                    ? 'Accepted'
                    : data['isExpired']
                        ? 'Expired'
                        : 'Available',
                style: TextStyle(
                  color: data['isAccepted']
                      ? Colors.amber[700]
                      : data['isExpired']
                          ? Colors.red
                          : const Color.fromARGB(255, 70, 170, 74),
                  fontSize: size.height * 0.02,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ]),
        );
      },
    );
  }

  void showRequireDetails(var data) {
    Timestamp requiredDateTimestamp = data['requiredDate'];

    String requiredDate = _formatTimestamp(requiredDateTimestamp);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        final size = MediaQuery.of(context).size;
        return Container(
          height: size.height * 0.4,
          child: Stack(children: [
            Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          data['cropType'],
                          style: TextStyle(
                            fontSize: size.height * 0.03,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: size.width * 0.9,
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 20,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              data['district'],
                              style: TextStyle(
                                  color: kColor4,
                                  fontSize: size.height * 0.02,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            'Required Weight :',
                            style: TextStyle(
                                color: kColor4,
                                fontSize: size.height * 0.02,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            '${data['weight']} kg',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: size.height * 0.02,
                                color: Color(0xFF222325)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            'Required Date :',
                            style: TextStyle(
                                color: kColor4,
                                fontSize: size.height * 0.02,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            requiredDate,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: size.height * 0.02,
                                color: Color(0xFF222325)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          data['isAccepted']
                              ? Container()
                              : data['isExpired']
                                  ? Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          clickRetain(data.id, true);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 5),
                                          child: Text(
                                            'Retain',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                        ),
                                      ),
                                    )
                                  : Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          clickAccept(data.id, false);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 5),
                                          child: Text(
                                            'Accept',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.amber[700],
                                        ),
                                      ),
                                    ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                clickDelete(data.id, false);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                child: Text(
                                  'Delete',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
                right: 15,
                top: 15,
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      size: 30,
                      Icons.close,
                      color: Colors.black,
                    ))),
            Positioned(
              left: 20,
              top: 20,
              child: Text(
                data['isAccepted']
                    ? 'Accepted'
                    : data['isExpired']
                        ? 'Expired'
                        : 'Available',
                style: TextStyle(
                  color: data['isAccepted']
                      ? Colors.amber[700]
                      : data['isExpired']
                          ? Colors.red
                          : const Color.fromARGB(255, 70, 170, 74),
                  fontSize: size.height * 0.02,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ]),
        );
      },
    );
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
                top: 15,
                left: 10,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(
                        context);
                  },
                )),
            Positioned(
              top: 25,
              left: size.width * 0.4,
              right: size.width * 0.4,
              child: Text('Profile',
                  style: TextStyle(
                      fontSize: size.height * 0.03,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)),
            ),
            displayName == null
                ? Center(
                    child: CircularProgressIndicator(
                      color: kColor,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/profile.png',
                            height: size.height * 0.1,
                          ),
                          SizedBox(height: 10),
                          Text(
                            displayName ?? 'Name',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.location_on, color: Colors.red),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                district ?? 'District',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: kColor3,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.phone, color: Colors.red),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                phoneNumber ?? 'Phone Number',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: kColor3,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 30),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     Text(
                          //       "Farmer mode",
                          //       style: TextStyle(
                          //         fontSize: size.height * 0.0175,
                          //         fontWeight: FontWeight.bold,
                          //         color: Colors.black,
                          //       ),
                          //     ),
                          //     SizedBox(width: 5),
                          //     Switch(
                          //       value: isBuyerMode,
                          //       onChanged: (value) {
                          //         setState(() {
                          //           isBuyerMode = value;
                          //           saveModeState(isBuyerMode);
                          //         });
                          //       },
                          //       trackColor: WidgetStatePropertyAll(kColor),
                          //       trackOutlineColor: WidgetStatePropertyAll(kColor),
                          //       inactiveThumbColor: Colors.white,
                          //     ),
                          //     SizedBox(width: 5),
                          //     Text(
                          //       "Buyer mode",
                          //       style: TextStyle(
                          //         fontSize: size.height * 0.0175,
                          //         fontWeight: FontWeight.bold,
                          //         color: Colors.black,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(
                                'About',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17.5),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text(
                              about!,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.5,
                              ),
                            ),
                          ),
                          crops.isEmpty
                              ? Container()
                              : SizedBox(
                                  height: 20,
                                ),
                          crops.isEmpty
                              ? Container()
                              : Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Text(
                                      'Crops',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17.5),
                                    ),
                                  ),
                                ),
                          crops.isEmpty
                              ? Container()
                              : SizedBox(
                                  height: 10,
                                ),
                          crops.isEmpty
                              ? Container()
                              : Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    padding:
                                        EdgeInsets.only(left: 20, right: 20),
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: List<Widget>.generate(
                                          crops.length, (index) {
                                        var crop = crops[index];
                                        return GestureDetector(
                                          onTap: () {
                                            showCropDetails(crop);
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.4,
                                            child: Card(
                                              color: crop['isAccepted']
                                                  ? Color.fromARGB(
                                                      121, 255, 235, 50)
                                                  : crops[index]['isExpired']
                                                      ? Color.fromARGB(
                                                          68, 244, 67, 50)
                                                      : const Color.fromARGB(
                                                          92, 76, 175, 50),
                                              elevation: 0,
                                              margin: EdgeInsets.only(
                                                  left: 0, right: 20),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                              ),
                                              child: Container(
                                                padding: EdgeInsets.all(15),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      crop['isAccepted']
                                                          ? 'Accepted'
                                                          : crop['isExpired']
                                                              ? 'Expired'
                                                              : 'Available',
                                                      style: TextStyle(
                                                        color: crop[
                                                                'isAccepted']
                                                            ? Colors.amber[700]
                                                            : crop['isExpired']
                                                                ? Colors.red
                                                                : const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    70,
                                                                    170,
                                                                    74),
                                                        fontSize:
                                                            size.height * 0.015,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    SizedBox(height: 5),
                                                    Text(
                                                      crop['cropType'],
                                                      style: TextStyle(
                                                        fontSize:
                                                            size.height * 0.02,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ),
                          // Align(
                          //   alignment: Alignment.centerLeft,
                          //   child: Padding(
                          //     padding:
                          //         const EdgeInsets.symmetric(horizontal: 20.0),
                          //     child: Wrap(
                          //       spacing: 8.0,
                          //       runSpacing: 4.0,
                          //       children: crops.map((crop) {
                          //         return Chip(
                          //           labelStyle: TextStyle(
                          //               fontSize: 15,
                          //               fontWeight: FontWeight.w500),
                          //           color: WidgetStateProperty.all(
                          //               Color.fromRGBO(86, 232, 137, 1)),
                          //           label: Text(crop),
                          //         );
                          //       }).toList(),
                          //     ),
                          //   ),
                          // ),
                          requirements.isEmpty
                              ? Container()
                              : SizedBox(
                                  height: 20,
                                ),
                          requirements.isEmpty
                              ? Container()
                              : Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Text(
                                      'Requirements',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17.5),
                                    ),
                                  ),
                                ),
                          requirements.isEmpty
                              ? Container()
                              : SizedBox(
                                  height: 10,
                                ),
                          requirements.isEmpty
                              ? Container()
                              : Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    padding:
                                        EdgeInsets.only(left: 20, right: 20),
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: List<Widget>.generate(
                                          requirements.length, (index) {
                                        var requirement = requirements[index];
                                        return GestureDetector(
                                          onTap: () {
                                            showRequireDetails(requirement);
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.4,
                                            child: Card(
                                              color: requirement['isAccepted']
                                                  ? Color.fromARGB(
                                                      121, 255, 235, 50)
                                                  : requirement['isExpired']
                                                      ? Color.fromARGB(
                                                          68, 244, 67, 50)
                                                      : const Color.fromARGB(
                                                          92, 76, 175, 50),
                                              elevation: 0,
                                              margin: EdgeInsets.only(
                                                  left: 0, right: 20),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                              ),
                                              child: Container(
                                                padding: EdgeInsets.all(15),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      requirement['isAccepted']
                                                          ? 'Accepted'
                                                          : requirement[
                                                                  'isExpired']
                                                              ? 'Expired'
                                                              : 'Available',
                                                      style: TextStyle(
                                                        color: requirement[
                                                                'isAccepted']
                                                            ? Colors.amber[700]
                                                            : requirement[
                                                                    'isExpired']
                                                                ? Colors.red
                                                                : const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    70,
                                                                    170,
                                                                    74),
                                                        fontSize:
                                                            size.height * 0.015,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    SizedBox(height: 5),
                                                    Text(
                                                      requirement['cropType'],
                                                      style: TextStyle(
                                                        fontSize:
                                                            size.height * 0.02,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                    // SizedBox(
                                                    //   height: 7.5,
                                                    // ),
                                                    // Align(
                                                    //   alignment: Alignment.bottomRight,
                                                    //   child: Row(
                                                    //     mainAxisAlignment:
                                                    //         MainAxisAlignment.end,
                                                    //     children: [
                                                    //       Container(
                                                    //           decoration: BoxDecoration(
                                                    //               color: Colors.white,
                                                    //               borderRadius:
                                                    //                   BorderRadius
                                                    //                       .circular(
                                                    //                           10)),
                                                    //           child: IconButton(
                                                    //             icon: Icon(
                                                    //               Icons.delete,
                                                    //             ),
                                                    //             onPressed: () {},
                                                    //           )),
                                                    //       SizedBox(width: 5),
                                                    //       Container(
                                                    //           decoration: BoxDecoration(
                                                    //               color: Colors.white,
                                                    //               borderRadius:
                                                    //                   BorderRadius
                                                    //                       .circular(
                                                    //                           10)),
                                                    //           child: IconButton(
                                                    //             icon: Icon(
                                                    //               Icons.edit,
                                                    //             ),
                                                    //             onPressed: () {},
                                                    //           )),
                                                    //     ],
                                                    //   ),
                                                    // )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ),
                          SizedBox(
                            height: 30,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ProfileEditScreen()));
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              child: Text(
                                'Edit Profile',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kColor,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            onPressed: logout,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              child: Text(
                                'Logout',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kColor3,
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          )
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
