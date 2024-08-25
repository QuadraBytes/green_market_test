import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:green_market_test/components/bottom_bar.dart';
import 'package:green_market_test/components/constants.dart';
import 'package:green_market_test/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

late User? loggedInUser;

class AddRequirementScreen extends StatefulWidget {
  const AddRequirementScreen({super.key});

  @override
  State<AddRequirementScreen> createState() => _AddRequirementScreenState();
}

class _AddRequirementScreenState extends State<AddRequirementScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _buyerName;
  String? _district;
  String? _address;
  String? _phoneNumber;
  String? _cropType;
  String? _weight;
  DateTime? _requiredDate;
  final _auth = FirebaseAuth.instance;

  final CollectionReference requirements =
      FirebaseFirestore.instance.collection('requirements');

  Future<void> getUserData() async {
    loggedInUser = await _auth.currentUser!;
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(loggedInUser?.email)
        .get();

    setState(() {
      _buyerName = userSnapshot['displayName'].toString();
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _requiredDate = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_district == null ||
          _address == null ||
          _phoneNumber == null ||
          _requiredDate == null ||
          _cropType == null ||
          _weight == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Please fill all fields'),
            backgroundColor: Colors.red));
        return;
      }

      try {
        await requirements.add({
          'userId': loggedInUser!.uid,
          'buyerName': _buyerName,
          'district': _district,
          'address': _address,
          'phoneNumber': _phoneNumber,
          'cropType': _cropType,
          'weight': _weight,
          'requiredDate': _requiredDate,
          'isAccepted': false,
          'isDeleted': false,
          'isExpired': false,
        });

      Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => BottomBarScreen()),
      (Route<dynamic> route) => false,
    );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add requirement: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

    void showCropTypes() {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                bottom: const TabBar(
                  tabs: [
                    Tab(text: 'Vegetables'),
                    Tab(text: 'Fruits'),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  Container(
                    color: Colors.white, // Background color for Vegetables
                    child: ListView.builder(
                      itemCount: vegetables.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(
                            vegetables[index],
                            style: TextStyle(fontSize: 16),
                          ),
                          onTap: () {
                            setState(() {
                              _cropType = vegetables[index];
                            });
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                  Container(
                    color: Colors.white, // Background color for Fruits
                    child: ListView.builder(
                      itemCount: fruits.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(
                            fruits[index],
                            style: TextStyle(fontSize: 16),
                          ),
                          onTap: () {
                            setState(() {
                              _cropType = fruits[index];
                              //  _cropTypeController.text = _cropType; // Update the TextFormField
                            });
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    SizedBox(
                      height: 100,
                    ),
                    // TextFormField(
                    //   style: TextStyle(fontWeight: FontWeight.w500),
                    //   decoration: InputDecoration(labelText: "Buyer's Name"),
                    //   // validator: (value) {
                    //   //   if (value == null || value.isEmpty) {
                    //   //     return "Please enter buyer's name";
                    //   //   }
                    //   //   return null;
                    //   // },
                    //   onSaved: (value) {
                    //     _buyerName = value;
                    //   },
                    // ),
                    // SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      menuMaxHeight: MediaQuery.of(context).size.height * 0.3,
                      decoration: InputDecoration(
                          labelText: 'District',
                          labelStyle: TextStyle(
                            color: kColor4,
                            fontSize: size.height * 0.02,
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black))),
                      icon: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(
                          Icons.keyboard_arrow_down_outlined,
                          size: size.height * 0.035,
                          color: kColor4,
                        ),
                      ),
                      items: districts.map((String district) {
                        return DropdownMenuItem<String>(
                          value: district,
                          child: Text(district),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _district = value;
                        });
                      },
                      // validator: (value) {
                      //   if (value == null) {
                      //     return 'Please select a district';
                      //   }
                      //   return null;
                      // },
                    ),
                    SizedBox(height: size.height * 0.02),
                    TextFormField(
                      style: TextStyle(fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                          labelText: 'Address',
                          labelStyle: TextStyle(
                            color: kColor4,
                            fontSize: size.height * 0.02,
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          hintText: 'Eg: No, Street, City',
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.normal),
                          suffixIcon: Icon(
                            Icons.location_on,
                            size: size.height * 0.025,
                            color: kColor4,
                          )),
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return 'Please enter address';
                      //   }
                      //   return null;
                      // },
                      onSaved: (value) {
                        _address = value;
                      },
                    ),
                    SizedBox(height: size.height * 0.02),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Phone Number',
                                prefixText: '+94 ',
                                suffixIcon: Icon(
                                  Icons.phone,
                                  size: size.height * 0.025,
                                  color: kColor4,
                                ),
                                labelStyle: TextStyle(
                                  color: kColor4,
                                  fontSize: size.height * 0.02,
                                ),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                                prefixStyle:
                                    TextStyle(fontWeight: FontWeight.w500),
                                hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.normal),
                                hintText: 'XX XXX XXX'),
                            style: TextStyle(fontWeight: FontWeight.w500),
                            // validator: (value) {
                            //   if (value == null || value.isEmpty) {
                            //     return 'Please enter phone number';
                            //   }
                            //   return null;
                            // },
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter
                                  .digitsOnly, // Only allow digits
                            ],
                            onSaved: (value) {
                              _phoneNumber = value;
                            },
                          ),
                        ),
                        SizedBox(width: size.width * 0.04),
                       Expanded(
                          child: GestureDetector(
                            onTap: showCropTypes,
                            child: AbsorbPointer(
                              child: TextFormField(
                                decoration: InputDecoration(
                                    labelText: 'Crop Type',
                                    labelStyle: TextStyle(
                                      color: kColor4,
                                      fontSize: size.height * 0.02,
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black)),
                                    suffixIcon: Icon(
                                      Icons.keyboard_arrow_down_outlined,
                                      size: size.height * 0.025,
                                      color: kColor4,
                                    )),
                                controller: TextEditingController(
                                  text: _cropType == null
                                      ? ''
                                      : _cropType.toString(),
                                          
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.02),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                                labelText: 'Weight',
                                labelStyle: TextStyle(
                                  color: kColor4,
                                  fontSize: size.height * 0.02,
                                ),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black))),
                            icon: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.keyboard_arrow_down_outlined,
                                size: size.height * 0.025,
                                color: kColor4,
                              ),
                            ),
                            items: weightRange.map((String weight) {
                              return DropdownMenuItem<String>(
                                value: weight,
                                child: Text('$weight kg',
                                    style: TextStyle(fontSize: 16)),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _weight = value;
                              });
                            },
                            // validator: (value) {
                            //   if (value == null) {
                            //     return 'Please select a weight';
                            //   }
                            //   return null;
                            // },
                          ),
                        ),
                        SizedBox(width: size.width * 0.04),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _selectDate(context),
                            child: AbsorbPointer(
                              child: TextFormField(
                                decoration: InputDecoration(
                                    labelText: 'Required Date',
                                    labelStyle: TextStyle(
                                      color: kColor4,
                                      fontSize: size.height * 0.02,
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black)),
                                    suffixIcon: Icon(
                                      Icons.calendar_today,
                                      size: size.height * 0.025,
                                      color: kColor4,
                                    )),
                                controller: TextEditingController(
                                    text: _requiredDate == null
                                        ? ''
                                        : _requiredDate
                                            ?.toLocal()
                                            .toIso8601String()
                                            .substring(0, 10)),
                                // validator: (value) {
                                //   if (_requiredDate == null) {
                                //     return 'Please select the required date';
                                //   }
                                //   return null;
                                // },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.04),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Color.fromARGB(255, 168, 165, 165)),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _submitForm();
                          },
                          child: Text(
                            'Post',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kColor,
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
                top: -50, child: Image.asset('assets/images/appbar2.png')),
            Positioned(
              top: 25,
              left: size.width * 0.22,
              right: size.width * 0.2,
              child: Text('Add Requiremenets',
                  style: TextStyle(
                      fontSize: size.height * 0.03,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)),
            ),
            Positioned(
                top: 15,
                left: 10,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )),
          ],
        ),
      ),
    );
  }
}
