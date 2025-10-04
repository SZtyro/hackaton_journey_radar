// ignore_for_file: lines_longer_than_80_chars

import 'package:go_router/go_router.dart';
import 'package:journey_radar_mobile/features/auth_page.dart';
import 'package:journey_radar_mobile/features/home_page.dart';
import 'package:journey_radar_mobile/routes/app_routes.dart';


/// AppRouter handles navigation and redirection logic for the app using GoRouter.
/// It manages app initialization, permission checks, and deep route linking.
class AppRouter {

  AppRouter();

  GoRouter router() => GoRouter(
        debugLogDiagnostics: true,
        initialLocation: AppRoutes.auth.route,
        routes: [
          GoRoute(
            path: AppRoutes.home.route,
            name: AppRoutes.home.name,
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: AppRoutes.auth.route,
            name: AppRoutes.auth.name,
            builder: (context, state) => const AuthPage(),
          ),
        ],
      );
}
