import 'package:flutter/material.dart';
import 'package:green_market_test/components/bottom_bar.dart';
import 'package:green_market_test/screens/availability_screen.dart';
import 'package:green_market_test/screens/how_it_works_screen.dart';
import 'package:green_market_test/screens/social_media_screen.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Drawer(
      width: size.width * 0.6,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            // decoration: BoxDecoration(
            //   color: Colors.white,
            // ),
            child: ClipOval(
              child: Image.asset(
                "assets/images/logo.png",
                fit: BoxFit.contain,
                width: size.width * 0.4,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BottomBarScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Social Media'),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const SocialMedia()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('How It Works'),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const HowItWorks()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.local_shipping_sharp),
            title: const Text('Available Supply'),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AvailabilityScreen()));
            },
          ),
        ],
      ),
    );
  }
}


// import 'package:flutter/material.dart';

// class SideBar extends StatelessWidget {
//   const SideBar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//   appBar: AppBar(
    
//     leading: Builder(
//       builder: (context) {
//         return IconButton(
//           icon: const Icon(Icons.menu),
//           onPressed: () {
//             Scaffold.of(context).openDrawer();
//           },
//         );
//       },
//     ),
//   ),
//   drawer: Drawer(
  
//   child: ListView(
    
//     padding: EdgeInsets.zero,
//     children: [
//       const DrawerHeader(
//         decoration: BoxDecoration(
//           color: Color.fromARGB(255, 64, 204, 113),
//         ),
//         child: Text('Green Market'),
//       ),
//       ListTile(
//         leading: Icon(Icons.home),
//         title: const Text('Home'),
//         onTap: () {
       
//         },
//       ),
//       ListTile(
//         leading:Icon(Icons.language),
//         title: const Text('Social Media'),
//         onTap: () {
         
//         },
//       ),

//       ListTile(
//         leading: Icon(Icons.info),
//         title: const Text('How It Works'),
//         onTap: () {
         
//         },
//       ),
//       ListTile(
//         leading: Icon(Icons.local_shipping_sharp),
//         title: const Text('Available Supply'),
//         onTap: () {
        

//         },
//       ),
//     ],
//   ),
// ),
// );
//   }
// }
