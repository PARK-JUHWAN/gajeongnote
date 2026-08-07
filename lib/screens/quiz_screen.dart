import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../design/tokens.dart';
import '../state/app_state.dart';
import '../widgets/app_shell.dart';
import '../widgets/cta_bar.dart';
import '../widgets/svg_icon.dart';
import '../design/kbreak.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _i = 0;
  int? _picked;

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final ch = s.current;
    if (ch == null || ch.quiz.isEmpty) return const SizedBox.shrink();
    final t = s.track;
    final q = ch.quiz[_i];
    final answered = _picked != null;
    final ok = _picked == q.answer;
    final last = _i == ch.quiz.length - 1;

    return AppShell(
      onBack: () => Navigator.of(context).pop(),
      bottom: !answered
          ? null
          : CtaBar(
              label: last ? '차례로 돌아가기' : '다음 문제',
              accent: t.accent,
              toned: true,
              onTap: () {
                if (last) {
                  Navigator.of(context).pop();
                } else {
                  setState(() {
                    _i++;
                    _picked = null;
                  });
                }
              },
            ),
      child: ViewIn(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(T.pad, 12, T.pad, 36),
          children: [
            KText(
                '확인 · ${ch.id.toString().padLeft(2, '0')}'
                '${ch.quiz.length > 1 ? '  ${_i + 1}/${ch.quiz.length}' : ''}',
                style: T.label.copyWith(color: t.accent, fontSize: 12.5)),
            const SizedBox(height: 14),
            KText(q.q, style: T.h1.copyWith(fontSize: 22, height: 1.45)),
            const SizedBox(height: 26),
            for (var k = 0; k < q.options.length; k++)
              _Opt(
                text: q.options[k],
                state: !answered
                    ? _OptState.idle
                    : (k == q.answer
                        ? _OptState.hit
                        : (k == _picked ? _OptState.miss : _OptState.dim)),
                accent: t.accent,
                onTap: answered ? null : () => setState(() => _picked = k),
              ),
            if (answered) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                    color: T.g50, borderRadius: BorderRadius.circular(T.rNotice)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        ChIcon('check', color: ok ? t.accent : T.g600, size: 15),
                        const SizedBox(width: 6),
                        KText(ok ? '맞습니다' : '다시 볼까요',
                            style: TextStyle(
                                fontFamily: T.ff,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: ok ? t.accent : T.g600)),
                      ]),
                      const SizedBox(height: 8),
                      KText(q.explain,
                          style: const TextStyle(
                              fontFamily: T.ff,
                              fontSize: 14.5,
                              height: 1.7,
                              letterSpacing: -0.3,
                              color: T.g700)),
                    ]),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

enum _OptState { idle, hit, miss, dim }

class _Opt extends StatelessWidget {
  final String text;
  final _OptState state;
  final Color accent;
  final VoidCallback? onTap;
  const _Opt(
      {required this.text,
      required this.state,
      required this.accent,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    final (bg, ink) = switch (state) {
      _OptState.idle => (T.w, T.g800),
      _OptState.hit => (accent.withValues(alpha: .07), accent),
      _OptState.miss => (T.w, T.g500),
      _OptState.dim => (T.w, T.g400),
    };
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: T.ease,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(T.rButton),
            border: Border.all(
                color: state == _OptState.hit ? accent : T.g200, width: 1),
          ),
          child: KText(text,
              style: TextStyle(
                  fontFamily: T.ff,
                  fontSize: 15,
                  height: 1.5,
                  letterSpacing: -0.3,
                  fontWeight:
                      state == _OptState.hit ? FontWeight.w600 : FontWeight.w500,
                  color: ink)),
        ),
      ),
    );
  }
}
