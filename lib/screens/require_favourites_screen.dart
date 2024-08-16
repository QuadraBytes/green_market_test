import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:green_market_test/components/bottom_bar.dart';
import 'package:green_market_test/components/constants.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

late User? loggedInUser;

class RequireFavouritesScreen extends StatefulWidget {
  const RequireFavouritesScreen({super.key});

  @override
  State<RequireFavouritesScreen> createState() =>
      _RequireFavouritesScreenState();
}

class _RequireFavouritesScreenState extends State<RequireFavouritesScreen> {
  late List requireFavourites = [];
  final _auth = FirebaseAuth.instance;
  bool showLoading = true;

  void getCurrentUser() async {
    final user = await _auth.currentUser;
    if (user != null) {
      loggedInUser = user;
      await getUserFavourites();
    }
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  Future<void> getUserFavourites() async {
    try {
      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(loggedInUser!.email)
          .get();

      if (userDoc.exists) {
        List requireFavouritesList = [];
        List<String> requireFavouritesIdList =
            List<String>.from(userDoc['requireFavourites'] ?? []);

        if (requireFavouritesIdList.isEmpty) {
          setState(() {
            showLoading = false;
          });
          return;
        } else {
          for (var id in requireFavouritesIdList) {
            var data = await FirebaseFirestore.instance
                .collection('requirements')
                .doc(id)
                .get();

            requireFavouritesList.add(data);
          }
          setState(() {
            requireFavourites = requireFavouritesList;
            showLoading = false;
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  removeRequireFavourites(String requireId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(loggedInUser!.email)
          .update({
        'requireFavourites': FieldValue.arrayRemove([requireId]),
      });

      setState(() {
        requireFavourites.remove(requireId);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('yyyy-MM-dd').format(dateTime);
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
              ),
            ),
            Positioned(
              top: 25,
              left: size.width * 0.35,
              right: size.width * 0.3,
              child: Text('Favourites',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)),
            ),
            Positioned(
              top: 100,
              left: 0,
              right: 0,
              bottom: 56,
              child: showLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: kColor,
                      ),
                    )
                  : requireFavourites.isEmpty
                      ? Center(
                          child: Text(
                            'No Favourites Available',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        )
                      : Container(
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                          child: ListView.builder(
                              itemCount: requireFavourites.length,
                              itemBuilder: (context, index) {
                                var data = requireFavourites[index];
                                Timestamp timestamp = data['requiredDate'];
                                String formattedDate =
                                    _formatTimestamp(timestamp);

                                return Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    color: kColor2,
                                    child: Container(
                                      height: size.height * 0.15,
                                      padding: EdgeInsets.all(15.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: size.width * 0.8,
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            data['cropType'],
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xFF222325),
                                                                fontSize:
                                                                    size.height *
                                                                        0.0175,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                          Spacer(),
                                                          Row(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .location_on,
                                                                color:
                                                                    Colors.red,
                                                                size: 15,
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                data[
                                                                    'district'],
                                                                style: TextStyle(
                                                                    color:
                                                                        kColor4,
                                                                    fontSize:
                                                                        size.height *
                                                                            0.015,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height: 5),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.person,
                                                          color: Colors.black,
                                                          size: 17.5,
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          data['buyerName'],
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF222325),
                                                            fontSize:
                                                                size.height *
                                                                    0.0175,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Container(
                                                      width: size.width * 0.8,
                                                      child: Row(
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    'Weight :',
                                                                    style: TextStyle(
                                                                        color:
                                                                            kColor4,
                                                                        fontSize:
                                                                            size.height *
                                                                                0.015,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Text(
                                                                    '${data['weight']} kg',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        fontSize:
                                                                            size.height *
                                                                                0.015,
                                                                        color: Color(
                                                                            0xFF222325)),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    'Required Date :',
                                                                    style: TextStyle(
                                                                        color:
                                                                            kColor4,
                                                                        fontSize:
                                                                            size.height *
                                                                                0.015,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Text(
                                                                    formattedDate,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        fontSize:
                                                                            size.height *
                                                                                0.015,
                                                                        color: Color(
                                                                            0xFF222325)),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          Spacer(),
                                                          // ClipRRect(
                                                          //   borderRadius:
                                                          //       BorderRadius.circular(10),
                                                          //   child: Container(
                                                          //     padding: EdgeInsets.zero,
                                                          //     color: kColor,
                                                          //     child: IconButton(
                                                          //       onPressed: () {},
                                                          //       icon: Icon(
                                                          //         size: 17,
                                                          //         Icons.chat_bubble,
                                                          //         color: Colors.white,
                                                          //       ),
                                                          //     ),
                                                          //   ),
                                                          // ),
                                                          // Spacer(),
                                                          // SizedBox(
                                                          //   width: 10,
                                                          // ),
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            child: Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              color: kColor,
                                                              child: IconButton(
                                                                onPressed: () {
                                                                  removeRequireFavourites(
                                                                      data.id);
                                                                  getUserFavourites();
                                                                },
                                                                icon: Icon(
                                                                  size: 20,
                                                                  Icons.delete,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            child: Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              color: kColor,
                                                              child: IconButton(
                                                                onPressed: () {
                                                                  _makePhoneCall(
                                                                      data[
                                                                          'phoneNumber']);
                                                                },
                                                                icon: Icon(
                                                                  size: 20,
                                                                  Icons.call,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
