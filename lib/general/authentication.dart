import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:oapp/pages/homepage.dart';
import 'package:oapp/pages/signin.dart';

class Authentication {
  static User? loggedInUser;
  static String? deviceId;
  static late FirebaseAuth auth;

  static Future<FirebaseApp> initializeFirebase(BuildContext context) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    auth = FirebaseAuth.instanceFor(app: firebaseApp);

    loggedInUser = auth.currentUser;
    //deviceId = await FirebaseMessaging.instance.getToken() ?? "";
    if (loggedInUser != null) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomePage()));
    }

    return firebaseApp;
  }

  static Future<AuthCredential?> signInWithGoogle(BuildContext context) async {
    GoogleSignInAccount? googleSignInAccount;
    try {
      googleSignInAccount = await GoogleSignIn().signIn();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
    }

    AuthCredential? credential;
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken, idToken: googleSignInAuthentication.idToken);
    }
    return credential;
  }

  static Future<void> signIn(BuildContext context) async {
    User? user;
    AuthCredential? credential = await signInWithGoogle(context);
    try {
      final UserCredential userCredential = await auth.signInWithCredential(credential!);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("The account already exists with a different credential.")));
      } else if (e.code == 'invalid-credential') {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Error occurred while accessing credentials. Try again.")));
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Error occurred using Google Sign-In. Try again.")));
    }

    loggedInUser = user;
  }

  static Future<void> signOut(BuildContext context) async {
    try {
      await GoogleSignIn().disconnect().whenComplete(() async => await auth.signOut());
      loggedInUser = null;
      Navigator.of(context)
          .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const SignInPage()), (r) => false);
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
