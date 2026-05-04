// Entry point for the Flutter app
// Updated by Fatima - Final Version222
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'Auth.gate.dart';
import 'screens/auth/welcome_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/registration_screen.dart';
import 'screens/auth/verification_status_screen.dart';
import 'screens/donor/home_navigation.dart';
import 'screens/donor/dashboard_screen.dart';
import 'screens/donor/account_screen.dart';
import 'screens/donor/settings_screen.dart';
import 'screens/donor/blood_requests_screen.dart';
import 'screens/donor/events_screen.dart';
import 'screens/donor/notifications_screen.dart';
import 'screens/donor/learn_about_donation_screen.dart';
import 'screens/donor/change_password_screen.dart';
import 'screens/donor/about_app_screen.dart';
import 'screens/hospital/hospital_dashboard_screen.dart';
import 'screens/hospital/post_blood_request_screen.dart';
import 'screens/hospital/create_event_screen.dart';
import 'screens/hospital/view_donors_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';
import 'screens/admin/verification_queue_screen.dart';

void main() async {
  // Initialize Flutter binding before calling async functions
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase with platform-specific options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Run the app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  // Builds the MaterialApp with routes and theme
  Widget build(BuildContext context) {
    return MaterialApp(
      // Hide the debug banner in top-right corner
      debugShowCheckedModeBanner: false,
      // App title
      title: 'XwinLink Blood Donation',
      // App-wide theme settings
      theme: ThemeData(
        // Use red as the primary color
        primarySwatch: Colors.red,
        // Light gray background for screens
        scaffoldBackgroundColor: Color(0xFFF8F9FA),
        // Use Roboto font
        fontFamily: 'Roboto',
        // AppBar styling
        appBarTheme: AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF1A1A2E),
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E),
            fontFamily: 'Roboto',
          ),
        ),
        // Elevated button styling
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            padding: EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
      // Start at AuthGate which checks login status
      initialRoute: '/',
      // Define all app routes
      routes: {
        // Auth checking screen
        '/': (context) => AuthGate(),
        // Welcome/Landing screen
        '/welcome': (context) => WelcomeScreen(),
        // Login screen
        '/login': (context) => LoginScreen(),
        // Registration screen
        '/register': (context) => RegistrationScreen(),
        // Verification pending screen
        '/verification_pending': (context) => VerificationStatusScreen(status: 'pending'),
        // Verification rejected screen
        '/verification_rejected': (context) => VerificationStatusScreen(status: 'rejected'),
        // Donor's home navigation (bottom nav bar)
        '/home': (context) => HomeNavigation(),
        // Donor's dashboard
        '/dashboard': (context) => DashboardScreen(),
        // Donor's account/profile
        '/account': (context) => AccountScreen(),
        // Donor's settings
        '/settings': (context) => SettingsScreen(),
        // Blood requests list
        '/requests': (context) => BloodRequestsScreen(),
        // Events list
        '/events': (context) => EventsScreen(),
        // Notifications/Activity
        '/notifications': (context) => NotificationsScreen(),
        // Learn about donation (educational)
        '/learn': (context) => LearnAboutDonationScreen(),
        // Change password screen
        '/change_password': (context) => ChangePasswordScreen(),
        // About app screen
        '/about': (context) => AboutAppScreen(),
        // Hospital dashboard
        '/hospital_dashboard': (context) => HospitalDashboardScreen(),
        // Post blood request form
        '/post_request': (context) => PostBloodRequestScreen(),
        // Create event form
        '/create_event': (context) => CreateEventScreen(),
        // View donors list
        '/view_donors': (context) => ViewDonorsScreen(),
        // Admin dashboard
        '/admin_dashboard': (context) => AdminDashboardScreen(),
        // Verification queue for admins
        '/verify': (context) => VerificationQueueScreen(),
      },
    );
  }
}