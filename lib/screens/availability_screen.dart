import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:green_market_test/components/availability_card.dart';
import 'package:green_market_test/components/side_bar.dart';

class AvailabilityScreen extends StatefulWidget {
  const AvailabilityScreen({super.key});

  @override
  State<AvailabilityScreen> createState() => _AvailabilityScreenState();
}

class _AvailabilityScreenState extends State<AvailabilityScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        drawer: SideBar(),
        body: Stack(
          children: [
            Positioned(
                top: -40, child: Image.asset('assets/images/appbar2.png')),
            Positioned(
              top: 15,
              left: 10,
              child: Builder(
                builder: (context) {
                  return IconButton(
                    icon: Icon(Icons.list, color: Colors.white, size: 35),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
            ),
            Positioned(
              top: 25,
              left: size.width * 0.35,
              right: size.width * 0.3,
              child: Text(
                'Availability',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
            Positioned(
              top: 120,
              left: 0,
              right: 0,
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('crops').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  // Process the data to aggregate weight and districts by crop name
                  Map<String, Map<String, dynamic>> cropData = {};

                  for (var doc in snapshot.data!.docs) {
                    String cropName = doc['cropType'];
                    String district = doc['district'];
                    double weight = double.parse(doc['weight']);

                    if (!cropData.containsKey(cropName)) {
                      cropData[cropName] = {
                        'totalWeight': 0.0,
                        'locations': <String>[],
                      };
                    }

                    cropData[cropName]!['totalWeight'] += weight;
                    if (!cropData[cropName]!['locations'].contains(district)) {
                      cropData[cropName]!['locations'].add(district);
                    }
                  }

                  return Column(
                    children: cropData.keys.map((cropName) {
                      String totalWeight =
                          cropData[cropName]!['totalWeight'].toString();
                      String locations =
                          cropData[cropName]!['locations'].join(', ');

                      return AvailabilityCard(
                        cropName: cropName,
                        totalWeight: totalWeight,
                        location: locations,
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
