import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationHandler {
  static String? token;

  static Future<void> initializeNotificationHandler() async {
    // You may set the permission requests to "provisional" which allows the user to choose what type
    // of notifications they would like to receive once the user receives a notification.
    // TODO permissionHandler?
    // TODO test
    final notificationSettings = await FirebaseMessaging.instance.requestPermission(provisional: true);

    // For apple platforms, ensure the APNS token is available before making any FCM plugin API calls
    final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
    if (apnsToken != null) {
      // APNS token is available, make FCM plugin API requests...
    }

    token = await FirebaseMessaging.instance.getToken();

    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      // TODO: If necessary send token to application server.

      // Note: This callback is fired at each app startup and whenever a new
      // token is generated.
    }).onError((err) {
      // Error getting token.
    });
  }

  // TODO notification whe app in foreground 
  // TODO homepage init state somehow
  static Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from a terminated state.
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat", navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  static void _handleMessage(RemoteMessage message) {
    print(" === opened notification: ${message.notification?.title}");
    if (message.data['type'] == 'chat') {
      print("this was a notification of type 'chat'");
    }
  }
}

// NOTE 1) setup
// https://firebase.google.com/docs/cloud-messaging/flutter/client
// NOTE 2) test
// https://firebase.google.com/docs/cloud-messaging/flutter/first-message
// TODO
// URGENT ended here
// NOTE 3) foreground
//https://firebase.google.com/docs/cloud-messaging/flutter/receive
// NOTE 3) server
// https://firebase.google.com/docs/cloud-messaging/server