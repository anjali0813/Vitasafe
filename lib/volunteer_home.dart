import 'package:flutter/material.dart';
import 'package:vitasafe/blood_donation.dart';
import 'package:vitasafe/emergency_support.dart';
import 'package:vitasafe/volunteer.dart';
import 'package:vitasafe/volunteer_feedback&ratings.dart';
import 'package:vitasafe/volunteer_notifications.dart';
import 'package:vitasafe/volunteer_taskassignment.dart';

class VolunteerModulePage extends StatelessWidget {
  const VolunteerModulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Volunteer Module"),
        backgroundColor: Colors.red,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: [
          _buildCard(
            context,
            title: "Profile Management",
            icon: Icons.person,
            page: VolunteerProfilePage(),
          ),
          _buildCard(
            context,
            title: "Task Assignment",
            icon: Icons.assignment,
            page: VolunteerTaskAssignmentPage(),
          ),
          // _buildCard(
          //   context,
          //   title: "Emergency Support",
          //   icon: Icons.warning,
          //   page: VolunteerEmergencySupportPage(),
          // ),
          _buildCard(
            context,
            title: "Notifications & Alerts",
            icon: Icons.notifications_active,
            page:VolunteerNotificationsPage(),
          ),
          _buildCard(
            context,
            title: "Blood Donation Volunteering",
            icon: Icons.bloodtype,
            page: BloodDonationVolunteerPage(),
          ),
          _buildCard(
            context,
            title: "Feedback & Ratings",
            icon: Icons.star_rate,
            page:VolunteerFeedbackPage(),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, {required String title, required IconData icon, required Widget page}) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => page),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 6,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.redAccent),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.redAccent,
      ),
      body: Center(
        child: Text(
          "$title Page (To be implemented)",
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
