import 'package:flutter/material.dart';

class BedBookPage extends StatefulWidget {
  const BedBookPage({super.key});

  @override
  State<BedBookPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<BedBookPage> {
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
