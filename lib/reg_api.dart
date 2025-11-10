import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

String baseurl = 'http://192.168.1.153:5000';
Dio dio = Dio();

Future<String?> registerUser({
  required String name,
  required String dob,
  required String gender,
  required String medicalhistory,
  required String email,
  required String address,
  required String contacno,
  required File? photo,
  context
}) async {
  try {
    FormData formData = FormData.fromMap({
      'Name':name,
      'Dob':dob,
      'Gender':gender,
      'MedicalHistory':medicalhistory,
      'Email':email,
      'Address':address,
      'Contact_no':contacno,
      if(photo !=null)
      'Photo': await MultipartFile.fromFile(photo.path, filename: photo.path.split('/').last),
    });

    final response = await dio.post('usereg', data:formData);

    if(response.statusCode == 200 || response.statusCode == 201)
    {
      Navigator.pop(context);
      return "Registration Successful!";
    }
    else
    {
      return response.data['error'] ?? "Registration failed!";
    }
  }
  on DioException catch(e) {
    if (e.response !=null) {
      return e.response?.data['error']??"Error occured";
    }
    else{
      return "Network error: ${e.message}";
    }
  }
}