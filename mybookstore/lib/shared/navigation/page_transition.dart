import 'package:flutter/material.dart';

class PageTransition<T> extends PageRouteBuilder<T> {
  PageTransition({
    required this.child,
    required this.type,
    this.childCurrent,
    this.ctx,
    this.inheritTheme = false,
    this.curve = Curves.linear,
    this.alignment,
    this.duration = const Duration(milliseconds: 200),
    this.reverseDuration = const Duration(milliseconds: 200),
    this.isIos = false,
    this.matchingBuilder = const CupertinoPageTransitionsBuilder(),
    super.settings,
  })  : assert(
          inheritTheme ? ctx != null : true,
          "'ctx' cannot be null when 'inheritTheme' is true, set ctx: context",
        ),
        super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return inheritTheme
                ? InheritedTheme.captureAll(ctx!, child)
                : child;
          },
          maintainState: true,
        );

  final Alignment? alignment;

  final Widget child;

  final Widget? childCurrent;

  final BuildContext? ctx;

  final Curve curve;

  final Duration duration;

  final bool inheritTheme;
  final bool isIos;

  final PageTransitionsBuilder matchingBuilder;

  final Duration reverseDuration;

  final PageTransitionType type;

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    switch (type) {
      case PageTransitionType.theme:
        return Theme.of(context).pageTransitionsTheme.buildTransitions(
              this,
              context,
              animation,
              secondaryAnimation,
              child,
            );

      case PageTransitionType.rightToLeft:
        final slideTransition = SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
        if (isIos) {
          return matchingBuilder.buildTransitions(
            this,
            context,
            animation,
            secondaryAnimation,
            child,
          );
        }
        return slideTransition;

      case PageTransitionType.leftToRight:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );

      case PageTransitionType.bottomToTop:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
    }
  }

  @override
  Duration get reverseTransitionDuration => reverseDuration;

  @override
  Duration get transitionDuration => duration;
}

enum PageTransitionType { theme, rightToLeft, leftToRight, bottomToTop }
