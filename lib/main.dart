import 'package:flutter/material.dart';
import 'package:lost_found_app/Screens/Home.dart';
import 'package:lost_found_app/auth/Login.dart';
import 'package:lost_found_app/auth/Signup.dart';
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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SignupScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const MainNavigationScreen(),
      },
    );
  }
}

