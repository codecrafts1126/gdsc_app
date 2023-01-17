import 'package:flutter/material.dart';

PageRouteBuilder customSlideTransitionRight(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        SlideTransition(
      position: animation.drive(
          Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
              .chain(CurveTween(curve: Curves.ease))),
      child: child,
    ),
  );
}

PageRouteBuilder customSlideTransitionDown(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        SlideTransition(
      position: animation.drive(
          Tween(begin: const Offset(0, 1.0), end: Offset.zero)
              .chain(CurveTween(curve: Curves.ease))),
      child: child,
    ),
  );
}

PageRouteBuilder customSlideTransitionLeft(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        SlideTransition(
      position: animation.drive(
          Tween(begin: const Offset(-1.0, 0.0), end: Offset.zero)
              .chain(CurveTween(curve: Curves.ease))),
      child: child,
    ),
  );
}
