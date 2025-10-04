import 'package:journey_radar_mobile/app_view.dart';
import 'package:journey_radar_mobile/bootstrap.dart';

void main() {
  bootstrap(
    () async {
      return const AppView();
    },
    // options: DefaultFirebaseOptions.currentPlatform,
  );
}
