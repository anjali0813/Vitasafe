import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:vitasafe/homepage.dart';
import 'package:vitasafe/reg_api.dart';
import 'package:vitasafe/volunteer_home.dart';

int? lid;
Future<void> loginuser({
  required String username,
  required String password,
  context
}) async {
  try {
    final response = await dio.post(
      '$baseurl/User_Login',
      data: {
      'Username': username,
      'Password': password,
      },
    );
    print(response.data);

    if(response.statusCode == 200) {
        lid = response.data['login_id'];
        if(response.data['UserType']=='USER'){
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder:(context) => HomePage()),
            (route) => false,
          );
        } else {
        Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => VolunteerModulePage()),
        (route) => false,
        );
        }
        print(response.data);
  } else {
    print('Login failed');
  }
} on DioException catch(e) {
  print('Login error : $e');
}
}