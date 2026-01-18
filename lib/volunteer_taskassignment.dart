import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:vitasafe/login_api.dart';
import 'package:vitasafe/reg_api.dart';

class VolunteerTaskAssignmentPage extends StatefulWidget {

  const VolunteerTaskAssignmentPage({super.key});

  @override
  State<VolunteerTaskAssignmentPage> createState() =>
      _VolunteerTaskAssignmentPageState();
}

class _VolunteerTaskAssignmentPageState
    extends State<VolunteerTaskAssignmentPage> {
  final Dio dio = Dio();

  List tasks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  /// 🔹 GET TASKS
  Future<void> fetchTasks() async {
    try {
      final response =
          await dio.get("$baseurl/ViewTask/$lid");

          print(response.data);

      setState(() {
        tasks = response.data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Fetch error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load tasks")),
      );
    }
  }

  /// 🔹 UPDATE TASK STATUS
  Future<void> markCompleted(int taskId) async {
    try {
      await dio.put(
        "$baseurl/ViewTask/$taskId",
        data: {"Status": "Completed"},
      );

      fetchTasks();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Task marked as completed")),
      );
    } catch (e) {
      debugPrint("Update error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update task")),
      );
    }
  }

  Color statusColor(String status) {
    switch (status) {
      case "Completed":
        return Colors.green;
      case "Assigned":
        return Colors.orange;
      default:
        return Colors.redAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Volunteer Task Assignment"),
        backgroundColor: Colors.deepPurple,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
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
                          task["TaskName"] ?? "",
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          task["TaskDescription"] ?? "",
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: statusColor(task["Status"]),
                                borderRadius:
                                    BorderRadius.circular(8),
                              ),
                              child: Text(
                                task["Status"],
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            if (task["Status"] != "Completed")
                              ElevatedButton(
                                onPressed: () =>
                                    markCompleted(task["id"]),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.deepPurple,
                                ),
                                child: const Text(
                                  "Mark Completed",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
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
