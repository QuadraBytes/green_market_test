import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:green_market_test/components/constants.dart';
import 'package:green_market_test/components/side_bar.dart';
import 'package:green_market_test/models/models.dart';
import 'package:green_market_test/screens/add_crop_screen.dart';
import 'package:green_market_test/screens/favourites_screen.dart';
import 'package:green_market_test/screens/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:url_launcher/url_launcher.dart';

late User? loggedInUser;

class FarmerScreen extends StatefulWidget {
  const FarmerScreen({super.key});

  @override
  State<FarmerScreen> createState() => _FarmerScreenState();
}

class _FarmerScreenState extends State<FarmerScreen> {
  TextEditingController searchText = TextEditingController();
  String selectedDistrict = '';
  String selectedWeightRange = '';
  List<String> selectedPriceRange = [];
  bool isAvailableSelected = false;
  bool isUpcomingSelected = false;

  bool showSearchBar = false;
  bool isDistrictExpanded = false;
  bool isWeightExpanded = false;
  bool isPriceExpanded = false;
  FocusNode searchFocusNode = FocusNode();
  late List cropList = [];
  late List searchList = [];
  late List filterList = [];
  late List unionCropList = [];
  List<String> cropFavourites = [];

  var isListening = false;
  SpeechToText speech = SpeechToText();

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
      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(loggedInUser!.email)
          .get();

      if (userDoc.exists) {
        setState(() {
          cropFavourites = List<String>.from(userDoc['cropFavourites'] ?? []);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getAllCrops();
    searchFocusNode.addListener(() {
      if (!searchFocusNode.hasFocus) {
        setState(() {
          showSearchBar = false;
        });
      }
    });
    // setState(() {
    //   showLoading = false;
    // });
  }

  @override
  void dispose() {
    searchFocusNode.dispose();
    super.dispose();
  }

  getAllCrops() async {
    var allcroplist = await FirebaseFirestore.instance
        .collection('crops')
        .where('isAccepted', isEqualTo: false)
        .where('isDeleted', isEqualTo: false)
        .get();

    for (var doc in allcroplist.docs) {
      DateTime expiredDate = doc['expiringDate'].toDate();
      bool isExpired = doc['isExpired'];

      if (DateTime.now().isAfter(expiredDate) && !isExpired) {
        await FirebaseFirestore.instance
            .collection('crops')
            .doc(doc.id)
            .update({'isExpired': true});
      }
    }

    var list = await FirebaseFirestore.instance
        .collection('crops')
        .where('isAccepted', isEqualTo: false)
        .where('isDeleted', isEqualTo: false)
        .where('isExpired', isEqualTo: false)
        .get();

    setState(() {
      cropList = list.docs;
      unionCropList = cropList;
      showLoading = false;
    });
  }

  addFavourites(String cropId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(loggedInUser!.email)
          .update({
        'cropFavourites': FieldValue.arrayUnion([cropId]),
      });

      setState(() {
        cropFavourites.add(cropId);
      });
    } catch (e) {
      print(e);
    }
  }

  removeFavourites(String cropId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(loggedInUser!.email)
          .update({
        'cropFavourites': FieldValue.arrayRemove([cropId]),
      });

      setState(() {
        cropFavourites.remove(cropId);
      });
    } catch (e) {
      print(e);
    }
  }

  bool isFavourite(String cropId) {
    return cropFavourites.contains(cropId);
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    try {
      await launch(launchUri.toString());
    } catch (e) {
      print('Could not launch $phoneNumber');
    }
  }

  updateUnionList() {
    setState(() {
      if (searchText.text.isEmpty &&
          selectedDistrict.isEmpty &&
          selectedPriceRange.isEmpty &&
          selectedWeightRange.isEmpty) {
        unionCropList = cropList;
      } else if (searchText.text.isNotEmpty && selectedDistrict.isNotEmpty ||
          selectedPriceRange.isNotEmpty ||
          selectedWeightRange.isNotEmpty) {
        unionCropList =
            searchList.toSet().intersection(filterList.toSet()).toList();
      } else if (searchText.text.isEmpty && selectedDistrict.isNotEmpty ||
          selectedPriceRange.isNotEmpty ||
          selectedWeightRange.isNotEmpty) {
        unionCropList = filterList;
      } else if (searchText.text.isNotEmpty &&
          selectedDistrict.isEmpty &&
          selectedPriceRange.isEmpty &&
          selectedWeightRange.isEmpty) {
        unionCropList = searchList;
      }
    });
  }

