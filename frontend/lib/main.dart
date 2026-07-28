import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/patient_registration_screen.dart';
import 'screens/find_patient_screen.dart';
import 'screens/patient_chart_screen.dart';
import 'services/service_locator.dart';

void main() {
  setupServiceLocator();
  runApp(const ClinicApp());
}

class ClinicApp extends StatelessWidget {
  const ClinicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clinic Management System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/patient-registration': (context) => const PatientRegistrationScreen(),
        '/find-patient': (context) => const FindPatientScreen(),
        '/patient-chart': (context) => const PatientChartScreen(),
      },
    );
  }
}
