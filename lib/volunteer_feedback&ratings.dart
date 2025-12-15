import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:vitasafe/login_api.dart';
import 'package:vitasafe/reg_api.dart';

class VolunteerFeedbackPage extends StatefulWidget {
  const VolunteerFeedbackPage({super.key});

  @override
  State<VolunteerFeedbackPage> createState() => _VolunteerFeedbackPageState();
}

class _VolunteerFeedbackPageState extends State<VolunteerFeedbackPage> {
  double _rating = 0;
    
    Future<void> submitReview() async {
    if (feedbackController.text.trim().isEmpty || _rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    try {
      final response = await Dio().post(
        "$baseurl/volunteer_feedback/$lid",
        data: {
          "Feedback": feedbackController.text.trim(),
          "Rating": _rating,
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
  final TextEditingController feedbackController = TextEditingController();

  // List<Map<String, dynamic>> previousFeedback = [
  //   {
  //     "name": "Hospital Staff",
  //     "feedback": "Great support during the emergency case yesterday!",
  //     "rating": 4.5,
  //   },
  //   {
  //     "name": "Ambulance Team",
  //     "feedback": "Prompt response and well coordinated.",
  //     "rating": 5.0,
  //   },
  //   {
  //     "name": "Public User",
  //     "feedback": "Very helpful and polite.",
  //     "rating": 4.0,
  //   },
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Feedback & Ratings"),
        backgroundColor: Colors.redAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Give Your Feedback",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Rating Bar

            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 40,
              itemPadding: EdgeInsetsGeometry.symmetric(horizontal: 2),
              itemBuilder: (context, index) => Icon(Icons.star,color: Colors.amber,), onRatingUpdate: (rating){
              setState(() {
                _rating=rating;
              });
            }),
            // Row(
            //   children: List.generate(5, (index) {
            //     return IconButton(
            //       onPressed: () {
            //         setState(() {
            //           rating = index + 1.0;
            //         });
            //       },
            //       icon: Icon(
            //         Icons.star,
            //         size: 30,
            //         color: index < rating ? Colors.redAccent : Colors.grey,
            //       ),
            //     );
            //   }),
            // ),

             SizedBox(height: 10),

            // Feedback input
            TextField(
              controller: feedbackController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Write your feedback here...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Submit Button
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                onPressed: () {
                  if (_rating == 0 || feedbackController.text.isEmpty) return;
                  setState(() {
                    submitReview();
                    feedbackController.clear();
                    _rating = 0;
                  });
                },
                child: const Text("Submit", style: TextStyle(fontSize: 16)),
              ),
            ),

            const SizedBox(height: 25),
            // const Divider(),
           
          ],
        ),
      ),
    );
  }
}
