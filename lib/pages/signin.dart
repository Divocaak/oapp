import 'package:flutter/material.dart';
import 'package:oapp/general/authentication.dart';
import 'package:oapp/pages/homepage.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  SignInPageState createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
      body: Center(
          child: FutureBuilder(
              key: const Key("loginStack"),
              future: Authentication.initializeFirebase(context),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(" === signin.dart: ${snapshot.error}");
                  return const Text('Error initializing Firebase', key: Key("firebaseInitError"));
                } else if (snapshot.connectionState == ConnectionState.done) {
                  return TextButton(
                      child: const Text("sign in google"),
                      onPressed: () async {
                        await Authentication.signIn(context);
                        if (Authentication.loggedInUser != null) {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (builder) => const HomePage()), (route) => false);
                        }
                      });
                }
                return const Center(child: CircularProgressIndicator());
              })));
}
