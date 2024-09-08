import 'package:flutter/material.dart';
import 'package:green_market_test/components/constants.dart';

class AvailabilityCard extends StatelessWidget {
  final String cropName;
  final String totalWeight;
  final String location;

  const AvailabilityCard(
      {Key? key,
      required this.cropName,
      required this.location,
      required this.totalWeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      margin: EdgeInsets.only(bottom: 10.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        color: kColor2,
        child: Container(
          height: size.height * 0.115,
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ' $cropName',
                    style: TextStyle(
                        color: Color(0xFF222325),
                        fontSize: size.height * 0.0175,
                        fontWeight: FontWeight.w700),
                  ),
                  Spacer(),
                  Container(
                    child: Text(
                      ' $totalWeight Kg',
                      style: TextStyle(
                        color: Color(0xFF222325),
                        fontSize: size.height * 0.0175,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.red,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    child: Text(
                      '$location',
                      style: TextStyle(
                        color: Color(0xFF222325),
                        fontSize: size.height * 0.0175,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
