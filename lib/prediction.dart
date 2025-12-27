import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:vitasafe/login_api.dart';
import 'package:vitasafe/reg_api.dart';

class FirstAidChatBotPage extends StatefulWidget {
  const FirstAidChatBotPage({super.key});

  @override
  State<FirstAidChatBotPage> createState() => _FirstAidChatBotPageState();
}

class _FirstAidChatBotPageState extends State<FirstAidChatBotPage> {
  final TextEditingController _controller = TextEditingController();
  final Dio _dio = Dio();

  List<Map<String, String>> messages = [];

  final String apiUrl = "$baseurl/bot/"; 
  // For real device use your system IP

  @override
  void initState() {
    super.initState();
    fetchChatHistory();
  }

  // ---------------- FETCH HISTORY ----------------
  Future<void> fetchChatHistory() async {
    try {
      Response response = await _dio.get('$apiUrl$lid');

      List history = response.data["history"];

      setState(() {
        messages = history.reversed.map<Map<String, String>>((chat) {
          return {
            "user": chat["symptoms"],
            "bot": chat["advice"]
          };
        }).toList();
      });
    } catch (e) {
      debugPrint("History error: $e");
    }
  }

  // ---------------- SEND MESSAGE ----------------
  Future<void> sendMessage() async {
    if (_controller.text.isEmpty) return;

    String userMessage = _controller.text;

    setState(() {
      messages.add({"user": userMessage});
    });

    _controller.clear();

    try {
      Response response = await _dio.post(
        '$apiUrl$lid',
        data: {"message": userMessage},
      );
      print(  response.data);

      setState(() {
        messages.add({
          "bot": response.data["first_aid_advice"]
        });
      });
    } catch (e) {
      debugPrint("Send error: $e");
    }
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("First Aid Assistant"),
        backgroundColor: Colors.redAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                bool isUser = messages[index].containsKey("user");
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser
                          ? Colors.blueAccent
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isUser
                          ? messages[index]["user"]!
                          : messages[index]["bot"]!,
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // ---------------- INPUT BAR ----------------
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Describe your symptoms...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.redAccent),
                  onPressed: sendMessage,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
