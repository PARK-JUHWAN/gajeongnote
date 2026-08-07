import 'package:flutter/widgets.dart';
import '../design/tokens.dart';
import '../design/kbreak.dart';

class VoiceSegment extends StatelessWidget {
  final Track track;
  final ValueChanged<Track> onChange;
  const VoiceSegment({super.key, required this.track, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 4, bottom: 26),
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
          color: T.g100, borderRadius: BorderRadius.circular(T.rSeg)),
      child: Row(
        children: Track.values.map((t) {
          final on = t == track;
          return Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onChange(t),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: T.ease,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: on ? T.w : const Color(0x00000000),
                  borderRadius: BorderRadius.circular(T.rSeg - 3),
                  boxShadow: on
                      ? const [
                          BoxShadow(
                              color: Color(0x17191F28),
                              blurRadius: 3,
                              offset: Offset(0, 1))
                        ]
                      : null,
                ),
                child: KText(t.segLabel,
                    style: TextStyle(
                        fontFamily: T.ff,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.3,
                        color: on ? t.accent : T.g500)),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class VoiceSwap extends StatelessWidget {
  final Widget child;
  final Object swapKey;
  const VoiceSwap({super.key, required this.child, required this.swapKey});

  @override
  Widget build(BuildContext context) {
    final reduce = MediaQuery.of(context).disableAnimations;
    if (reduce) return KeyedSubtree(key: ValueKey(swapKey), child: child);

    return AnimatedSwitcher(
      duration: T.dVoice,
      switchInCurve: const Interval(0.5, 1, curve: T.ease),
      switchOutCurve: const Interval(0.5, 1, curve: T.ease),
      transitionBuilder: (c, a) => FadeTransition(
        opacity: a,
        child: SlideTransition(
          position: Tween(begin: const Offset(0, 0.028), end: Offset.zero)
              .animate(a),
          child: c,
        ),
      ),
      layoutBuilder: (cur, prev) => Stack(
          alignment: Alignment.topLeft, children: [...prev, if (cur != null) cur]),
      child: KeyedSubtree(key: ValueKey(swapKey), child: child),
    );
  }
}
