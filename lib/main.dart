import 'package:app/pages/homepage.dart';
import 'package:app/pages/landing.dart';
import 'package:app/pages/onBoarding.dart';
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
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => Onboarding(
              pages: [
                OnBoardingModel(
                  title: 'Fast, Fluid and Secure',
                  description:
                      'Enjoy the best of the world in the palm of your hands.',
                  imageUrl: 'lib/assets/images/car.png',
                  bgColor: const Color(0xFF11bfb0),
                ),
                OnBoardingModel(
                  title: 'Quality Tires',
                  description: 'Connect with your friends anytime anywhere.',
                  imageUrl: 'lib/assets/images/tire.png',
                  bgColor: const Color(0xFFBF1120),
                ),
                OnBoardingModel(
                  title: 'Bookmark your favourites',
                  description:
                      'Bookmark your favourite quotes to read at a leisure time.',
                  imageUrl: 'lib/assets/images/car.png',
                  bgColor: const Color(0xFF1120bf),
                ),
                OnBoardingModel(
                  title: 'Follow creators',
                  description:
                      'Follow your favourite creators to stay in the loop.',
                  imageUrl: 'lib/assets/images/car.png',
                  bgColor: const Color(0xFFbf5911),
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
