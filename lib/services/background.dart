import 'package:background_fetch/background_fetch.dart';
import '../database/server.dart';
import '../database/models.dart';

void backgroundFetchHeadlessTask() async {
  print('[BackgroundFetch] Headless event received.');
  BackgroundFetch.finish();
}

Future<void> initPlatformState() async {
    // Configure BackgroundFetch.
    BackgroundFetch.configure(BackgroundFetchConfig(
        minimumFetchInterval: 15,
        stopOnTerminate: false,
        enableHeadless: false,
        startOnBoot: true
    ), () async {
      DateTime now = DateTime.now();
      await for (final photo in PhotoServer.getActive()) {
        if (photo.targetTime.isBefore(now)) {
          PhotoServer.update(photo.id);
        }
      }
    });
  }