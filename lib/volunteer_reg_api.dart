import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:vitasafe/reg_api.dart';

Future<String?> registerVolunteer({
    required String name,
    required String email,
    required String phone,
    required String address,
    required String skills,
    required File? photo,
    required String age,
    required String gender,
    context,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'Name': name,
        'Email': email,
        'Phone': phone,
        'Address': address,
        'Skills': skills,
        'Age': age,
        'Gender': gender,
        if (photo != null)
          'Image': await MultipartFile.fromFile(
            photo.path,
            filename: photo.path.split('/').last,
          ),
      });

      final response =
          await dio.post('$baseurl/volunteer_registration', data: formData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pop(context);
        return "Volunteer Registration Successful!";
      } else {
        return response.data['error'] ?? "Registration failed!";
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response?.data['error'] ?? "Error occurred";
      } else {
        return "Network error: ${e.message}";
      }
    }
  }
