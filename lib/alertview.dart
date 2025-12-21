import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:vitasafe/login_api.dart';
import 'package:vitasafe/reg_api.dart';

class AlertViewPage extends StatefulWidget {
  const AlertViewPage({Key? key}) : super(key: key);

  @override
  State<AlertViewPage> createState() => _AlertViewPageState();
}

class _AlertViewPageState extends State<AlertViewPage> {
  bool isLoading = true;
  List alerts = [];





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Alerts"),
        backgroundColor: Colors.blueGrey,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : alerts.isEmpty
              ? const Center(
                  child: Text(
                    "No alerts found.",
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  itemCount: alerts.length,
                  itemBuilder: (context, index) {
                    final alert = alerts[index];
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        leading: const Icon(Icons.warning, color: Colors.blueAccent),
                        title: Text(alert['alert_title'] ?? 'Emergency Alert'),
                        subtitle: Text(alert['description'] ?? 'No description'),
                      ),
                    );
                  },
                ),
    );
  }
}
