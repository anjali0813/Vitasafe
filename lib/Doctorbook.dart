import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:vitasafe/login_api.dart';
import 'package:vitasafe/reg_api.dart';

class DoctorBookingPage extends StatefulWidget {
  final int doctorId;
  final String doctorName;
  final String specialization;

  const DoctorBookingPage({
    Key? key,
    required this.doctorId,
    required this.doctorName,
    required this.specialization,
  }) : super(key: key);

  @override
  State<DoctorBookingPage> createState() => _DoctorBookingPageState();
}

class _DoctorBookingPageState extends State<DoctorBookingPage> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  bool isSubmitting = false;

  Future<void> pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (date != null) {
      setState(() => selectedDate = date);
    }
  }

  Future<void> pickTime() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      setState(() => selectedTime = time);
    }
  }

  Future<void> bookAppointment() async {
    if (selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select date and time")),
      );
      return;
    }

    setState(() => isSubmitting = true);

    try {
      final response = await Dio().post(
        "$baseurl/Doctor_book/$lid",
        data: {
          "DOCID": widget.doctorId,
          "Date": selectedDate.toString().split(" ")[0],
          // "Time": selectedTime!.format(context),
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Appointment Booked Successfully!")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint("Booking error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Booking failed")),
      );
    }

    setState(() => isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Appointment"),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor Header
            Text(
              widget.doctorName,
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(widget.specialization,
                style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 20),

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

            // Time Picker
            // ListTile(
            //   leading: const Icon(Icons.access_time, color: Colors.redAccent),
            //   title: Text(
            //     selectedTime == null
            //         ? "Select Time"
            //         : selectedTime!.format(context),
            //   ),
            //   onTap: pickTime,
            // ),

            const SizedBox(height: 30),

            // Submit Button
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(
                      vertical: 12, horizontal: 30),
                ),
                onPressed: isSubmitting ? null : bookAppointment,
                child: isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Book Appointment",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}