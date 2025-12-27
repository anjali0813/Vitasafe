import 'package:flutter/material.dart';
import 'package:vitasafe/Doctorview.dart';
import 'package:vitasafe/VehicleBook.dart';
import 'package:vitasafe/alertview.dart';
import 'package:vitasafe/bedbookinghistory.dart';
import 'package:vitasafe/bloodrequest.dart';
import 'package:vitasafe/complaint.dart';
import 'package:vitasafe/doctorbookinghistory.dart';
import 'package:vitasafe/hospitalview.dart';
import 'package:vitasafe/login.dart';
import 'package:vitasafe/prediction.dart';
import 'package:vitasafe/vehiclebookinghistory.dart';
import 'package:vitasafe/vehicleview.dart';
import 'package:vitasafe/viewhospitalbed.dart';
import 'package:vitasafe/viewhospitalsambulance.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});



  void _onTapFeature(BuildContext context, String feature) {
  Widget? targetPage;

  switch (feature) {
    case 'Book Vehicle':
      targetPage = const NearbyhospitalAmbulance();
      break;

    case 'Book Doctor':
      targetPage = const HospitalView();
      break;

    case 'Book Bed':
      targetPage = const NearbyhospitalBed();
      break;

    case 'View doctor booking history':
      targetPage = const DoctorBookingHistoryPage();
      break;

    case 'View vehicle booking history':
      targetPage = const VehicleBookingHistoryPage();
      break;

    case 'View bed booking history':
      targetPage = const BedBookingHistoryPage();
      break;

    case 'Complaints':
      targetPage = ComplaintPage();
      break;

    case 'Notifications':
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Opening Notifications...')),
      );
      return;

    // case 'View Alert':
    //   targetPage = const AlertViewPage();
    //   break;
    case 'Blood request':
    targetPage =  BloodRequestForm();
    break;
    case 'Predict Disease':
      targetPage =  FirstAidChatBotPage();
      break;

    default:
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tapped: $feature')),
      );
      return;
  }

 Navigator.push(context, MaterialPageRoute(builder: (_) => targetPage!));
}


  Widget _buildFeatureCard(
    BuildContext context,
    IconData icon,
    String title,
    Color color,
  ) {
    return GestureDetector(
      onTap: () => _onTapFeature(context, title),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: color.withOpacity(0.1),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 40),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentBooking(String title, String subtitle, IconData icon) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: Colors.teal),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EasyBook Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => _onTapFeature(context, 'Notifications'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false,
            ),
          ),
        ],
      ),
  
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, User 👋',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'What would you like to do today?',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),

            // --- Feature Cards ---
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildFeatureCard(
                  context,
                  Icons.directions_car,
                  'Book Vehicle',
                  Colors.teal,
                ),
                _buildFeatureCard(
                  context,
                  Icons.local_hospital,
                  'Book Doctor',
                  Colors.indigo,
                ),
                _buildFeatureCard(
                  context,
                  Icons.history,
                  'Book Bed',
                  Colors.orange,
                ),

                _buildFeatureCard(
                  context,
                  Icons.history,
                  'View doctor booking history',
                  Colors.yellow,
                ),
                _buildFeatureCard(
                  context,
                  Icons.history,
                  'View vehicle booking history',
                  Colors.orange,
                ),
                _buildFeatureCard(
                  context,
                  Icons.history,
                  'View bed booking history',
                  Colors.orange,
                ),
                _buildFeatureCard(
                  context,
                  Icons.history,
                  'Complaints',
                  Colors.orange,
                ),
                // _buildFeatureCard(
                //   context,
                //   Icons.warning,
                //   'View Alert',
                //   Colors.black,
                // ),
                _buildFeatureCard(context, Icons.bloodtype, 'Blood request', Colors.red),
                _buildFeatureCard(
                  context,
                  Icons.chat,
                  'Predict Disease',
                  Colors.blue,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
