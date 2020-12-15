import 'package:flutter/material.dart';
import '../../Routes.dart';


class NavigatorService{
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final routes = AppRoutes().routes;

  Future<dynamic> navigateToAndRemove(String route) {
    return navigatorKey.currentState.pushNamedAndRemoveUntil(route, (route) => false);
  }

  void pop() {
    return navigatorKey.currentState.pop();
  }

  GlobalKey<NavigatorState> getGlobalKey()
  {
    return navigatorKey;
  }

  void navigateToAnimated(String route) {
    navigatorKey.currentState.push(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => routes[route],
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var tween = Tween(
          begin: Offset(0.0, 1.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.ease));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    ));
  }
}