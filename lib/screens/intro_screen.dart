import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../design/tokens.dart';
import '../state/app_state.dart';
import '../widgets/app_shell.dart';
import '../widgets/cta_bar.dart';
import '../design/kbreak.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  static const items = [
    '의료기기가 아닙니다. 어떤 질병도 진단·치료·완화·예방하지 않습니다.',
    '건강에 관한 판단은 반드시 의사 등 의료 전문가와 상담하세요.',
    '개인 건강정보를 수집하거나 저장하지 않습니다. 읽은 위치만 이 기기에 남습니다.',
  ];

  @override
  Widget build(BuildContext context) {
    final s = context.read<AppState>();
    return AppShell(
      bottom: CtaBar(
        label: '확인했습니다',
        accent: T.nurse,
        onTap: s.ackDisclaimer,
      ),
      child: ViewIn(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(T.pad, 40, T.pad, 24),
          children: [
            const KText('가정간호를\n배우는 앱입니다', style: T.h2),
            const SizedBox(height: 16),
            const KText(
                '제도와 관련 지식을 공부하기 위한 학습 자료입니다. 시작하기 전에 세 가지만 확인해 주세요.',
                style: TextStyle(
                    fontFamily: T.ff,
                    fontSize: 15.5,
                    height: 1.7,
                    letterSpacing: -0.3,
                    color: T.g600)),
            const SizedBox(height: 34),
            for (var i = 0; i < items.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child:
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                    width: 24,
                    height: 24,
                    margin: const EdgeInsets.only(top: 3),
                    decoration: BoxDecoration(
                        color: T.g100, borderRadius: BorderRadius.circular(8)),
                    alignment: Alignment.center,
                    child: KText('${i + 1}',
                        style: const TextStyle(
                            fontFamily: T.ff,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: T.g600)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: KText(items[i],
                        style: const TextStyle(
                            fontFamily: T.ff,
                            fontSize: 15,
                            height: 1.72,
                            letterSpacing: -0.35,
                            fontWeight: FontWeight.w500,
                            color: T.g800)),
                  ),
                ]),
              ),
          ],
        ),
      ),
    );
  }
}
