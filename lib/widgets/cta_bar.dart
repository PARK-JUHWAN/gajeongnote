import 'package:flutter/widgets.dart';
import '../design/tokens.dart';
import '../design/kbreak.dart';

class CtaBar extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  final bool toned;
  final Color accent;
  const CtaBar(
      {super.key,
      required this.label,
      required this.onTap,
      required this.accent,
      this.toned = false});

  @override
  State<CtaBar> createState() => _CtaBarState();
}

class _CtaBarState extends State<CtaBar> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: T.w,
      padding: EdgeInsets.fromLTRB(
          T.pad, 8, T.pad, 12 + MediaQuery.of(context).padding.bottom),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _down = true),
        onTapCancel: () => setState(() => _down = false),
        onTapUp: (_) => setState(() => _down = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _down ? .976 : 1,
          duration: const Duration(milliseconds: 110),
          curve: T.ease,
          child: Container(
            height: T.ctaHeight,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: widget.toned ? widget.accent : T.g900,
                borderRadius: BorderRadius.circular(T.rButton)),
            child: KText(widget.label,
                style: const TextStyle(
                    fontFamily: T.ff,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
                    color: T.w)),
          ),
        ),
      ),
    );
  }
}
