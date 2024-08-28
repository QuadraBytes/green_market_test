import 'package:flutter/material.dart';
import 'package:green_market_test/components/constants.dart';
import 'package:green_market_test/components/side_bar.dart';
import 'package:green_market_test/screens/favourites_screen.dart';
import 'package:green_market_test/screens/profile_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  // void openWhatsApp() async {
  //   const whatsappUrl = "https://chat.whatsapp.com/I87TEfWtsQmGTqcBmlS1iW.";
  //   if (await canLaunch(whatsappUrl)) {
  //     await launch(whatsappUrl);
  //   } else {
  //     print("Could not open WhatsApp");
  //   }
  // }

  void openWhatsApp() async {
  final Uri whatsappUrl = Uri.parse("https://chat.whatsapp.com/I87TEfWtsQmGTqcBmlS1iW");
  if (await canLaunch(whatsappUrl.toString())) {
    await launch(whatsappUrl.toString());
  } else {
    print("Could not open WhatsApp");
  }
}
    const String whatsappUrl = "https://chat.whatsapp.com/I87TEfWtsQmGTqcBmlS1iW";
    final Uri uri = Uri.parse(whatsappUrl);

    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
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
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  Builder(
                    builder: (context) {
                      return IconButton(
                        icon: const Icon(
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
                            builder: (context) => const FavouritesScreen()),
                      );
                    },
                    icon: const Icon(
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
                            builder: (context) => const ProfileScreen()),
                      );
                    },
                    icon: const Icon(
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
                    icon: const FaIcon(FontAwesomeIcons.whatsapp),
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
// import 'package:url_launcher/url_launcher.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// class CommunityScreen extends StatelessWidget {
//   const CommunityScreen({super.key});

//   void openWhatsApp() async {
//     const whatsappUrl = "https://chat.whatsapp.com/I87TEfWtsQmGTqcBmlS1iW.";
//     if (await canLaunch(whatsappUrl)) {
//       await launch(whatsappUrl);
//     } else {
//       print("Could not open WhatsApp");
//     }
//   }

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
//                           size: 30,
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
//                       size: 25,
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
//                       size: 25,
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
//                     onPressed: openWhatsApp,
//                     // icon:const FaIcon(FontAwesomeIcons.whatsapp),
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






