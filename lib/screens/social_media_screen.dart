import 'package:flutter/material.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:green_market_test/components/side_bar.dart';

void main() => runApp(const SocialMedia());

class SocialMedia extends StatelessWidget {
  const SocialMedia({super.key});

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
              left: size.width * 0.32,
              right: size.width * 0.28,
              child: Text('Social Media',
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
                elevation: 10,
                color: const Color.fromARGB(255, 24, 119, 242),
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () {
                    debugPrint('Card tapped.');
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.90,
                    height: MediaQuery.of(context).size.height * 0.175,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Icon(
                                  CommunityMaterialIcons.facebook,
                                  size:
                                      MediaQuery.of(context).size.height * 0.1,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Image.asset(
                                  "assets/images/facebook.png",
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
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
              Card(
                elevation: 10,
                color: const Color.fromARGB(255, 255, 0, 0),
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () {
                    debugPrint('Card tapped.');
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.90,
                    height: MediaQuery.of(context).size.height * 0.175,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Icon(
                                  CommunityMaterialIcons.youtube,
                                  size:
                                      MediaQuery.of(context).size.height * 0.1,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Image.asset(
                                  "assets/images/youtube.png",
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
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
              Card(
                elevation: 10,
                color: Colors.white,
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () {
                    debugPrint('Card tapped.');
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.175,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ShaderMask(
                                  shaderCallback: (Rect bounds) {
                                    return const LinearGradient(
                                      colors: [
                                        Color(0xFFF58529),
                                        Color(0xFFDD2A7B),
                                        Color(0xFF8134AF),
                                        Color(0xFF515BD4),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ).createShader(bounds);
                                  },
                                  child: Icon(
                                    CommunityMaterialIcons.instagram,
                                    size: MediaQuery.of(context).size.height *
                                        0.12,
                                    color: Colors
                                        .white, // This color will be overridden by the gradient
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Image.asset(
                                  "assets/images/instagram.png",
                                  height:
                                      MediaQuery.of(context).size.height * 0.12,
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
            ],
          ),
        ],
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:community_material_icon/community_material_icon.dart';


// /// Flutter code sample for [Card].

// void main() => runApp(const SocialMedia());

// class SocialMedia extends StatelessWidget {
//   const SocialMedia({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: const Text('Card Sample')),
//         body: const MediaCard(),
//       ),
//     );
//   }
// }

// class MediaCard extends StatelessWidget {
//   const MediaCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
      
//       child: Column(
//         children: [
          
//           Card(
//             color:Color.fromARGB(255, 24, 119, 242),
//             // clipBehavior is necessary because, without it, the InkWell's animation
//             // will extend beyond the rounded edges of the [Card] (see https://github.com/flutter/flutter/issues/109776)
//             // This comes with a small performance cost, and you should not set [clipBehavior]
//             // unless you need it.
//             clipBehavior: Clip.hardEdge,
//             child: InkWell(
//               splashColor: Colors.blue.withAlpha(30),
//               onTap: () {
//                 debugPrint('Card tapped.');
//               },
//               child:  SizedBox(
//                 width: MediaQuery.of(context).size.width * 0.90,
//                 height:MediaQuery.of(context).size.height * 0.20,
//                 child: const Icon(CommunityMaterialIcons.facebook, size: 70, color: Colors.white,),
                
//               ),
//             ),
//           ),
//          Card(
//         color: Color.fromARGB(255, 255, 0, 0),
//         // clipBehavior is necessary because, without it, the InkWell's animation
//         // will extend beyond the rounded edges of the [Card] (see https://github.com/flutter/flutter/issues/109776)
//         // This comes with a small performance cost, and you should not set [clipBehavior]
//         // unless you need it.
//         clipBehavior: Clip.hardEdge,
//         child: InkWell(
//           splashColor: Colors.blue.withAlpha(30),
//           onTap: () {
//             debugPrint('Card tapped.');
//           },
//           child:  SizedBox(
//             width: MediaQuery.of(context).size.width * 0.90,
//             height:MediaQuery.of(context).size.height * 0.20,
//             child: Text('A card that can be tapped'),
//           ),
//         ),
//       ),

//       Card(
//         color: Colors.white,
//         // clipBehavior is necessary because, without it, the InkWell's animation
//         // will extend beyond the rounded edges of the [Card] (see https://github.com/flutter/flutter/issues/109776)
//         // This comes with a small performance cost, and you should not set [clipBehavior]
//         // unless you need it.
//         clipBehavior: Clip.hardEdge,
//         child: InkWell(
//           splashColor: Colors.blue.withAlpha(30),
//           onTap: () {
//             debugPrint('Card tapped.');
//           },
//           child:  SizedBox(
//             width: MediaQuery.of(context).size.width * 0.90,
//             height:MediaQuery.of(context).size.height * 0.20,
//             child: Text('A card that can be tapped'),
//           ),
//         ),
//       ),
//         ],
//       ),

     
//     );
//   }
// }
