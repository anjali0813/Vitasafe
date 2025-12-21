import 'package:flutter/material.dart';
import 'package:vitasafe/BedBook.dart';
import 'package:vitasafe/Doctorbook.dart';
import 'package:vitasafe/VehicleBook.dart';
import 'package:vitasafe/alertview.dart';
import 'package:vitasafe/bedbookinghistory.dart';
import 'package:vitasafe/blood_donation.dart';
import 'package:vitasafe/emergency_support.dart';
import 'package:vitasafe/homepage.dart';
import 'package:vitasafe/login.dart';
import 'package:vitasafe/medical_emergency.dart';
import 'package:vitasafe/public.dart';
import 'package:vitasafe/register.dart';
import 'package:vitasafe/vehiclebookinghistory.dart';
import 'package:vitasafe/vehicleview.dart';
import 'package:vitasafe/volunteer.dart';
import 'package:vitasafe/volunteer_feedback&ratings.dart';
import 'package:vitasafe/volunteer_home.dart';
import 'package:vitasafe/volunteer_notifications.dart';
import 'package:vitasafe/volunteer_registration.dart';
import 'package:vitasafe/volunteer_taskassignment.dart';

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
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: LoginScreen()
    );
  }
}
