import 'package:flutter/material.dart';
import 'package:vitasafe/VehicleBook.dart';

class Vehicleview extends StatefulWidget {
  const Vehicleview({super.key});

  @override
  State<Vehicleview> createState() => _VehicleviewState();
}

class _VehicleviewState extends State<Vehicleview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vehicles"),
        backgroundColor: const Color.fromARGB(255, 5, 74, 130),
      ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text('Vehicle_Name'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Driver_Name"),
                  Text("Hospital"),
                  Text("Vehicle_No"),
                  Text("Contact_No"),
                ],
              ),
              trailing: TextButton(
                onPressed: () {Navigator.push(context,MaterialPageRoute(builder: (context) => VehicleBookingPage(),));},
                child: Text("BOOK", style: TextStyle(color: Colors.black)),
                style: TextButton.styleFrom(backgroundColor: Colors.grey),
              ),
            ),
          );
        },
      ),
    );
  }
}
