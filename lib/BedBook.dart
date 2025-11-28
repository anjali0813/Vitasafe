import 'package:flutter/material.dart';

class BedBookPage extends StatefulWidget {
  const BedBookPage({super.key});

  @override
  State<BedBookPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<BedBookPage> {
  DateTime? selectedDate;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bed Booking"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Card(
            child: ListTile(
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text("Ward_NO."), Text("Bed-Count")],
              ),
            ),
          ),

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

          TextButton(
            onPressed: () {},
            child: Text("BOOK", style: TextStyle(color: Colors.black)),
            style: TextButton.styleFrom(backgroundColor: Colors.grey),
          ),
        ],
      ),
    );
  }
}
