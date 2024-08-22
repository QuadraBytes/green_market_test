import 'package:flutter/material.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:green_market_test/components/side_bar.dart';
import 'package:url_launcher/url_launcher.dart';

void openInstagram() async {
  final Uri instagramUrl =
      Uri.parse('instagram://user?username=green_market_test_fv');
  final Uri fallbackUrl = Uri.parse(
      'https://www.instagram.com/green_market_test_fv?igsh=MXU0emVjNHNjcTF4eg==');

  if (await canLaunchUrl(instagramUrl)) {
    await launchUrl(instagramUrl);
  } else {
    await launchUrl(fallbackUrl);
  }
}

void openFacebook() async {
  final Uri facebookUrl = Uri.parse('fb://profile/61560841509355');
  final Uri fallbackUrl = Uri.parse(
      'https://www.facebook.com/profile.php?id=61560841509355&mibextid=JRoKGi');

  if (await canLaunchUrl(facebookUrl)) {
    await launchUrl(facebookUrl);
  } else {
    await launchUrl(fallbackUrl);
  }
}

void openYouTube() async {
  final Uri youtubeUrl =
      Uri.parse('vnd.youtube://www.youtube.com/channel/@GreenMarket-fv');
  final Uri fallbackUrl = Uri.parse('https://www.youtube.com/@GreenMarket-fv');

  if (await canLaunchUrl(youtubeUrl)) {
    await launchUrl(youtubeUrl);
  } else {
    await launchUrl(fallbackUrl);
  }
}

void openLinkedIn() async {
  final Uri linkedInUrl =
      Uri.parse('linkedin://linkedin.com/company/green-market-fv');
  final Uri fallbackUrlLinkedIn =
      Uri.parse('https://www.linkedin.com/company/green-market-fv');

  if (await canLaunchUrl(linkedInUrl)) {
    await launchUrl(linkedInUrl);
  } else {
    await launchUrl(fallbackUrlLinkedIn);
  }
}

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
                    icon: const Icon(
                      Icons.list,
                      color: Colors.white,
                      size: 30,
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
            const Positioned(top: 100, left: 0, right: 0, child: MediaCard())
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
