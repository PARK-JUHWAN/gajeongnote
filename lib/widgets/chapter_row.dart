import 'package:flutter/widgets.dart';
import '../design/tokens.dart';
import '../design/ch_icons.dart';
import '../models/chapter.dart';
import 'svg_icon.dart';
import '../design/kbreak.dart';

class ChapterRow extends StatelessWidget {
  final Chapter ch;
  final Track track;

  final bool read;

  final bool empty;
  final VoidCallback onTap;

  const ChapterRow(
      {super.key,
      required this.ch,
      required this.track,
      required this.read,
      required this.empty,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final badgeBg = read ? track.accentBg : T.g50;
    final badgeInk = read ? track.accent : (empty ? T.g400 : T.g600);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11),
        child: Row(children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
                color: badgeBg, borderRadius: BorderRadius.circular(T.rBadge)),
            alignment: Alignment.center,
            child: ChIcon(ch.icon, color: badgeInk, size: 21),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Flexible(
                      child: KText(ch.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontFamily: T.ff,
                              fontSize: 15.5,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.4,
                              height: 1.35,
                              color: empty ? T.g500 : T.g900)),
                    ),
                    if (ch.core) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2.5),
                        decoration: BoxDecoration(
                            color: track.accentBg,
                            borderRadius: BorderRadius.circular(6)),
                        child: KText('핵심',
                            style: TextStyle(
                                fontFamily: T.ff,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: track.accent)),
                      ),
                    ],
                  ]),
                  const SizedBox(height: 3),
                  Row(children: [
                    KText(ch.id.toString().padLeft(2, '0'),
                        style: const TextStyle(
                            fontFamily: T.ff,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: T.g400)),
                    if (ch.ref.isNotEmpty) ...[
                      const SizedBox(width: 7),
                      Flexible(
                        child: KText(ch.ref,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontFamily: T.ff,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: T.g500)),
                      ),
                    ],
                    if (empty) ...[
                      const SizedBox(width: 7),
                      const KText('작성 대기',
                          style: TextStyle(
                              fontFamily: T.ff,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: T.g400)),
                    ],
                  ]),
                ]),
          ),
          const SizedBox(width: 8),
          const RawIcon(ChIcons.chevron, color: T.g400, size: 18),
        ]),
      ),
    );
  }
}
