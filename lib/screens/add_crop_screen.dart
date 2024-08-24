import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:green_market_test/components/bottom_bar.dart';
import 'package:green_market_test/components/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:green_market_test/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

late User? loggedInUser;

class AddCropScreen extends StatefulWidget {
  const AddCropScreen({super.key});

  @override
  State<AddCropScreen> createState() => _AddCropScreenState();
}

class _AddCropScreenState extends State<AddCropScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _farmerName;
  String? _district;
  String? _address;
  String? _phoneNumber;
  String? _cultivatedArea;
  String? _cropType;
  String? _farmerType;
  String? _weight;
  DateTime? _availableDate;
  DateTime? _expiringDate;
  String? _price;
  File? _image;
  final _auth = FirebaseAuth.instance;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  final CollectionReference cropsCollection =
      FirebaseFirestore.instance.collection('crops');

  Future<void> getUserData() async {
    loggedInUser = await _auth.currentUser!;
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(loggedInUser?.email)
        .get();

    setState(() {
      _farmerName = userSnapshot['displayName'].toString();
    });
  }

  Future<void> _selectDate(BuildContext context, bool isAvailableDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        if (isAvailableDate) {
          _availableDate = picked;
        } else {
          _expiringDate = picked;
        }
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        // _images.add(File(pickedFile.path));
        _image = File(pickedFile.path);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      // _images.removeAt(index);
      _image = null;
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_district == null ||
          _address == null ||
          _phoneNumber == null ||
          _availableDate == null ||
          _expiringDate == null ||
          _cultivatedArea == null ||
          _cropType == null ||
          _weight == null ||
          _farmerType == null ||
          _price == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Please fill all fields'),
            backgroundColor: Colors.red));
        return;
      }

      try {
        // List imagesUrls = [];

        // for (var image in _images) {
        //   var imageName = DateTime.now().millisecondsSinceEpoch.toString();
        //   var storageRef =
        //       FirebaseStorage.instance.ref().child('$imageName.jpg');
        //   var uploadTask = storageRef.putFile(image!);
        //   var downloadUrl = await (await uploadTask).ref.getDownloadURL();
        //   imagesUrls.add(downloadUrl);
        // }

        var imageName = DateTime.now().millisecondsSinceEpoch.toString();
        var storageRef = FirebaseStorage.instance.ref().child('$imageName.jpg');
        var uploadTask = storageRef.putFile(_image!);
        var downloadUrl = await (await uploadTask).ref.getDownloadURL();

        await cropsCollection.add({
          'userId': loggedInUser?.uid,
          'farmerName': _farmerName,
          'district': _district,
          'address': _address,
          'phoneNumber': _phoneNumber,
          'cultivatedArea': _cultivatedArea,
          'cropType': _cropType,
          'farmerType': _farmerType,
          'weight': _weight,
          'availableDate': _availableDate,
          'expiringDate': _expiringDate,
          'price': _price,
          'isAccepted': false,
          'isDeleted': false,
          'isExpired': false,
          'images': downloadUrl,
        });
Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => BottomBarScreen()),
      (Route<dynamic> route) => false,
    );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to add crop: $error'),
            backgroundColor: Colors.red));
      }
    }
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
                    //   decoration: InputDecoration(labelText: "Farmer's Name"),
                    //   onSaved: (value) {
                    //     _farmerName = value;
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
                    ),
                    SizedBox(height: size.height * 0.02),
                    TextFormField(
                      style: TextStyle(fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                          labelStyle: TextStyle(
                            color: kColor4,
                            fontSize: size.height * 0.02,
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          labelText: 'Address',
                          hintText: 'Eg: No, Street, City',
                          
                          hintStyle: TextStyle(
                              color: const Color.fromRGBO(158, 158, 158, 1),
                              fontWeight: FontWeight.normal),
                          suffixIcon: Icon(
                            Icons.location_on,
                            size: size.height * 0.025,
                            color: kColor4,
                          )),
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
                                prefixText: '+94 ',
                                prefixStyle:
                                    TextStyle(fontWeight: FontWeight.w500),
                                hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.normal),
                                hintText: 'XX XXX XXX'),
                            style: TextStyle(fontWeight: FontWeight.w500),
                            onSaved: (value) {
                              _phoneNumber = value;
                            },
                          ),
                        ),
                        SizedBox(width: size.width * 0.04),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                                labelText: 'Crop Type',
                                labelStyle: TextStyle(
                                  fontSize: size.height * 0.02,
                                  color: kColor4,
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
                            items: cropTypes.map((String crop) {
                              return DropdownMenuItem<String>(
                                value: crop,
                                child: Text('$crop',
                                    style: TextStyle(fontSize: 16)),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _cropType = value;
                              });
                            },
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
                          ),
                        ),
                        SizedBox(width: size.width * 0.04),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                                labelText: 'Single/Group',
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
                            items: groupType.map((String type) {
                              return DropdownMenuItem<String>(
                                value: type,
                                child:
                                    Text(type, style: TextStyle(fontSize: 16)),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _farmerType = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.02),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _selectDate(context, true),
                            child: AbsorbPointer(
                              child: TextFormField(
                                decoration: InputDecoration(
                                    labelText: 'Available Date',
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
                                  text: _availableDate == null
                                      ? ''
                                      : _availableDate
                                          ?.toLocal()
                                          .toIso8601String()
                                          .substring(0, 10),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: size.width * 0.04),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _selectDate(context, false),
                            child: AbsorbPointer(
                              child: TextFormField(
                                decoration: InputDecoration(
                                    labelText: 'Expiring Date',
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
                                    text: _expiringDate == null
                                        ? ''
                                        : _expiringDate
                                            ?.toLocal()
                                            .toIso8601String()
                                            .substring(0, 10)),
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
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Price',
                                prefixText: 'Rs. ',
                                labelStyle: TextStyle(
                                  color: kColor4,
                                  fontSize: size.height * 0.02,
                                ),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black))),
                            style: TextStyle(fontWeight: FontWeight.w500),
                            onSaved: (value) {
                              _price = value;
                            },
                          ),
                        ),
                        SizedBox(width: size.width * 0.04),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Cultivated Area',
                                suffixText: 'ha',
                                labelStyle: TextStyle(
                                  color: kColor4,
                                  fontSize: size.height * 0.02,
                                ),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black))),
                            style: TextStyle(fontWeight: FontWeight.w500),
                            onSaved: (value) {
                              _cultivatedArea = value;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.02),
                    GestureDetector(
                      onTap: _image != null ? null : _pickImage,
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: InputDecoration(
                              labelStyle: TextStyle(
                                color: kColor4,
                                fontSize: size.height * 0.02,
                              ),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              labelText: _image == null
                                  ? 'Tap to Upload Image'
                                  : 'Image is Uploaded',
                              suffixIcon: Icon(
                                Icons.filter,
                                size: size.height * 0.025,
                                color: kColor4,
                              )),
                          style: TextStyle(fontWeight: FontWeight.w500),
                          // validator: (_) {
                          //   if (_images.isEmpty) {
                          //     return 'Please add an image';
                          //   }
                          //   return null;
                          // },
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10,
                      children: _image == null
                          ? []
                          : [
                              _image!,
                            ].asMap().entries.map((entry) {
                              int index = entry.key;
                              File imageFile = entry.value;
                              return Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Image.file(imageFile,
                                      width: size.width * 0.5,
                                      height: size.width * 0.5,
                                      fit: BoxFit.contain),
                                  IconButton(
                                    icon: Icon(Icons.cancel, color: kColor),
                                    onPressed: () => _removeImage(index),
                                  ),
                                ],
                              );
                            }).toList(),
                    ),
                    SizedBox(height: size.height * 0.03),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Color.fromARGB(255, 168, 165, 165)),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        ElevatedButton(
                          onPressed: _submitForm,
                          child: Text(
                            'Post',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kColor,
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        )
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
              left: size.width * 0.35,
              right: size.width * 0.3,
              child: Text('Add Crop',
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
