import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gatherly/app/app_module.dart';
import 'package:gatherly/app/app_widget.dart';
import 'package:gatherly/firebase_options.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final messaging = FirebaseMessaging.instance;

  final settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (Platform.isAndroid) {
    // Solicitar permissão para notificações no Android 13+
    if (await Permission.notification.request().isDenied) {
      // Permissão negada
      print('Notification permission denied');
    }
  }

  String? token = await messaging.getToken();

  final _messageStreamController = BehaviorSubject<RemoteMessage>();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (kDebugMode) {
      print('Handling a foreground message: ${message.messageId}');
      print('Message data: ${message.data}');
      print('Message notification: ${message.notification?.title}');
      print('Message notification: ${message.notification?.body}');
    }

    _messageStreamController.sink.add(message);
  });
  runApp(ModularApp(module: AppModule(), child: const MyApp()));
}
