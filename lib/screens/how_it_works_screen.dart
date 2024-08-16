import 'package:flutter/material.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:green_market_test/components/side_bar.dart';

void main() => runApp(const HowItWorks());

class HowItWorks extends StatelessWidget {
  const HowItWorks({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        drawer: const SideBar(),
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
                    icon: Icon(
                      Icons.list,
                      color: Colors.white,
                      size: 35,
                    ),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
            ),
            Positioned(
              top: 25,
              left: size.width * 0.31,
              right: size.width * 0.28,
              child: Text('How It Works',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)),
            ),
            Positioned(top: 100, left: 0, right: 0, child: MediaCard())
          ],
        ),
      ),
    );
  }
}

class MediaCard extends StatelessWidget {
  const MediaCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Card(
                elevation: 100,
                color: const Color.fromARGB(255, 255, 255, 255),
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  splashColor: Colors.green.withAlpha(100),
                  onTap: () {
                    debugPrint('Card tapped.');
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.90,
                    height: MediaQuery.of(context).size.height * 0.20,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Adjust the radius to your preference
                                  child: Image.asset(
                                    "assets/images/farmer.jpg",
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                    fit: BoxFit
                                        .cover, // Ensures the image fits well within the rounded corners
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                "  If you are a farmer",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          //crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.zero,
                              child: Image.asset(
                                "assets/images/watchnow.png",
                                height:
                                    MediaQuery.of(context).size.height * 0.12,
                                width: MediaQuery.of(context).size.width * 0.18,
                                alignment: AlignmentDirectional.bottomCenter,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),

              Card(
                elevation: 100,
                color: const Color.fromARGB(255, 255, 255, 255),
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  splashColor: Colors.green.withAlpha(100),
                  onTap: () {
                    debugPrint('Card tapped.');
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.90,
                    height: MediaQuery.of(context).size.height * 0.20,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Adjust the radius to your preference
                                  child: Image.asset(
                                    "assets/images/buyer.jpg",
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                    fit: BoxFit
                                        .cover, // Ensures the image fits well within the rounded corners
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                "  If you are a buyer",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Image.asset(
                                  "assets/images/watchnow.png",
                                  height:
                                      MediaQuery.of(context).size.height * 0.12,
                                  width:
                                      MediaQuery.of(context).size.width * 0.18,
                                  alignment: AlignmentDirectional.bottomCenter,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              //
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Card(
                elevation: 10,
                color: const Color.fromARGB(255, 255, 255, 255),
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  splashColor: Colors.green.withAlpha(100),
                  onTap: () {
                    debugPrint('Card tapped.');
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.90,
                    height: MediaQuery.of(context).size.height * 0.20,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Adjust the radius to your preference
                                  child: Image.asset(
                                    "assets/images/buyer.jpg",
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                    fit: BoxFit
                                        .cover, // Ensures the image fits well within the rounded corners
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                "  If you are a AI",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Image.asset(
                                  "assets/images/watchnow.png",
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  alignment: AlignmentDirectional.bottomCenter,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Card(
//   elevation: 10,
//   color: const Color.fromARGB(255, 255, 255, 255),
//   clipBehavior: Clip.hardEdge,
//   child: InkWell(
//     splashColor: Colors.blue.withAlpha(30),
//     onTap: () {
//       debugPrint('Card tapped.');
//     },
//     child: SizedBox(
//       width: MediaQuery.of(context).size.width * 0.90,
//       height: MediaQuery.of(context).size.height * 0.25,
//       child: Column(
//         children: [
//           Expanded(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: EdgeInsets.zero,
//                   child: Image.asset(
//                  "assets/images/buyer.jpg",
//                  height: MediaQuery.of(context).size.height * 0.1,
//                  fit: BoxFit.cover,  // Ensures the image fits well within the rounded corners
//          ),
//                 ),
//               ],
//             ),
//           ),

//          const Column(
//            mainAxisAlignment: MainAxisAlignment.center,
//            crossAxisAlignment: CrossAxisAlignment.start,
//            children: [
//              Padding(
//                padding: EdgeInsets.zero,
//                child: Text(
//                "If you are a farmer",
//                style: TextStyle(
//                  fontSize: 15,
//                  color: Colors.black,
//                  fontWeight: FontWeight.bold,
//                ),
//              ),
//              ),
//            ],
//          ),
//           Expanded(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.end,
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Padding(
//                   padding:EdgeInsets.zero,
//                   child: Image.asset(
//                     "assets/images/watchnow.png",
//                     height:
//                         MediaQuery.of(context).size.height * 0.15,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     ),
//   ),
// ),