  searchFilter(String text) {
    if (text.isNotEmpty) {
      String searchLower = text.toLowerCase();
      List list = [];
      for (var crop in cropList) {
        if (crop['cropType'].toString().toLowerCase().contains(searchLower) ||
            crop['farmerName'].toString().toLowerCase().contains(searchLower) ||
            searchLower.contains(crop['cropType'].toString().toLowerCase()) ||
            searchLower.contains(crop['farmerName'].toString().toLowerCase())) {
          list.add(crop);
        }
      }
      setState(() {
        searchList = list;
      });
    } else {
      setState(() {
        searchList = [];
      });
    }
    updateUnionList();
  }

  Filter() {
    List list = [];
    for (var crop in cropList) {
      bool isInclude = true;

      if (selectedWeightRange.isNotEmpty) {
        // int cropWeight = int.parse(crop['weight']);
        // if (cropWeight < int.parse(selectedWeightRange[0]) ||
        //     cropWeight > int.parse(selectedWeightRange[1])) {
        //   isInclude = false;
        // }
        if (selectedWeightRange == crop['weight']) {
          isInclude = false;
        }
      }
      if (selectedPriceRange.isNotEmpty) {
        int cropPrice = int.parse(crop['price']);
        if (cropPrice < int.parse(selectedPriceRange[0]) ||
            cropPrice > int.parse(selectedPriceRange[1])) {
          isInclude = false;
        }
      }
      if (selectedDistrict.isNotEmpty && crop['district'] != selectedDistrict) {
        isInclude = false;
      }

      Timestamp availableDateTimestamp = crop['availableDate'];
      DateTime availableDate = availableDateTimestamp.toDate();
      Timestamp expireDateTimestamp = crop['expiringDate'];
      DateTime expireDate = expireDateTimestamp.toDate();

      if (isAvailableSelected) {
        if (availableDate.isAfter(DateTime.now())) {
          isInclude = false;
        }
      }
      if (isUpcomingSelected) {
        if (availableDate.isBefore(DateTime.now())) {
          isInclude = false;
        }
      }
      if (isInclude) {
        list.add(crop);
      }
    }
    setState(() {
      filterList = list;
    });
    updateUnionList();
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  void _showCropDetails(var data, var images, bool isFavourite) {
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
                                  data['farmerType'] == 'Single'
                                      ? Icons.person
                                      : Icons.people,
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
                            FloatingActionButton(
                              onPressed: () {
                                Navigator.pop(context);
                                addFavourites(data.id);
                                _showCropDetails(data, images, true);
                              },
                              child: Icon(
                                Icons.favorite,
                                color:
                                    isFavourite ? Colors.black : Colors.white,
                              ),
                              backgroundColor: kColor,
                            ),
                            SizedBox(
                              width: 10,
                            )
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

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        final size = MediaQuery.of(context).size;
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Stack(children: [
              Positioned(
                top: 10,
                left: size.width * 0.35,
                right: size.width * 0.35,
                child: Container(
                  margin: EdgeInsets.only(top: 20),
                  width: size.width * 0.3,
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Color.fromARGB(255, 0, 110, 57),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 15, right: 15, top: 60),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (isAvailableSelected) {
                                      isAvailableSelected = false;
                                    } else {
                                      isAvailableSelected = true;
                                    }
                                    Filter();
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: isAvailableSelected == false
                                          ? Border.all(
                                              width: 1,
                                              style: BorderStyle.solid,
                                              color: Color.fromARGB(
                                                  255, 0, 110, 57))
                                          : Border.all(
                                              color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(50),
                                      color: isAvailableSelected
                                          ? Color.fromARGB(255, 0, 110, 57)
                                          : Colors.transparent),
                                  child: Text(
                                    'Available',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: isAvailableSelected
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Expanded(
                                child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isUpcomingSelected) {
                                    isUpcomingSelected = false;
                                  } else {
                                    isUpcomingSelected = true;
                                  }
                                  Filter();
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: isUpcomingSelected == false
                                        ? Border.all(
                                            width: 1,
                                            style: BorderStyle.solid,
                                            color:
                                                Color.fromARGB(255, 0, 110, 57))
                                        : Border.all(color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(50),
                                    color: isUpcomingSelected
                                        ? Color.fromARGB(255, 0, 110, 57)
                                        : Colors.transparent),
                                child: Text(
                                  'Upcoming',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: isUpcomingSelected
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                            ))
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10.0),
                        child: ExpansionPanelList(
                          dividerColor: const Color.fromARGB(255, 0, 110, 57),
                          elevation: 0,
                          expandIconColor:
                              const Color.fromARGB(255, 0, 110, 57),
                          materialGapSize: 0,
                          expandedHeaderPadding: EdgeInsets.zero,
                          children: [
                            ExpansionPanel(
                              backgroundColor: Colors.transparent,
                              headerBuilder:
                                  (BuildContext context, bool isExpanded) {
                                return ListTile(
                                  title: Text(
                                    'District',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                );
                              },
                              body: Column(
                                children: [
                                  Column(
                                    children: districts
                                        .map((district) => ListTile(
                                              title: selectedDistrict ==
                                                      district
                                                  ? Row(
                                                      children: [
                                                        Icon(
                                                          Icons.check,
                                                          color: const Color
                                                              .fromARGB(
                                                              255, 0, 110, 57),
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(district)
                                                      ],
                                                    )
                                                  : Text(district),
                                              onTap: () {
                                                if (selectedDistrict ==
                                                    district) {
                                                  selectedDistrict = '';
                                                } else {
                                                  selectedDistrict = district;
                                                }
                                                Navigator.pop(context);
                                                _showFilterSheet(context);
                                                Filter();
                                              },
                                            ))
                                        .toList(),
                                  ),
                                ],
                              ),
                              isExpanded: isDistrictExpanded,
                              canTapOnHeader: true,
                            ),
                            ExpansionPanel(
                              backgroundColor: Colors.transparent,
                              headerBuilder:
                                  (BuildContext context, bool isExpanded) {
                                return Column(
                                  children: [
                                    ListTile(
                                      title: Text(
                                        'Weight',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                );
                              },
                              body: Column(
                                children: List.generate(
                                  weightRange.length,
                                  (index) => ListTile(
                                    title: Text('${weightRange[index]} kg'),
                                    onTap: () {
                                      selectedWeightRange = weightRange[index];
                                      print(selectedWeightRange);
                                      Navigator.pop(context);
                                      _showFilterSheet(context);
                                      Filter();
                                    },
                                  ),
                                ),
                              ),
                              isExpanded: isWeightExpanded,
                              canTapOnHeader: true,
                            ),
                            ExpansionPanel(
                              backgroundColor: Colors.transparent,
                              headerBuilder:
                                  (BuildContext context, bool isExpanded) {
                                return Column(
                                  children: [
                                    ListTile(
                                      title: Text(
                                        'Price',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                );
                              },
                              body: Column(
                                children: List.generate(
                                  priceRange.length,
                                  (index) => ListTile(
                                    title: index == 0
                                        ? selectedPriceRange.contains('0') &&
                                                selectedPriceRange
                                                    .contains(priceRange[index])
                                            ? Row(
                                                children: [
                                                  Icon(
                                                    Icons.check,
                                                    color: const Color.fromARGB(
                                                        255, 0, 110, 57),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                      'Below Rs.${priceRange[index]}'),
                                                ],
                                              )
                                            : Text(
                                                'Below Rs.${priceRange[index]}')
                                        : index == priceRange.length - 1
                                            ? selectedPriceRange.contains(
                                                        priceRange[index]) &&
                                                    selectedPriceRange
                                                        .contains('1000000')
                                                ? Row(
                                                    children: [
                                                      Icon(
                                                        Icons.check,
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 0, 110, 57),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                          'Above Rs.${priceRange[index]}'),
                                                    ],
                                                  )
                                                : Text(
                                                    'Above Rs.${priceRange[index]}')
                                            : selectedPriceRange.contains(
                                                        priceRange[index]) &&
                                                    selectedPriceRange.contains(
                                                        priceRange[index + 1])
                                                ? Row(
                                                    children: [
                                                      Icon(
                                                        Icons.check,
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 0, 110, 57),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                          'Rs.${priceRange[index]} - ${priceRange[index + 1]}'),
                                                    ],
                                                  )
                                                : Text(
                                                    'Rs.${priceRange[index]} - ${priceRange[index + 1]}'),
                                    onTap: () {
                                      if (index == 0) {
                                        if (selectedPriceRange.contains('0') &&
                                            selectedPriceRange
                                                .contains(priceRange[index])) {
                                          selectedPriceRange = [];
                                        } else {
                                          selectedPriceRange = [
                                            '0',
                                            priceRange[index]
                                          ];
                                        }
                                      } else if (index ==
                                          priceRange.length - 1) {
                                        if (selectedPriceRange
                                                .contains(priceRange[index]) &&
                                            selectedPriceRange
                                                .contains('1000000')) {
                                          selectedPriceRange = [];
                                        } else {
                                          selectedPriceRange = [
                                            priceRange[index],
                                            '1000000'
                                          ];
                                        }
                                      } else {
                                        if (selectedPriceRange
                                                .contains(priceRange[index]) &&
                                            selectedPriceRange.contains(
                                                priceRange[index + 1])) {
                                          selectedPriceRange = [];
                                        } else {
                                          selectedPriceRange = [
                                            priceRange[index],
                                            priceRange[index + 1]
                                          ];
                                        }
                                      }
                                      print(selectedPriceRange);
                                      Navigator.pop(context);
                                      _showFilterSheet(context);
                                      Filter();
                                    },
                                  ),
                                ),
                              ),
                              isExpanded: isPriceExpanded,
                              canTapOnHeader: true,
                            ),
                          ],
                          expansionCallback: (int index, bool isExpanded) {
                            setState(() {
                              if (index == 0) {
                                isDistrictExpanded = !isDistrictExpanded;
                                if (isDistrictExpanded) {
                                  isWeightExpanded = false;
                                  isPriceExpanded = false;
                                }
                              } else if (index == 1) {
                                isWeightExpanded = !isWeightExpanded;
                                if (isWeightExpanded) {
                                  isDistrictExpanded = false;
                                  isPriceExpanded = false;
                                }
                              } else if (index == 2) {
                                isPriceExpanded = !isPriceExpanded;
                                if (isPriceExpanded) {
                                  isDistrictExpanded = false;
                                  isWeightExpanded = false;
                                }
                              }
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      )
                    ],
                  ),
                ),
              ),
            ]);
          },
        );
      },
    );
  }

  Color iColor = Colors.black;
  IconData iIcon = Icons.mic_off_rounded;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var height = size.height * 0.15;

    return SafeArea(
      child: Scaffold(
        floatingActionButton: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddCropScreen()),
              );
            },
            child: Icon(
              Icons.add,
              size: 30,
              color: Colors.white,
            ),
            backgroundColor: kColor,
          ),
        ),
        drawer: const SideBar(),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: (selectedDistrict != '' ||
                  selectedPriceRange.isNotEmpty ||
                  selectedWeightRange.isNotEmpty)
              ? showSearchBar
                  ? 110
                  : 100
              : showSearchBar
                  ? 70
                  : 60,
          title: Container(
            padding: EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    !showSearchBar
                        ? Builder(
                            builder: (context) {
                              return IconButton(
                                icon: Icon(
                                  Icons.list,
                                  color: Colors.black,
                                  size: 30,
                                ),
                                onPressed: () {
                                  Scaffold.of(context).openDrawer();
                                },
                              );
                            },
                          )
                        : Container(),
                    !showSearchBar ? SizedBox(width: 10) : Container(),
                    Expanded(
                      child: !showSearchBar
                          ? Align(
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    searchFocusNode.requestFocus();
                                    showSearchBar = !showSearchBar;
                                  });
                                },
                                icon: Icon(
                                  Icons.search,
                                  color: Colors.black,
                                  size: 25,
                                ),
                              ),
                            )
                          : TextField(
                              controller: searchText,
                              onChanged: (text) {
                                searchFilter(searchText.text.toString());
                              },
                              focusNode: searchFocusNode,
                              decoration: InputDecoration(
                                fillColor: const Color.fromRGBO(0, 0, 0, 0),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.black,
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: () async {
                                    if (!isListening) {
                                      bool available = await speech.initialize(
                                        onStatus: (status) {
                                          print('status: $status');
                                        },
                                        onError: (errorNotification) {
                                          print('error: $errorNotification');
                                        },
                                      );
                                      if (available) {
                                        setState(() {
                                          isListening = true;
                                          iColor = kColor;
                                          iIcon = Icons.mic_rounded;
                                        });

                                        speech.listen(
                                          onResult: (result) {
                                            setState(() {
                                              searchText.text =
                                                  result.recognizedWords;
                                              searchFilter(
                                                  searchText.text.toString());
                                            });
                                          },
                                        );
                                      }
                                    } else {
                                      setState(() {
                                        isListening = false;
                                        iColor = Colors.black;
                                        iIcon = Icons.mic_off_rounded;
                                      });
                                      speech.stop();
                                    }
                                  },
                                  child: Icon(
                                    iIcon,
                                    color: iColor,
                                  ),
                                ),
                                hintText: 'Search Crop',
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide:
                                      BorderSide(width: 1, color: Colors.black),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide:
                                      BorderSide(width: 2, color: Colors.black),
                                ),
                                filled: true,
                              ),
                              style: TextStyle(fontSize: 15.0),
                            ),
                    ),
                    !showSearchBar
                        ? IconButton(
                            focusNode: searchFocusNode,
                            icon: Icon(
                              Icons.filter_alt_outlined,
                              size: 25,
                            ),
                            onPressed: () {
                              _showFilterSheet(context);
                            },
                          )
                        : Container(),
                    !showSearchBar
                        ? IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FavouritesScreen()),
                              );
                            },
                            icon: Icon(
                              Icons.favorite,
                              color: Colors.black,
                              size: 25,
                            ),
                          )
                        : Container(),
                    !showSearchBar
                        ? IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfileScreen()),
                              );
                            },
                            icon: Icon(
                              Icons.person,
                              color: Colors.black,
                              size: 25,
                            ),
                          )
                        : Container(),
                  ],
                ),
                !showSearchBar
                    ? Container()
                    : SizedBox(
                        height: 10,
                      ),
                if (selectedDistrict.isNotEmpty ||
                    selectedWeightRange.isNotEmpty ||
                    selectedPriceRange.isNotEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Wrap(
                            spacing: 8.0,
                            children: [
                              if (selectedDistrict.isNotEmpty)
                                Chip(
                                  label: Text(selectedDistrict),
                                  onDeleted: () {
                                    setState(() {
                                      selectedDistrict = '';
                                      Filter();
                                    });
                                  },
                                ),
                              if (selectedWeightRange.isNotEmpty)
                                Chip(
                                  label: Text('$selectedWeightRange kg'),
                                  onDeleted: () {
                                    setState(() {
                                      selectedWeightRange = '';
                                      Filter();
                                    });
                                  },
                                ),
                              if (selectedPriceRange.isNotEmpty)
                                Chip(
                                  label: Text(
                                      'Rs.${selectedPriceRange.first} - Rs.${selectedPriceRange.last}'),
                                  onDeleted: () {
                                    setState(() {
                                      selectedPriceRange = [];
                                      Filter();
                                    });
                                  },
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        body: GestureDetector(
          onTap: () {
            searchFocusNode.unfocus();
          },
          child: showLoading==true
              ? Center(
                  child: CircularProgressIndicator(
                  color: kColor,
                ))
              : unionCropList.isEmpty
                  ? Center(
                      child: Text(
                        'No Crops Available',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: ListView.builder(
                          itemCount: unionCropList.length,
                          itemBuilder: (context, index) {
                            var data = unionCropList[index];
                            bool isFavouriteCrop = isFavourite(data.id);
                            var images = [
                              "assets/images/crop.jpg",
                              "assets/images/crop2.jpg"
                            ];

                            return GestureDetector(
                              onTap: () {
                                _showCropDetails(data, images, isFavouriteCrop);
                              },
                              child: Container(
                                margin: index == (unionCropList.length - 1)
                                    ? EdgeInsets.only(top: 10, bottom: 30)
                                    : EdgeInsets.only(top: 10),
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
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
                                                      BorderRadius.circular(10),
                                                  child: Image(
                                                    width: size.width * 0.3,
                                                    height: size.height * 0.125,
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(
                                                        data['images']),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  width: size.width * 0.3,
                                                  child: Text(
                                                    data['cropType'],
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Color(0xFF222325),
                                                        fontSize:
                                                            size.height * 0.0175,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 20),
                                              child: Container(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          data['farmerType'] ==
                                                                  'Single'
                                                              ? Icons.person
                                                              : Icons.people,
                                                          color: Colors.black,
                                                          size: 17.5,
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          data['farmerName'],
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
                                                      height: 3,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.location_on,
                                                          color: Colors.red,
                                                          size: 15,
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          data['district'],
                                                          style: TextStyle(
                                                              color: kColor4,
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
                                                              color: kColor4,
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
                                                              color: kColor4,
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
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  color: kColor,
                                                                  child:
                                                                      IconButton(
                                                                    onPressed:
                                                                        () {
                                                                      _makePhoneCall(
                                                                          data[
                                                                              'phoneNumber']);
                                                                    },
                                                                    icon: Icon(
                                                                      size: 17,
                                                                      Icons
                                                                          .call,
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
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  color: kColor,
                                                                  child:
                                                                      IconButton(
                                                                    onPressed:
                                                                        () {
                                                                      addFavourites(
                                                                          data.id);
                                                                    },
                                                                    icon: Icon(
                                                                      size: 17,
                                                                      Icons
                                                                          .favorite,
                                                                      color: isFavouriteCrop
                                                                          ? Colors
                                                                              .black
                                                                          : Colors
                                                                              .white,
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
                    ),
        ),
      ),
    );
  }
}
