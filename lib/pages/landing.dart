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
      appBar: AppBar(
        title: Text(
          'TireApp',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: nissanRed, // App bar color
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Logo
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'lib/assets/images/defaultTireImage.png', // Path to your logo
                  height: 100,
                ),
              ),
              SizedBox(height: 20),
              // Title
              Text(
                'Welcome to TireApp',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: nissanRed),
              ),
              SizedBox(height: 20),
              // Introduction
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Your one-stop solution for managing tire maintenance and tracking tire performance.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              SizedBox(height: 40),
              // Features

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: nissanRed, // Button background color
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(
                    context,
                    '/homepage',
                  );
                },
                child: Text(
                  'Get Started',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              // Footer
            ],
          ),
        ),
      ),
    );
  }
}

// Define the Nissan red color
const Color nissanRed = Color(0xFFE60012);
