enum NavigatorRoute {
  home,
  newRoutine;

  static NavigatorRoute matchRoute(String routeName) {
    return NavigatorRoute.values.firstWhere((element) => element.name == routeName,
        orElse: () => throw Exception('Path $routeName does not exist'));
  }
}
