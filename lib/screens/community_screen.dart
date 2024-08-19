import 'package:flutter/material.dart';
import 'package:green_market_test/components/constants.dart';
import 'package:green_market_test/components/side_bar.dart';
import 'package:green_market_test/screens/favourites_screen.dart';
import 'package:green_market_test/screens/profile_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  void openWhatsApp() async {
    const whatsappUrl = "https://chat.whatsapp.com/I87TEfWtsQmGTqcBmlS1iW.";
    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      print("Could not open WhatsApp");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const SideBar(),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 60,
          title: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  Builder(
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
                  ),
                  Expanded(child: Container()),
                  IconButton(
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
                  ),
                  IconButton(
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
                ],
              ),
            ),
          ),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.18),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width * 0.55,
                child: Image.asset("assets/images/whatsapp.png"),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.001),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: openWhatsApp,
                    // icon:const FaIcon(FontAwesomeIcons.whatsapp),
                    label: const Text(
                      'Join our community',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kColor,
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






// import 'package:flutter/material.dart';
// import 'package:green_market_test/components/constants.dart';
// import 'package:green_market_test/components/side_bar.dart';
// import 'package:green_market_test/screens/favourites_screen.dart';
// import 'package:green_market_test/screens/profile_screen.dart';

// class CommunityScreen extends StatelessWidget {
//   const CommunityScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         drawer: const SideBar(),
//         appBar: AppBar(
//           automaticallyImplyLeading: false,
//           toolbarHeight: 60,
//           title: GestureDetector(
//             onTap: () {
//               FocusScope.of(context).requestFocus(FocusNode());
//             },
//             child: Container(
//               padding: EdgeInsets.only(top: 10),
//               child: Row(
//                 children: [
//                   Builder(
//                     builder: (context) {
//                       return IconButton(
//                         icon: Icon(
//                           Icons.list,
//                           color: Colors.black,
//                           size: 35,
//                         ),
//                         onPressed: () {
//                           Scaffold.of(context).openDrawer();
//                         },
//                       );
//                     },
//                   ),
//                   Expanded(child: Container()),
//                   IconButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => FavouritesScreen()),
//                       );
//                     },
//                     icon: Icon(
//                       Icons.favorite,
//                       color: Colors.black,
//                       size: 30,
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => ProfileScreen()),
//                       );
//                     },
//                     icon: Icon(
//                       Icons.person,
//                       color: Colors.black,
//                       size: 30,
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//         body: Center(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               SizedBox(height: MediaQuery.of(context).size.height * 0.18),
//               SizedBox(
//                 height: MediaQuery.of(context).size.height * 0.2,
//                 width: MediaQuery.of(context).size.width * 0.55,
//                 child: Image.asset("assets/images/whatsapp.png"),
//               ),
//               SizedBox(height: MediaQuery.of(context).size.height * 0.001),
//               ButtonBar(
//                 alignment: MainAxisAlignment.center,
//                 children: [
//                   ElevatedButton.icon(
//                     onPressed: () {},
//                     label: const Text(
//                       'Join our community',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: kColor,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }








// class CommunityScreen extends StatefulWidget {
//   const CommunityScreen({super.key});

//   @override
//   State<CommunityScreen> createState() => _CommunityScreenState();
// }

// class _CommunityScreenState extends State<CommunityScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         drawer: const SideBar(),
//         appBar: AppBar(
//           title: const Text('Community '),
//           backgroundColor: Color.fromARGB(255, 12, 231, 99),
//         ),
//         body: Text("Community Screen"),
//       ),
//     );
//   }
// }