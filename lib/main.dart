import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:playstage/components/push_notification.dart';
import 'package:playstage/firebase_options.dart';
import 'package:playstage/people/main_view.dart';
import 'package:playstage/sign_in/sign_in.dart';
import 'package:playstage/utils/notification_service.dart';
import 'package:sendbird_sdk/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'const.dart';
import 'languages.dart';

@pragma('vm:entry-point')
Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print("Handling background message: ${message.messageId}");
  }

  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  NotificationService.showNotification(
    message.notification?.title ?? '',
    message.notification?.body ?? '',
  );
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  logger.i("notification tapped", response);
  if (kDebugMode) {
    print("notification tapped");
  }
  Get.toNamed("EmptyRoute");
}

void onRecieveLocalNotification(
    int i, String? one, String? two, String? three) {
  logger.i("notification tapped");
  if (kDebugMode) {
    print("notification tapped");
  }
  Get.toNamed("EmptyRoute");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool(keyLoggedIn) ?? false;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );

  const DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
    onDidReceiveLocalNotification: onRecieveLocalNotification,
  );

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse:
        (NotificationResponse notificationResponse) async {
      if (kDebugMode) {
        print("Notification Recieved with flutterLocalNotificationsPlugin");
      }
    },
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );

  // Use DefaultFirebaseOptions to allow web app
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(PlayStageApp(isLoggedIn: isLoggedIn));
}

final appState = AppState();

class AppState with ChangeNotifier {
  bool didRegisterToken = false;
  String? token;
  String? destChannelUrl;

  void setDestination(String? channelUrl) {
    destChannelUrl = channelUrl;
    notifyListeners();
  }
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.high,
  playSound: true,
);

class PlayStageApp extends StatefulWidget {
  final bool isLoggedIn;

  const PlayStageApp({super.key, required this.isLoggedIn});

  @override
  State<PlayStageApp> createState() => _PlayStageAppState();
}

class _PlayStageAppState extends State<PlayStageApp> {
  // This widget is the root of your application.
  late int _totalNotifications;
  late final FirebaseMessaging _messaging;
  PushNotification? _notificationInfo;

  // [Push Notification Set Up]
  void requestAndRegisterNotification() async {
    // Initialize the Firebase app
    await Firebase.initializeApp();

    // Instantiate Firebase Messaging
    _messaging = FirebaseMessaging.instance;
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // To enable foreground notification in firebase messaging for IOS
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    // On iOS, this helps to take the user permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('User granted permission');
      }
      String? token;

      if (Platform.isIOS) {
        //Retrieve pushtoken for IOS
        token = await _messaging.getAPNSToken();
      } else {
        // Retrieve pushtoken for FCM
        token = await _messaging.getToken();
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (token != null) {
        prefs.setString(keyPushToken, token);
      }

      appState.token = token;
      // For handling the received notifications
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (kDebugMode) {
          print('title: ${message.notification?.title}');
          print('body: ${message.notification?.body}');
        }
        // Parse the message received
        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
        );

        setState(() {
          _notificationInfo = notification;
          _totalNotifications++;
        });
        if (_notificationInfo != null) {
          NotificationService.showNotification(
              _notificationInfo?.title ?? '', _notificationInfo?.body ?? '');
        }
      });
    } else {
      if (kDebugMode) {
        print('User declined or has not accepted permission');
      }
    }
  }

  @override
  void initState() {
    requestAndRegisterNotification();
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotification notification = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
      );
      setState(() {
        _notificationInfo = notification;
        _totalNotifications++;
      });
    });
    _totalNotifications = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: Languages(),
      locale: Get.deviceLocale,
      fallbackLocale: const Locale('ko', 'KR'),
      initialRoute: widget.isLoggedIn ? '/main_view' : '/sign_in',
      routes: {
        '/main_view': (context) => const MainView(),
        '/sign_in': (context) => const SignIn(),
      },
    );
  }
}
