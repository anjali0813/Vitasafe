import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:vitasafe/login_api.dart';
import 'package:vitasafe/reg_api.dart'; // for baseurl, lid

class ReviewPage extends StatefulWidget {
  final String hospitalId;
  final String hospitalName;

  const ReviewPage({
    super.key,
    required this.hospitalId,
    required this.hospitalName,
  });

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final TextEditingController reviewController = TextEditingController();
  double rating = 0;

  Future<void> submitReview() async {
    if (reviewController.text.trim().isEmpty || rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    try {
      final response = await Dio().post(
        "$baseurl/add_review/$lid",
        data: {
          "HOSPITAL": widget.hospitalId,
          "Review": reviewController.text.trim(),
          "Rating": rating,
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Review submitted successfully!")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      print("Error Review: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to submit review")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Review - ${widget.hospitalName}"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Rating", style: TextStyle(fontSize: 18)),

            const SizedBox(height: 10),

            Row(
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    color: Colors.orange,
                    size: 32,
                  ),
                  onPressed: () {
                    setState(() => rating = index + 1.0);
                  },
                );
              }),
            ),

            const SizedBox(height: 20),
            const Text("Write Review", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),

            TextField(
              controller: reviewController,
              maxLines: 4,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: "Describe your experience...",
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: ElevatedButton(
                onPressed: submitReview,
                child: const Text("Submit Review"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
