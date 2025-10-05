import 'package:journey_radar_mobile/app_view.dart';
import 'package:journey_radar_mobile/bootstrap.dart';
import 'package:journey_radar_mobile/firebase_options.dart';

void main() {
  bootstrap(
    () async {
      return const AppView();
    },
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
