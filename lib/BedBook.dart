import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:vitasafe/login_api.dart';
import 'package:vitasafe/reg_api.dart';

class BedBookPage extends StatefulWidget {
  final int bedId;

  const BedBookPage({super.key, required this.bedId});

  @override
  State<BedBookPage> createState() => _BedBookPageState();
}

class _BedBookPageState extends State<BedBookPage> {
  DateTime? selectedDate;
  bool isSubmitting = false;

  // int lid = 2; // <-- replace with logged-in user's login ID

  Future<void> pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
    );

    if (date != null) {
      setState(() => selectedDate = date);
    }
  }

  Future<void> bookBed() async {
    if (selectedDate == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Please select a date")));
      return;
    }

    setState(() => isSubmitting = true);

    try {
      final formattedDate = selectedDate!.toIso8601String().split("T")[0];

      final response = await Dio().post(
        "$baseurl/bedbooking/$lid",
        data: {
          "BED": widget.bedId,
          "date": formattedDate,
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Bed Booked Successfully")),
        );
        Navigator.pop(context); // go back
      }
    } catch (e) {
      print("Error booking bed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Booking Failed")),
      );
    }

    setState(() => isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book Bed"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Date Picker
            ListTile(
              leading: const Icon(Icons.calendar_month, color: Colors.redAccent),
              title: Text(
                selectedDate == null
                    ? "Select Date"
                    : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
              ),
              onTap: pickDate,
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: isSubmitting ? null : bookBed,
              child: isSubmitting
                  ? CircularProgressIndicator(color: Colors.white)
                  : const Text("BOOK BED"),
            ),
          ],
        ),
      ),
    );
  }
}
