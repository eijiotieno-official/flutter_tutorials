import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tutorials/firebase_options.dart';
import 'package:flutter_tutorials/social_app/pages/home_page.dart';
import 'package:flutter_tutorials/social_app/services/authentication_services.dart';
import 'package:get/get.dart';

// Entry point of the application.
Future<void> main() async {
  // Ensure that Flutter is initialized.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with the specified options.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Run the application.
  runApp(const MainApp());
}

// The main application widget.
class MainApp extends StatelessWidget {
  // Constructs the MainApp widget.
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // Define the light theme for the application.
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.green,
      ),

      // Define the dark theme for the application.
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.green,
      ),

      // Use the system theme mode.data
      themeMode: ThemeMode.system,

      // Set the initial page to CheckAuthStatus widget.
      home: const CheckAuthStatus(),
    );
  }
}

// Widget that checks the authentication status and navigates accordingly.
class CheckAuthStatus extends StatefulWidget {
  // Constructs the CheckAuthStatus widget.
  const CheckAuthStatus({super.key});

  @override
  State<CheckAuthStatus> createState() => _CheckAuthStatusState();
}

class _CheckAuthStatusState extends State<CheckAuthStatus> {
  @override
  void initState() {
    // Listen for changes in the user's authentication state.
    FirebaseAuth.instance.authStateChanges().listen(
      (User? user) async {
        if (user == null) {
          // If the user is not authenticated, log in and navigate to HomePage.
          await AuthenticationServices.logIn().then(
            (_) {
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const HomePage();
                    },
                  ),
                );
              }
            },
          );
        } else {
          // If the user is authenticated, navigate to HomePage.
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const HomePage();
                },
              ),
            );
          }
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Display a CircularProgressIndicator while checking the authentication status.
    return const Center(child: CircularProgressIndicator());
  }
}
