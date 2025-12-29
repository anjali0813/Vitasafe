import 'package:vitasafe/fcm_service.dart';
import 'package:vitasafe/login_api.dart';

void sendTokenToBackend(String volunteerId) async {
  String? token = await FCMService.getToken();

  if (token == null) {
    print("❌ FCM token null");
    return;
  }

  print("📱 FCM TOKEN: $token");

  await saveVolunteerFCMToken(
    volunteerId: volunteerId,
    fcmToken: token,
  );
}
