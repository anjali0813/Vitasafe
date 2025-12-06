import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:vitasafe/login_api.dart';
import 'package:vitasafe/reg_api.dart';

class VehicleBookingPage extends StatefulWidget {
  final int ambulanceId;

  const VehicleBookingPage({super.key, required this.ambulanceId});

  @override
  State<VehicleBookingPage> createState() => _VehicleBookingPageState();
}

class _VehicleBookingPageState extends State<VehicleBookingPage> {
  DateTime? selectedDate;
  bool isLoading = false;


  Future<void> _bookAmbulance() async {
    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a date")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await Dio().post(
        "$baseurl/ambulancebooking/$lid/${widget.ambulanceId}",
        data: {
          "Date": selectedDate!.toIso8601String().split("T")[0],
        },
        
      );
      print(response.data);

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Ambulance Booked Successfully")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      print("Booking error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Booking Failed")),
      );
    }

    setState(() => isLoading = false);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book Ambulance"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextButton(
              onPressed: _pickDate,
              child: const Text("Select Date"),
            ),
            Text(
              selectedDate == null
                  ? "No date selected"
                  : selectedDate.toString().split(" ")[0],
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: isLoading ? null : _bookAmbulance,
              child: isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : const Text("BOOK AMBULANCE"),
            )
          ],
        ),
      ),
    );
  }
}
