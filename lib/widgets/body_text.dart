import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import '../design/tokens.dart';
import '../models/chapter.dart';
import 'svg_icon.dart';
import '../design/kbreak.dart';

final _mark = RegExp(r'\{\{(.+?)\}\}', dotAll: true);

List<TextSpan> _spans(String src, TextStyle base, Color accent) {
  // 먼저 강조 구간을 조각으로 나눈다.
  final parts = <String>[];
  final hot = <bool>[];
  var i = 0;
  for (final m in _mark.allMatches(src)) {
    if (m.start > i) {
      parts.add(src.substring(i, m.start));
      hot.add(false);
    }
    parts.add(m.group(1)!);
    hot.add(true);
    i = m.end;
  }
  if (i < src.length) {
    parts.add(src.substring(i));
    hot.add(false);
  }

  // 어절 줄바꿈은 조각 경계를 넘어 한 번에 적용한다.
  // 「{{연결점}}이다」처럼 강조가 어절 가운데서 끝나는 자리가 있어서다.
  final wrapped = kbRuns(parts);

  final hi = base.copyWith(color: accent, fontWeight: FontWeight.w600);
  return [
    for (var k = 0; k < wrapped.length; k++)
      TextSpan(text: wrapped[k], style: hot[k] ? hi : null),
  ];
}

class BlockView extends StatelessWidget {
  final Block block;
  final Color accent;
  const BlockView(this.block, {super.key, required this.accent});

  Future<void> _openUrl(String urlString) async {
    if (urlString.isEmpty) return;
    final uri = Uri.parse(urlString);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      // 링크 열기 실패 시 예외 무시
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (block.type) {
      case BlockType.lead:
        final s = T.body.copyWith(
            fontSize: 17.5, color: T.g900, height: 1.72, fontWeight: FontWeight.w500);
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Text.rich(TextSpan(children: _spans(block.p, s, accent), style: s)),
        );

      case BlockType.p:
        return Padding(
          padding: const EdgeInsets.only(bottom: 18),
          child: Text.rich(
              TextSpan(children: _spans(block.p, T.body, accent), style: T.body)),
        );

      case BlockType.ref:
        return Container(
          margin: const EdgeInsets.only(top: 12),
          padding: const EdgeInsets.only(top: 18),
          decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: T.g100, width: 1))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              KText(block.p,
                  style: const TextStyle(
                      fontFamily: T.ff,
                      fontSize: 12.5,
                      height: 1.7,
                      color: T.g500,
                      fontWeight: FontWeight.w400)),
              if (block.links != null && block.links!.isNotEmpty) ...[
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final link in block.links!)
                      GestureDetector(
                        onTap: () => _openUrl(link.url),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: T.g50,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: T.g200, width: 0.8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                link.label,
                                style: const TextStyle(
                                  fontFamily: T.ff,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: T.g700,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                '↗',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: T.g500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        );

      case BlockType.notice:
        return Container(
          margin: const EdgeInsets.only(top: 8, bottom: 18),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
              color: T.famBg, borderRadius: BorderRadius.circular(T.rNotice)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const ChIcon('call', color: T.fam, size: 15),
              const SizedBox(width: 6),
              KText(block.h ?? '이럴 땐 연락하세요',
                  style: const TextStyle(
                      fontFamily: T.ff,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: T.fam)),
            ]),
            const SizedBox(height: 7),
            KText(block.p,
                style: const TextStyle(
                    fontFamily: T.ff,
                    fontSize: 14.5,
                    height: 1.65,
                    fontWeight: FontWeight.w500,
                    color: T.noticeInk)),
          ]),
        );
    }
  }
}