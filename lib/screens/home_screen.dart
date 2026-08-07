import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../design/routes.dart';
import '../design/tokens.dart';
import '../design/ch_icons.dart';
import '../state/app_state.dart';
import '../widgets/app_shell.dart';
import '../widgets/svg_icon.dart';
import 'toc_screen.dart';
import 'settings_screen.dart';
import '../design/kbreak.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    return AppShell(
      onGear: () => Navigator.of(context)
          .push(fadeRoute(const SettingsScreen())),
      child: ViewIn(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(T.pad, 20, T.pad, 32),
          children: [
            const KText('누구에게 필요한\n내용인가요?', style: T.h2),
            const SizedBox(height: 14),
            const KText('같은 주제를 두 가지 방식으로 정리했습니다. 언제든 바꿔 볼 수 있어요.',
                style: TextStyle(
                    fontFamily: T.ff,
                    fontSize: 15,
                    height: 1.7,
                    letterSpacing: -0.3,
                    color: T.g600)),
            const SizedBox(height: 30),
            _Card(
              track: Track.nurse,
              eyebrow: '전문가용',
              title: '간호사 · 학생',
              desc: '제도의 근거와 기전 중심. 법조문과 지침 권고를 함께 봅니다.',
              count: s.chapters.length,
              onTap: () => _open(context, s, Track.nurse),
            ),
            const SizedBox(height: 12),
            _Card(
              track: Track.family,
              eyebrow: '일반용',
              title: '대상자 · 가족',
              desc: '집에서 돌보는 분을 위한 설명. 쉬운 말로 다시 썼습니다.',
              count: s.chapters.length,
              onTap: () => _open(context, s, Track.family),
            ),
          ],
        ),
      ),
    );
  }

  void _open(BuildContext c, AppState s, Track t) {
    s.setTrack(t);
    Navigator.of(c).push(fadeRoute(const TocScreen()));
  }
}

class _Card extends StatelessWidget {
  final Track track;
  final String eyebrow, title, desc;
  final int count;
  final VoidCallback onTap;
  const _Card(
      {required this.track,
      required this.eyebrow,
      required this.title,
      required this.desc,
      required this.count,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
            color: T.g50, borderRadius: BorderRadius.circular(T.rCard)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          KText(eyebrow,
              style: TextStyle(
                  fontFamily: T.ff,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                  color: track.accent)),
          const SizedBox(height: 7),
          KText(title, style: T.h1.copyWith(fontSize: 21)),
          const SizedBox(height: 9),
          KText(desc,
              style: const TextStyle(
                  fontFamily: T.ff,
                  fontSize: 14,
                  height: 1.65,
                  letterSpacing: -0.3,
                  color: T.g600)),
          const SizedBox(height: 18),
          Row(children: [
            KText('$count개 주제',
                style: const TextStyle(
                    fontFamily: T.ff,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: T.g500)),
            const Spacer(),
            RawIcon(ChIcons.chevron, color: track.accent, size: 18),
          ]),
        ]),
      ),
    );
  }
}
