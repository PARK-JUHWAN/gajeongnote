import 'package:flutter/widgets.dart';
import '../design/tokens.dart';
import '../design/ch_icons.dart';
import 'svg_icon.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  final VoidCallback? onBack;
  final VoidCallback? onGear;
  final Widget? bottom;
  const AppShell(
      {super.key, required this.child, this.onBack, this.onGear, this.bottom});

  @override
  Widget build(BuildContext context) {
    final hasNav = onBack != null || onGear != null;
    return Container(
      color: T.w,
      child: SafeArea(
        bottom: false,
        child: Column(children: [
          if (hasNav)
            SizedBox(
              height: 52,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(children: [
                  _NavBtn(inner: ChIcons.back, onTap: onBack, size: 22),
                  const Spacer(),
                  _NavBtn(inner: ChIcons.gear, onTap: onGear, size: 21),
                ]),
              ),
            ),
          Expanded(child: child),
          if (bottom != null) bottom!,
        ]),
      ),
    );
  }
}

class _NavBtn extends StatelessWidget {
  final String inner;
  final VoidCallback? onTap;
  final double size;
  const _NavBtn({required this.inner, this.onTap, required this.size});

  @override
  Widget build(BuildContext context) {
    if (onTap == null) return const SizedBox(width: 44, height: 44);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: 44,
        height: 44,
        child: Center(child: RawIcon(inner, color: T.g800, size: size)),
      ),
    );
  }
}

class ViewIn extends StatefulWidget {
  final Widget child;
  const ViewIn({super.key, required this.child});
  @override
  State<ViewIn> createState() => _ViewInState();
}

class _ViewInState extends State<ViewIn> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: T.dView);
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (MediaQuery.of(context).disableAnimations) {
      _c.value = 1;
    } else {
      _c.forward();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final a = CurvedAnimation(parent: _c, curve: T.ease);
    return FadeTransition(
      opacity: a,
      child: SlideTransition(
        position:
            Tween(begin: const Offset(0, .012), end: Offset.zero).animate(a),
        child: widget.child,
      ),
    );
  }
}
