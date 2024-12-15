import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:http/http.dart' as http;
import 'package:motolisto/hooks/use_url.dart';

initializeMessaging() async {
  await checkMessagingPermission();
  FirebaseMessaging.instance.setAutoInitEnabled(true);
  FirebaseMessaging.onBackgroundMessage((RemoteMessage message) {
    debugPrint('🎸🎸🎸 onBackgroundMessage: $message');
    showFlutterNotification(message);
    return Future<void>.value();
  });
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    debugPrint('🎸🎸🎸 onMessage: $message');
    showFlutterNotification(message);
  });
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    debugPrint('🎸🎸🎸 onMessageOpenedApp: $message');
    showFlutterNotification(message);
  });
}

Future<void> checkMessagingPermission() async {
  NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    debugPrint('🎸🎸🎸 User granted permission');
    return;
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    debugPrint('🎸🎸🎸 User granted provisional permission');
    return;
  } else {
    debugPrint('🎸🎸🎸 User declined or has not accepted permission');
    openSettings();
  }
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  if (notification != null) {
    debugPrint('🎸🎸🎸 LOCAL Notification: ${notification.title}');
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    ));
    flutterLocalNotificationsPlugin.show(
      0,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'main_channel',
          'Main Channel',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }
}

Future sendNotificationCallable(List<String> tokens) async {
  HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
    'sendnotification',
    options: HttpsCallableOptions(
      timeout: Duration(seconds: 30),
      limitedUseAppCheckToken: false,
    ),
  );

  try {
    final result = await callable.call(<String, dynamic>{
      "title": "Hay un cliente cerca esperando",
      "body": "Revisa la lista de espera para atenderlo",
      "tokens": tokens,
    });

    debugPrint('🎸🎸🎸 Response data: ${result.data}');
  } catch (e) {
    debugPrint('🎸🎸🎸 Error: $e');
  }
}

Future sendNotification(List<String> tokens) async {
  Uri url = Uri.parse('https://sendnotification-w6y77l3ohq-uc.a.run.app');
  final response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "title": "Hay un cliente cerca esperando",
      "body": "Revisa la lista de espera para atenderlo",
      "tokens": jsonEncode(tokens.toList()),
    }),
  );

  if (response.statusCode == 200) {
    debugPrint('🎸🎸🎸 Response data: ${response.body}');
  } else {
    debugPrint('🎸🎸🎸 Error: ${response.body}');
  }
}
