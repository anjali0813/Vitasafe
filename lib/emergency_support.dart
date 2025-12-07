import 'package:flutter/material.dart';
import 'package:vitasafe/emergency_reporting.dart';
import 'package:vitasafe/fire_accident.dart';
import 'package:vitasafe/medical_emergency.dart';
import 'package:vitasafe/natural_disaster_support.dart';
import 'package:vitasafe/public.dart';

// Dummy page placeholders for navigation
class ProfileManagementPage extends StatelessWidget {
  const ProfileManagementPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Profile Management')), body: const Center(child: Text('Profile Management Page')));
}

class TaskAssignmentPage extends StatelessWidget {
  const TaskAssignmentPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Task Assignment')), body: const Center(child: Text('Task Assignment Page')));
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Notifications & Alerts')), body: const Center(child: Text('Notifications Page')));
}

class BloodDonationPage extends StatelessWidget {
  const BloodDonationPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Blood Donation Volunteering')), body: const Center(child: Text('Blood Donation Page')));
}

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Feedback & Ratings')), body: const Center(child: Text('Feedback Page')));
}

class VolunteerEmergencySupportPage extends StatelessWidget {
  const VolunteerEmergencySupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Emergency Support"),
        backgroundColor: Colors.redAccent,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.redAccent),
              child: Text('Volunteer Module', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile Management'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileManagementPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.task),
              title: const Text('Task Assignment'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const TaskAssignmentPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notifications & Alerts'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.bloodtype),
              title: const Text('Blood Donation Volunteering'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const BloodDonationPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text('Feedback & Ratings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const FeedbackPage()));
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Emergency Support",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            const Text(
              "Volunteers can respond quickly to emergencies, report incidents, and assist affected people.",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView(
                children: [
                  buildEmergencyCard(
                    context: context,
                    route: AccidentAlertPage(),
                    title: "Accident Alert",
                    description: "Respond to road accidents and help victims immediately.",
                    icon: Icons.warning_amber_rounded,
                    color: Colors.redAccent,
                  ),

                  buildEmergencyCard(
                    context: context,
                    route: MedicalEmergencyPage(),
                    title: "Medical Emergency",
                    description: "Provide first aid and guide patients to nearest hospital.",
                    icon: Icons.local_hospital,
                    color: Colors.green,
                  ),

                  buildEmergencyCard(
                    context: context,
                    route: FireAccidentPage(),
                    title: "Fire Accident",
                    description: "Assist people during fire incidents and alert fire services.",
                    icon: Icons.fire_truck,
                    color: Colors.deepOrange,
                  ),

                  buildEmergencyCard(
                    context: context,
                    route: NaturalDisasterPage(),
                    title: "Natural Disaster Support",
                    description: "Help with rescue, relief distribution, and crowd management.",
                    icon: Icons.flood,
                    color: Colors.blueAccent,
                  ),

                  buildEmergencyCard(
                    context: context,
                    route: EmergencyReportingPage(),
                    title: "Emergency Reporting",
                    description: "Report emergencies with location details instantly.",
                    icon: Icons.location_on,
                    color: Colors.purple,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEmergencyCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required Widget route,
    required BuildContext context
  }) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => route,)),
      child: Card(
        
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: color,
                child: Icon(icon, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey.shade600),
            ],
          ),
        ),
      ),
    );
  }
}
