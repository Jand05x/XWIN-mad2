// Updated by Fatima - Final Version222
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'Auth.gate.dart';
import 'screens/auth/welcome_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/registration_screen.dart';
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
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'XwinLink Blood Donation',
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Color(0xFFF8F9FA),
        fontFamily: 'Roboto',
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
      initialRoute: '/',
      routes: {
        '/': (context) => AuthGate(),
        '/welcome': (context) => WelcomeScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegistrationScreen(),
        '/home': (context) => HomeNavigation(),
        '/dashboard': (context) => DashboardScreen(),
        '/account': (context) => AccountScreen(),
        '/settings': (context) => SettingsScreen(),
        '/requests': (context) => BloodRequestsScreen(),
        '/events': (context) => EventsScreen(),
        '/notifications': (context) => NotificationsScreen(),
        '/learn': (context) => LearnAboutDonationScreen(),
        '/change_password': (context) => ChangePasswordScreen(),
        '/about': (context) => AboutAppScreen(),
        '/hospital_dashboard': (context) => HospitalDashboardScreen(),
        '/post_request': (context) => PostBloodRequestScreen(),
        '/create_event': (context) => CreateEventScreen(),
        '/view_donors': (context) => ViewDonorsScreen(),
        '/admin_dashboard': (context) => AdminDashboardScreen(),
        '/verify': (context) => VerificationQueueScreen(),
      },
    );
  }
}