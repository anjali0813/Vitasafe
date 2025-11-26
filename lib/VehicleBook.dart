import 'package:flutter/material.dart';

class VehicleBookingPage extends StatefulWidget {
  const VehicleBookingPage({super.key});

  @override
  State<VehicleBookingPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<VehicleBookingPage> {
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


  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book Vehicle"),
        backgroundColor: Colors.blueGrey,
      ),
      body: 
       Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        
      children: [

      // Date Picker
             ListTile(
              leading: const Icon(
                Icons.calendar_month,
                color: Colors.redAccent,
              ),
              title: Text(
                selectedDate == null
                    ? "Select Date"
                    : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
              ),
              onTap: pickDate,
            ),

            //  Time Picker
             ListTile(
              leading: const Icon(Icons.access_time, color: Colors.redAccent),
              title: Text(
                selectedTime == null
                    ? "Select Time"
                    : selectedTime!.format(context),
              ),
              onTap: pickTime,
            ),
            
            SizedBox(height: 30),

            // Submit Button
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 30,
                  ),
                ),
                onPressed: (){},
                child: 
                    Text(
                        "Book Vehicle",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
              ),
            ),
    ]));
  }
}