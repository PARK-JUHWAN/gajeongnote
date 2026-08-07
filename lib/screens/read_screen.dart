import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../design/routes.dart';
import '../design/tokens.dart';
import '../state/app_state.dart';
import '../widgets/app_shell.dart';
import '../widgets/body_text.dart';
import '../widgets/cta_bar.dart';
import '../widgets/svg_icon.dart';
import '../widgets/voice_segment.dart';
import 'quiz_screen.dart';
import 'settings_screen.dart';
import '../design/kbreak.dart';

class ReadScreen extends StatelessWidget {
  const ReadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final ch = s.current;
    if (ch == null) return const SizedBox.shrink();
    final t = s.track;
    final blocks = ch.body(t.isNurse);
    final hasQuiz = ch.quiz.isNotEmpty;

    return AppShell(
      onBack: () => Navigator.of(context).pop(),
      onGear: () => Navigator.of(context)
          .push(fadeRoute(const SettingsScreen())),
      bottom: blocks.isEmpty
          ? null
          : CtaBar(
              label: hasQuiz ? '확인 문제 풀기' : '읽었습니다',
              accent: t.accent,
              toned: true,
              onTap: () {
                s.markRead(ch.id, t);
                if (hasQuiz) {
                  Navigator.of(context).push(
                      fadeRoute(const QuizScreen()));
                } else {
                  Navigator.of(context).pop();
                }
              },
            ),
      child: ViewIn(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(T.pad, 0, T.pad, 36),
          children: [
            VoiceSegment(track: t, onChange: s.setTrack),
            Row(children: [
              ChIcon(ch.icon, color: t.accent, size: 16),
              const SizedBox(width: 7),
              KText('${ch.id.toString().padLeft(2, '0')} · ${ch.title}',
                  style: T.label.copyWith(color: T.g500, fontSize: 12.5)),
            ]),
            const SizedBox(height: 14),
            VoiceSwap(
              swapKey: '${ch.id}_${t.name}',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: blocks.isEmpty
                    ? const [_Pending()]
                    : [for (final b in blocks) BlockView(b, accent: t.accent)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Pending extends StatelessWidget {
  const _Pending();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
          color: T.g50, borderRadius: BorderRadius.circular(T.rCard)),
      child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        KText('이 갈래의 본문은 아직 없습니다',
            style: TextStyle(
                fontFamily: T.ff,
                fontSize: 15.5,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.35,
                color: T.g800)),
        SizedBox(height: 8),
        KText('다른 갈래로 바꿔 보시거나, 차례에서 다른 주제를 골라 주세요.',
            style: TextStyle(
                fontFamily: T.ff,
                fontSize: 14,
                height: 1.65,
                letterSpacing: -0.3,
                color: T.g600)),
      ]),
    );
  }
}
