import 'package:flutter/material.dart';

class VolunteerTaskAssignmentPage extends StatefulWidget {
  const VolunteerTaskAssignmentPage({super.key});

  @override
  State<VolunteerTaskAssignmentPage> createState() => _VolunteerTaskAssignmentPageState();
}

class _VolunteerTaskAssignmentPageState extends State<VolunteerTaskAssignmentPage> {
  final List<Map<String, dynamic>> tasks = [
    {"title": "Medical Camp Assistance", "description": "Help doctors and manage crowd.", "status": "Pending"},
    {"title": "Accident Emergency Support", "description": "Provide first aid and inform authorities.", "status": "Assigned"},
    {"title": "Blood Donation Drive", "description": "Assist with donor registration.", "status": "Completed"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Volunteer Task Assignment"),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];

          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task["title"],
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    task["description"],
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: task["status"] == "Completed"
                              ? Colors.green
                              : task["status"] == "Assigned"
                                  ? Colors.orange
                                  : Colors.redAccent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          task["status"],
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            task["status"] = "Completed";
                          });
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                        child: const Text("Mark Completed",style: TextStyle(color: Colors.black))
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
