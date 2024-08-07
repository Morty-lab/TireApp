import 'package:app/pages/homepage.dart';
import 'package:app/pages/landing.dart';
import 'package:app/pages/onBoarding.dart';
import 'package:app/pages/tire.dart';
import 'package:app/themes/theme.dart';
import 'package:app/widgets/fade_animation.dart';
import 'package:flutter/material.dart';

import 'models/OnboardingModel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => Onboarding(
              pages: [
                OnBoardingModel(
                  title: 'Welcome to Tire Shop',
                  description:
                      'Your one-stop solution for all your tire needs. Get ready for a smooth ride!',
                  imageUrl: 'lib/assets/images/car-1.png',
                  bgColor: const Color(0xffc24b23),
                ),
                OnBoardingModel(
                  title: 'Explore Our Wide Range',
                  description: 'Browse through a variety of tire brands and types suitable for your vehicle.',
                  imageUrl: 'lib/assets/images/tire-1.png',
                  bgColor: const Color(0xffc26023),
                ),
                OnBoardingModel(
                  title: 'Schedule Services Easily',
                  description:
                      'Book tire installation, balancing, and other services right from the app.',
                  imageUrl: 'lib/assets/images/tire-2.png',
                  bgColor: const Color(0xffc24b23),
                ),
                OnBoardingModel(
                  title: 'Ready to Roll?',
                  description:
                      "Let's get started! Your smooth ride is just a few taps away.",
                  imageUrl: 'lib/assets/images/car-2.png',
                  bgColor: const Color(0xffc2a223),
                ),
              ],
              onSkip: () {
                Navigator.pushReplacementNamed(context, '/landing');
              },
              onFinish: () {
                Navigator.pushReplacementNamed(context, '/landing');
              },
            ),
        '/landing': (context) => Landing(),
        '/homepage': (context) => Homepage()
      },
    );
  }
}
