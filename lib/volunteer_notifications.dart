import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:vitasafe/login_api.dart';
import 'package:vitasafe/reg_api.dart';

class VolunteerNotificationsPage extends StatefulWidget {
  const VolunteerNotificationsPage({super.key});

  @override
  State<VolunteerNotificationsPage> createState() => _VolunteerNotificationsPageState();
}

class _VolunteerNotificationsPageState extends State<VolunteerNotificationsPage> {


 List alerts = [];
  Future<void> fetchAlerts() async {
    try {
      final response = await dio.get('$baseurl/view_alerts');
print(response.data);
      if (response.statusCode == 200 && response.data is List) {
        setState(() {
          alerts = response.data;
        
        });
      } else {
      
      }
    } catch (e) {
      debugPrint("Alert fetch error: $e");
     
    }
  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAlerts();
  }

  @override
  Widget build(BuildContext context) {
 
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications & Alerts"),
        backgroundColor: Colors.redAccent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: const [
          NotificationTile(
            title: "Emergency Alert",
            message: "A road accident has been reported near your area.",
            time: "10 min ago",
            icon: Icons.warning,
          ),
          NotificationTile(
            title: "New Task Assigned",
            message: "You have been assigned to assist at City Hospital.",
            time: "1 hour ago",
            icon: Icons.assignment,
          ),
          NotificationTile(
            title: "Blood Donation Request",
            message: "O+ blood urgently needed at Metro Care Center.",
            time: "2 hours ago",
            icon: Icons.bloodtype,
          ),
          NotificationTile(
            title: "System Update",
            message: "Your volunteer profile has been verified.",
            time: "Yesterday",
            icon: Icons.info,
          ),
        ],
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final String title;
  final String message;
  final String time;
  final IconData icon;

  const NotificationTile({
    super.key,
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.redAccent.shade100,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(message),
        trailing: Text(
          time,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ),
    );
  }
}
