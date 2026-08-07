import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../design/ch_icons.dart';

String _hex(Color c) {
  int ch(double v) => (v * 255).round().clamp(0, 255);
  final rgb = (ch(c.r) << 16) | (ch(c.g) << 8) | ch(c.b);
  return '#${rgb.toRadixString(16).padLeft(6, '0')}';
}

class ChIcon extends StatelessWidget {
  final String name;
  final Color color;
  final double size;
  const ChIcon(this.name, {super.key, required this.color, this.size = 21});

  @override
  Widget build(BuildContext context) => SvgPicture.string(
        ChIcons.svg(name, hex: _hex(color), size: size),
        width: size,
        height: size,
      );
}

class RawIcon extends StatelessWidget {
  final String inner;
  final Color color;
  final double size;
  const RawIcon(this.inner, {super.key, required this.color, this.size = 22});

  @override
  Widget build(BuildContext context) => SvgPicture.string(
        ChIcons.raw(inner, hex: _hex(color), size: size),
        width: size,
        height: size,
      );
}
