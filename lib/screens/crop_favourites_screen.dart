import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:green_market_test/components/bottom_bar.dart';
import 'package:green_market_test/components/constants.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

late User? loggedInUser;

class CropFavouritesScreen extends StatefulWidget {
  const CropFavouritesScreen({super.key});

  @override
  State<CropFavouritesScreen> createState() => _CropFavouritesScreenState();
}

class _CropFavouritesScreenState extends State<CropFavouritesScreen> {
  late List cropFavourites = [];
  final _auth = FirebaseAuth.instance;
  bool showLoading = true;

  void getCurrentUser() async {
    final user = await _auth.currentUser;
    if (user != null) {
      loggedInUser = user;
      await getUserFavourites();
    }
  }

  Future<void> getUserFavourites() async {
    try {
      setState(() {
        showLoading = true;
      });

      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(loggedInUser!.email)
          .get();

      if (userDoc.exists) {
        List cropFavouritesList = [];

        if (userDoc['cropFavourites'] == null) {
          setState(() {
            showLoading = false;
            cropFavourites = [];
          });
          return;
        }

        List<String> cropFavouritesIdList =
            List<String>.from(userDoc['cropFavourites']);

        if (cropFavouritesIdList.isEmpty) {
          setState(() {
            showLoading = false;
            cropFavourites = [];
          });
          return;
        } else {
          for (var id in cropFavouritesIdList) {
            var data = await FirebaseFirestore.instance
                .collection('crops')
                .doc(id)
                .get();

            if (data.exists) {
              cropFavouritesList.add(data);
            }
          }
          setState(() {
            cropFavourites = cropFavouritesList;
            showLoading = false;
          });
        }
      }
    } catch (e) {
      print(e);
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

  removeCropFavourites(String cropId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(loggedInUser!.email)
          .update({
        'cropFavourites': FieldValue.arrayRemove([cropId]),
      });

      await getUserFavourites();

      setState(() async {
        cropFavourites.remove(cropId);
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

  void _showCropDetails(var data) {
    Timestamp availableDateTimestamp = data['availableDate'];
    Timestamp expireDateTimestamp = data['expiringDate'];

    String availableDate = _formatTimestamp(availableDateTimestamp);
    String expireDate = _formatTimestamp(expireDateTimestamp);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        final size = MediaQuery.of(context).size;
        return Container(
          height: size.height * 0.7,
          child: Stack(children: [
            Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                    image: DecorationImage(
                      image: NetworkImage(data['images']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          data['cropType'],
                          style: TextStyle(
                            fontSize: size.height * 0.025,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: size.width * 0.9,
                        child: Row(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  color: Colors.black,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  data['farmerName'],
                                  style: TextStyle(
                                    color: Color(0xFF222325),
                                    fontSize: size.height * 0.02,
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.red,
                                  size: 17.5,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  data['district'],
                                  style: TextStyle(
                                      color: kColor4,
                                      fontSize: size.height * 0.0175,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
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
                                fontSize: size.height * 0.0175,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            '${data['weight']} kg',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: size.height * 0.0175,
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
                                fontSize: size.height * 0.0175,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Rs. ${data['price']}',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: size.height * 0.0175,
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
                                fontSize: size.height * 0.0175,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            availableDate,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: size.height * 0.0175,
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
                                fontSize: size.height * 0.0175,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            expireDate,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: size.height * 0.0175,
                                color: Color(0xFF222325)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FloatingActionButton(
                              onPressed: () {
                                _makePhoneCall('0' + data['phoneNumber']);
                              },
                              child: Icon(
                                Icons.call,
                                color: Colors.white,
                              ),
                              backgroundColor: kColor,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
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
                      color: Colors.white,
                    ))),
          ]),
        );
      },
    );
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
              top: 15,
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
              child: Text('Favorites',
                  style: TextStyle(
                      fontSize: size.height * 0.03,
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
                    : cropFavourites.isEmpty
                        ? Center(
                            child: Text(
                              'No Favourites Available',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          )
                        : Container(
                            padding: EdgeInsets.symmetric(horizontal: 15.0),
                            child: ListView.builder(
                                itemCount: cropFavourites.length,
                                itemBuilder: (context, index) {
                                  var data = cropFavourites[index];

                                  return GestureDetector(
                                    onTap: () {
                                      _showCropDetails(data);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(top: 10),
                                      child: Card(
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        color: kColor2,
                                        child: Container(
                                          height: size.height * 0.22,
                                          padding: EdgeInsets.all(15.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        child: Image(
                                                          width:
                                                              size.width * 0.3,
                                                          height: size.height *
                                                              0.125,
                                                          fit: BoxFit.cover,
                                                          image: NetworkImage(
                                                              data['images']),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
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
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 20),
                                                    child: Container(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Icon(
                                                                Icons.person,
                                                                color: Colors
                                                                    .black,
                                                                size: 17.5,
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                data[
                                                                    'farmerName'],
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xFF222325),
                                                                  fontSize: size
                                                                          .height *
                                                                      0.0175,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 3,
                                                          ),
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
                                                          SizedBox(
                                                            height: 3,
                                                          ),
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
                                                                        FontWeight
                                                                            .w600),
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
                                                            height: 3,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'Price :',
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
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                'Rs. ${data['price']}',
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
                                                            height: 10,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Container(
                                                                child: Row(
                                                                  children: [
                                                                    // ClipRRect(
                                                                    //   borderRadius:
                                                                    //       BorderRadius
                                                                    //           .circular(10),
                                                                    //   child: Container(
                                                                    //     padding:
                                                                    //         EdgeInsets.zero,
                                                                    //     color: kColor,
                                                                    //     child: IconButton(
                                                                    //       onPressed: () {},
                                                                    //       icon: Icon(
                                                                    //         size: 17,
                                                                    //         Icons
                                                                    //             .chat_bubble,
                                                                    //         color: Colors
                                                                    //             .white,
                                                                    //       ),
                                                                    //     ),
                                                                    //   ),
                                                                    // ),
                                                                    // SizedBox(
                                                                    //   width: 10,
                                                                    // ),
                                                                    ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      child:
                                                                          Container(
                                                                        padding:
                                                                            EdgeInsets.zero,
                                                                        color:
                                                                            kColor,
                                                                        child:
                                                                            IconButton(
                                                                          onPressed:
                                                                              () {
                                                                            _makePhoneCall('0' +
                                                                                data['phoneNumber']);
                                                                          },
                                                                          icon:
                                                                              Icon(
                                                                            size:
                                                                                20,
                                                                            Icons.call,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      child:
                                                                          Container(
                                                                        padding:
                                                                            EdgeInsets.zero,
                                                                        color:
                                                                            kColor,
                                                                        child:
                                                                            IconButton(
                                                                          onPressed:
                                                                              () {
                                                                            removeCropFavourites(data.id);
                                                                            getUserFavourites();
                                                                          },
                                                                          icon:
                                                                              Icon(
                                                                            size:
                                                                                20,
                                                                            Icons.delete,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          )),
          ],
        ),
      ),
    );
  }
}
