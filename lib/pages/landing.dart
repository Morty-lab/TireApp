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
        title: Text('Welcome to Our App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to Our Mobile App',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 20), // Space between title and subtitle
            Text(
              'Let\'s get started!',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 40), // Space between subtitle and button
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(
                  context,
                  '/homepage',
                );
              },
              child: Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
