import 'package:chp_app/widgets/event_details_scroll_effects.dart';
import 'package:flutter/material.dart';

class ReturnBack extends StatelessWidget {
  ReturnBack(this.scrollEffects);
  final EventDetailsScrollEffects scrollEffects;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 18,//MediaQuery.of(context).padding.top,
//      left: 2.0,
      child: IgnorePointer(
        ignoring: scrollEffects.backButtonOpacity == 0.0,
        child: Material(
          type: MaterialType.circle,
          color: Colors.transparent,
          child: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: Colors.white.withOpacity(
                scrollEffects.backButtonOpacity * 0.9,
              ),
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              onPressed: () {
                Navigator.maybePop(context);
              }
          ),
        ),
      ),
    );
  }
}
