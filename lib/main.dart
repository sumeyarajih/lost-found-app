import 'package:flutter/material.dart';
import 'package:lost_found_app/Screens/Home.dart';
import 'package:lost_found_app/auth/Login.dart';
import 'package:lost_found_app/auth/Signup.dart';
import 'package:lost_found_app/provider/splashprovider.dart';
import 'package:lost_found_app/splash/splash.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://omnvvzziswwazvlclvxr.supabase.co',
    anonKey: 'sb_publishable_DMgaQiKrda3D-Y2hsV09ZQ_dc99bAcw',
  );

  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SplashProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const Splash2(),
          '/signup': (context) => const SignupScreen(),
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const MainNavigationScreen(),
        },
      ),
    );
  }
}

