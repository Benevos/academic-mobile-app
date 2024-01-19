import 'package:empty_app/pages/about/about_screen.dart';
import 'package:empty_app/pages/dashboard/dashboard_screen.dart';
import 'package:empty_app/pages/login/login_screen.dart';
import 'package:empty_app/pages/problems/problems_screen.dart';
import 'package:empty_app/pages/register/register_screen.dart';
import 'package:empty_app/pages/difficulty/difficulty_screen.dart';
import 'package:empty_app/pages/categories/categories_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:flutter/services.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async
{
  WidgetsFlutterBinding.ensureInitialized();

  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget 
{
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) 
  {
    SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    ]);

    var brigthness = MediaQuery.of(context).platformBrightness;
    // ignore: unused_local_variable
    bool isDarkMode = brigthness == Brightness.dark;
    isDarkMode = false;

    /*  final Map<String, dynamic> colors = {
      'backgroundColor': isDarkMode ? const Color.fromARGB(255, 32, 32, 32) : null,
      'textFieldHintText': isDarkMode ? const Color.fromARGB(0, 0, 0, 0) : null,
    }; */

    return MaterialApp
    (
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        //scaffoldBackgroundColor: colors['backgroundColor'],
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blue
          )
        ),
      initialRoute: '/',
      
      routes: {
        '/':(context) => const LoginScreen(),
        '/register':(context) => const RegisterScreen(),
        '/about':(context) => const AboutScreen(),
        '/dashboard':(context) => const DashboardScreen(),
        '/dashboard/categories':(context) => const CategoriesScreen(),
        '/dashboard/categories/difficulty':(context) => const DifficultyScreen(),
        '/dashboard/categories/difficulty/problems':(context) => const ProblemsScreen(),
      },
    );
  }
}

class Latex extends StatelessWidget {
  const Latex({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const TeXView(
      renderingEngine: TeXViewRenderingEngine.mathjax(),
      child: TeXViewDocument(r"""<h1>Este es un titulo con un ecuacion \(x+3\)</>"""));
  }
}
