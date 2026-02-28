import 'package:flutter/material.dart';
import 'package:lost_found_app/Screens/Home.dart';
import 'package:lost_found_app/auth/Signup.dart';
import 'package:lost_found_app/provider/splashprovider.dart';
import 'package:provider/provider.dart';


class Splash2 extends StatelessWidget {
  const Splash2({super.key});

  @override
  Widget build(BuildContext context) {
    // Auto-navigate after delay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 2000), () async {
        final splashProvider = Provider.of<SplashProvider>(context, listen: false);
        final hasCompleted = await splashProvider.hasCompletedSplash;

        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => hasCompleted ?  MainNavigationScreen() : const SignupScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                ),
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
      });
    });

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFf8f9fa),
      body: Stack(
        children: [
          Center(
            child: Container(
              width: screenWidth * 0.9,
              height: screenHeight * 0.5,
              constraints: const BoxConstraints(
                maxWidth: 500,
                maxHeight: 500,
              ),
              child: Image.asset(
                'assets/images/lostfound-logo.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
       
        ],
      ),
    );
  }
}