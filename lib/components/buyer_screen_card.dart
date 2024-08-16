import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:green_market_test/components/constants.dart';
import 'package:intl/intl.dart';

class BuyerScreenCard extends StatelessWidget {
  final String cropType;
  final String farmerName;
  final String district;
  final String weight;
  final String expiringDate;
  final String price;

  const BuyerScreenCard({
    Key? key,
    required this.cropType,
    required this.farmerName,
    required this.district,
    required this.weight,
    required this.expiringDate,
    required this.price,
  }) : super(key: key);
  // String _formatTimestamp(Timestamp timestamp) {
  //   DateTime dateTime = timestamp.toDate();
  //   return DateFormat('yyyy-MM-dd').format(dateTime);
  // }

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
        height: size.height * 0.15,
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: size.width * 0.8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Text(
                              '$cropType',
                              style: TextStyle(
                                  color: Color(0xFF222325),
                                  fontSize: size.height * 0.0175,
                                  fontWeight: FontWeight.w700),
                            ),
                            Spacer(),
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
                                  '$district',
                                  style: TextStyle(
                                      color: kColor4,
                                      fontSize: size.height * 0.015,
                                      fontWeight: FontWeight.w600),
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
                            '$farmerName',
                            style: TextStyle(
                              color: Color(0xFF222325),
                              fontSize: size.height * 0.0175,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Weight :',
                                      style: TextStyle(
                                          color: kColor4,
                                          fontSize: size.height * 0.015,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      '$weight Kg',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: size.height * 0.015,
                                          color: Color(0xFF222325)),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Expire Date :',
                                      style: TextStyle(
                                          color: kColor4,
                                          fontSize: size.height * 0.015,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      expiringDate,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: size.height * 0.015,
                                          color: Color(0xFF222325)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // Spacer(),
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

                            // isRequireFavourite
                            //     ? Container()
                            //     : ClipRRect(
                            //         borderRadius: BorderRadius.circular(10),
                            //         child: Container(
                            //           padding: EdgeInsets.zero,
                            //           color: kColor,
                            //           child: IconButton(
                            //             onPressed: () {
                            //               addFavourites(data.id);
                            //             },
                            //             icon: Icon(
                            //               size: 17,
                            //               Icons.favorite,
                            //               color: Colors.white,
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            // SizedBox(
                            //   width: 10,
                            // ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                padding: EdgeInsets.zero,
                                color: kColor,
                                child: IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    size: 17,
                                    Icons.call,
                                    color: Colors.white,
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
    );
  }
}
