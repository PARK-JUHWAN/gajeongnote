import 'package:flutter/widgets.dart';
import 'tokens.dart';

PageRoute<R> fadeRoute<R>(Widget page, [RouteSettings? settings]) =>
    PageRouteBuilder<R>(
      settings: settings,
      transitionDuration: T.dView,
      reverseTransitionDuration: T.dView,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (context, a, _, child) {
        if (MediaQuery.of(context).disableAnimations) return child;
        final c = CurvedAnimation(parent: a, curve: T.ease);
        return FadeTransition(
          opacity: c,
          child: SlideTransition(
            position:
                Tween(begin: const Offset(0, .012), end: Offset.zero).animate(c),
            child: child,
          ),
        );
      },
    );
