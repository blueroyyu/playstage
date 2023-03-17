import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playstage/people/main_view.dart';
import 'package:playstage/sign_in/sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'languages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLogged') ?? false;

  runApp(PlayStageApp(isLoggedIn: isLoggedIn));
}

class PlayStageApp extends StatelessWidget {
  final bool isLoggedIn;

  const PlayStageApp({super.key, required this.isLoggedIn});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: Languages(),
      locale: Get.deviceLocale,
      fallbackLocale: const Locale('ko', 'KR'),
      initialRoute: isLoggedIn ? '/main_view' : '/sign_in',
      routes: {
        '/main_view': (context) => const MainView(),
        '/sign_in': (context) => const SignIn(),
      },
    );
  }
}

