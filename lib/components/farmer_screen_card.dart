import 'package:flutter/material.dart';
import 'package:green_market_test/components/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class FarmerScreenCard extends StatelessWidget {
  final String cropType;
  final String buyerName;
  final String district;
  final String weight;
  final String requiredDate;
  final String phoneNumber;

  const FarmerScreenCard({
    Key? key,
    required this.cropType,
    required this.buyerName,
    required this.district,
    required this.weight,
    required this.requiredDate,
    required this.phoneNumber,
  }) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: kColor2,
      child: Container(
        height: size.height * 0.20,
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image(
                        width: size.width * 0.3,
                        height: size.height * 0.125,
                        fit: BoxFit.cover,
                        image: AssetImage("assets/images/crop.jpg"),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Crop Name : $cropType',
                      style: TextStyle(
                          color: Color(0xFF222325),
                          fontSize: size.height * 0.0175,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Buyer Name : $buyerName',
                          style: TextStyle(
                            color: Color(0xFF222325),
                            fontSize: size.height * 0.0175,
                          ),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          'District : $district',
                          style: TextStyle(
                              color: Color(0xFF072471),
                              fontSize: size.height * 0.015,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          'Weight : $weight Kg',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: size.height * 0.015,
                              color: Color(0xFF222325)),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          'Phone Number : $phoneNumber',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: size.height * 0.015,
                              color: Color(0xFF222325)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      padding: EdgeInsets.zero,
                                      color: kColor,
                                      child: IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          size: 17,
                                          Icons.chat_bubble,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      padding: EdgeInsets.zero,
                                      color: kColor,
                                      child: IconButton(
                                        onPressed: () =>
                                            _makePhoneCall(phoneNumber),
                                        icon: Icon(
                                          size: 17,
                                          Icons.call,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      padding: EdgeInsets.zero,
                                      color: kColor,
                                      child: IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          size: 17,
                                          Icons.favorite,
                                          color: Colors.white,
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
    );
  }
}
