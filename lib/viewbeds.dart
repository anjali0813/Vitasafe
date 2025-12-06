import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:vitasafe/BedBook.dart';
import 'package:vitasafe/reg_api.dart';


class BedListPage extends StatefulWidget {
  final int hospitalId;
  final String hospitalName;

  const BedListPage({
    super.key,
    required this.hospitalId,
    required this.hospitalName,
  });

  @override
  State<BedListPage> createState() => _BedListPageState();
}

class _BedListPageState extends State<BedListPage> {
  List beds = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBeds();
  }

  Future<void> _fetchBeds() async {
    try {
      final response =
          await Dio().get('$baseurl/view_bed/${widget.hospitalId}');
      print(response.data);

      if (response.statusCode == 200) {
        setState(() {
          beds = response.data;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching beds: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Beds - ${widget.hospitalName}"),
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : beds.isEmpty
              ? const Center(child: Text("No Beds Available"))
              : ListView.builder(
                  itemCount: beds.length,
                  itemBuilder: (context, index) {
                    final bed = beds[index];

                    return Card(
                      elevation: 3,
                      margin:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      child: ListTile(
                        title: Text(
                          "Ward: ${bed['ward']}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent),
                        ),
                        subtitle: Text(
                            "Beds Available: ${bed['count'] ?? 0}"),
                        trailing: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BedBookPage(
                                          bedId: bed['bed_id'],
                                        )));
                          },
                          child: const Text("BOOK"),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
