import 'package:flutter/material.dart';

class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/images/car-hero.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Dark overlay
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(.9)
                    ]
                )
            ),
          ),
          // Content
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Text('TireApp',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        color: Colors.white, // Ensure the text is visible on dark background
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                        top: 6,
                        bottom: 24,
                        left: 4,
                        right: 16
                    ),
                    child: Text(
                      'Your comprehensive solution for managing tire maintenance, tracking tire performance, and ensuring your vehicle runs smoothly and safely.',
                      style: TextStyle(
                        color: Colors.white, // Ensure the text is visible on dark background
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/homepage');
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: nissanRed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
                      ),// Button text color
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                      child: Text('Get Started'),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text(
    //       'TireApp',
    //       style: TextStyle(color: Colors.white),
    //     ),
    //     backgroundColor: nissanRed, // App bar color
    //   ),
    //   body: Center(
    //     child: SingleChildScrollView(
    //
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: <Widget>[
    //           // Logo
    //           Padding(
    //             padding: const EdgeInsets.all(8.0),
    //             child: Image.asset(
    //               'lib/assets/images/defaultTireImage.png', // Path to your logo
    //               height: 100,
    //             ),
    //           ),
    //           SizedBox(height: 20),
    //           // Title
    //           Text(
    //             'Welcome to TireApp',
    //             style: Theme.of(context)
    //                 .textTheme
    //                 .headlineMedium
    //                 ?.copyWith(color: nissanRed),
    //           ),
    //           SizedBox(height: 20),
    //           // Introduction
    //           Padding(
    //             padding: const EdgeInsets.symmetric(horizontal: 16.0),
    //             child: Text(
    //               'Your one-stop solution for managing tire maintenance and tracking tire performance.',
    //               textAlign: TextAlign.center,
    //               style: Theme.of(context).textTheme.titleMedium,
    //             ),
    //           ),
    //           SizedBox(height: 40),
    //           // Features
    //
    //           ElevatedButton(
    //             style: ElevatedButton.styleFrom(
    //               backgroundColor: nissanRed, // Button background color
    //             ),
    //             onPressed: () {
    //               Navigator.pushReplacementNamed(
    //                 context,
    //                 '/homepage',
    //               );
    //             },
    //             child: Text(
    //               'Get Started',
    //               style: TextStyle(color: Colors.white),
    //             ),
    //           ),
    //           SizedBox(height: 20),
    //           // Footer
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}

// Define the Nissan red color
const Color nissanRed = Color(0xFFE60012);
