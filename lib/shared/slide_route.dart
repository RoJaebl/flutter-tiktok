import 'package:flutter/material.dart';


PageRouteBuilder<dynamic> slideRoute({required Widget screen}) {

  return PageRouteBuilder(

    transitionsBuilder: (context, animation, secondaryAnimation, child) {

      late final Animation<Offset> panelAnimation = Tween(

        begin: const Offset(1, 0),

        end: Offset.zero,

      ).animate(animation);


      return SlideTransition(

        position: panelAnimation,

        child: child,

      );

    },

    pageBuilder: (context, animation, secondaryAnimation) => screen,

  );

}

