enum AppRoutes {
  auth('/auth'),
  home('/home'),
  ;

  /// Defines all application routes with associated paths.
  const AppRoutes(this.route);

  final String route;
}

extension AppRoutesExtension on AppRoutes {
  /// Returns the route path without any dynamic parameter segments.
  String get pathWithoutArgs {
    // Split the route on '/:' to remove parameter segments and return the base path.
    return route.split('/:').first;
  }
}
