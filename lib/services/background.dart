import 'package:background_fetch/background_fetch.dart';
import '../database/server.dart';

void _callback([bool push = false]) async {
  print('[BackgroundFetch] Event starting.');
  DateTime now = DateTime.now();
  await for (final photo in PhotoServer.getActive()) {
    if (photo.targetTime.isBefore(now)) {
      PhotoServer.update(photo.id);
      if (push) {
        // TODO: Find how to send push notificaitons
        // pushNotif("A new Photo is available");
      }
    }
  }
  BackgroundFetch.finish();
}

void backgroundFetchHeadlessTask() async {
  print('[BackgroundFetch] Headless event received.');
  _callback(true);
  
}

Future<void> initBackgroundState() async {
    BackgroundFetch.configure(
      BackgroundFetchConfig(
        minimumFetchInterval: 15,
        stopOnTerminate: false,
        enableHeadless: false,
        startOnBoot: true
      ), 
      _callback,
    );
  }