import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vitasafe/fcm_service.dart';
import 'package:vitasafe/login_api.dart';
import 'package:vitasafe/main.dart';
import 'package:vitasafe/public.dart';
import 'package:vitasafe/register.dart';
import 'package:vitasafe/volunteer_registration.dart';

class LoginScreen extends StatefulWidget {
   LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  Future<void> requestPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
}

void initFCMListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final alert = message.notification?.body ?? 'Emergency Alert';

      notificationsPlugin.show(
  DateTime.now().millisecondsSinceEpoch ~/ 1000,
  '🚨 VitaSafe Alert',
  alert,
  const NotificationDetails(
    android: AndroidNotificationDetails(
      'alert_channel',
      'Alerts',
      importance: Importance.max,
      priority: Priority.high,
    ),
  ),
);

    });
  }

//   void sendTokenToBackend(String volunteerId) async {
//   String? token = await FCMService.getToken();

//   if (token == null) {
//     print("❌ FCM token null");
//     return;
//   }

//   print("📱 FCM TOKEN: $token");

//   await saveVolunteerFCMToken(
//     volunteerId: volunteerId,
//     fcmToken: token,
//   );
// }



  TextEditingController username = TextEditingController();

  TextEditingController password = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestPermission();
    initFCMListeners();       // start listening
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Screen'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 175, 156, 148),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: username,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: password,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)
                  )
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: (){
                loginuser(username: username.text, password: password.text,context: context);
              }, child: Text('LOGIN')),
              TextButton(onPressed: (){
                Navigator.push(context,MaterialPageRoute(builder: (context) => RegisterScreen(),));
              }, child: Text('Do not have an account ! REGISTER')),
              TextButton(onPressed: (){
                Navigator.push(context,MaterialPageRoute(builder: (context) => VolunteerRegistrationPage(),));
              }, child: Text('Register as volunteer')),
              TextButton(onPressed: (){
                Navigator.push(context,MaterialPageRoute(builder: (context) => AccidentAlertPage(),));
              }, child: Text('Guest login'))
            ],
          ),
        ),
      ),
    );
  }
}
