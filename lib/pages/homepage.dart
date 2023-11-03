import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:oapp/general/authentication.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) => Scaffold(
          body: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
            Text("name: ${Authentication.loggedInUser?.displayName}"),
            Text("email: ${Authentication.loggedInUser?.email}"),
            Text("uid: ${Authentication.loggedInUser?.uid}"),
            Text("deviceId: ${Authentication.deviceId}"),
            TextButton(child: const Text("logout"), onPressed: () async => await Authentication.signOut(context)),
            TextButton(child: const Text("lat long"), onPressed: () async => print(await determinePosition())),
            // TODO send
            TextButton(
                child: const Text("setRegularLunchTimes - kdy chodíš na O"),
                onPressed: () async => print(await getLunchTimesToSend())),
            // TODO send
            TextButton(child: const Text("addToActiveUsers - jdeš dnes na O?"), onPressed: () {}),
            // TODO endpoint
            // TODO send
            TextButton(child: const Text("getUserForLunch - chci na O teď"), onPressed: () {}),
            // TODO endpoint
            // TODO send
            TextButton(child: const Text("replyToLunchOffer (1) - přijmout pozvánku na O"), onPressed: () {}),
            // TODO endpoint
            // TODO send
            TextButton(child: const Text("replyToLunchOffer (0) - odmítnout pozvánku na O"), onPressed: () {})
          ])));

  // NOTE to be used later (replyToLunchOffer)
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  // NOTE to be used later (getUserForLunch)
  String getStartTime() => DateTime.now().toString();

  Future<Map<String, TimeOfDay>?> getLunchTimesToSend() async {
    TimeOfDay? startTime = await showTimePicker(context: context, initialTime: const TimeOfDay(hour: 11, minute: 30));
    if (startTime == null) return null;
    TimeOfDay? endTime = await showTimePicker(context: context, initialTime: const TimeOfDay(hour: 13, minute: 00));
    if (endTime == null) return null;
    return {"timeFrom": startTime, "timeTo": endTime};
  }
}
