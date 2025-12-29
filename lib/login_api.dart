import 'package:flutter/material.dart';
import 'package:vitasafe/homepage.dart';
import 'package:vitasafe/reg_api.dart';
import 'package:vitasafe/sendfcmtoken.dart';
import 'package:vitasafe/volunteer_home.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

int? lid;
Future<void> loginuser({
  required String username,
  required String password,
  context
}) async {
  try {

    final location = await getLocation();

    final response = await dio.post(
      '$baseurl/User_Login',
      data: {
        'Username': username,
        'Password': password,
        'latitude': location['latitude'],
        'longitude': location['longitude'],
      },
    );

    if (response.statusCode == 200) {

      lid = response.data['login_id'];

      if (response.data['UserType'] == 'USER') {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => HomePage()),
          (route) => false,
        );
      } else if (response.data['UserType'] == 'Volunteer') {
        
  // String volunteerId = response.data['login_id'].toString();

  sendTokenToBackend(lid!.toString());

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => VolunteerModulePage()),
          (route) => false,
        );
      }
    }

  } catch (e) {
    print('Login error: $e');
  }
}

Future<Map<String, double>> getLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw Exception("Location services disabled");
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  if (permission == LocationPermission.deniedForever) {
    throw Exception("Location permission denied forever");
  }

  Position position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );

  return {
    "latitude": position.latitude,
    "longitude": position.longitude,
  };
}




Future<void> saveVolunteerFCMToken({
  required String volunteerId,
  required String fcmToken,
}) async {
  final response = await http.post(
    Uri.parse('$baseurl/volunteer_token'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      "volunteer_id": volunteerId,
      "fcm_token": fcmToken,
    }),
  );

  if (response.statusCode == 200) {
    print("✅ FCM token saved");
  } else {
    print("❌ Failed to save token: ${response.body}");
  }
}
