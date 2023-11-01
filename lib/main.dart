import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:oapp/pages/signin.dart';

// TODO ios settings from firebase console: https://console.firebase.google.com/u/0/project/oapp-50c16/settings/general/ios:cz.ocompany.oapp

void main() async {
  /* WidgetsBinding widgetsBinding =  */ WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  /* if (kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  } else {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  } */

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) =>
      MaterialApp(title: 'Flutter Demo', theme: ThemeData(primarySwatch: Colors.blue), home: const SignInPage());
}
