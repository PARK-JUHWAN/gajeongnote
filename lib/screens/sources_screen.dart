import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../design/tokens.dart';
import '../state/app_state.dart';
import '../widgets/app_shell.dart';
import '../design/kbreak.dart';

class SourcesScreen extends StatelessWidget {
  const SourcesScreen({super.key});

  Future<void> _openUrl(String urlString) async {
    if (urlString.isEmpty) return;
    final uri = Uri.parse(urlString);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      // 링크 열기 실패 시 조용히 무시
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>().sources;
    return AppShell(
      onBack: () => Navigator.of(context).pop(),
      child: ViewIn(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(T.pad, 16, T.pad, 44),
          children: [
            const KText('근거 자료', style: T.h2),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                  color: T.g50, borderRadius: BorderRadius.circular(T.rNotice)),
              child: KText(s.intro,
                  style: const TextStyle(
                      fontFamily: T.ff,
                      fontSize: 14.5,
                      height: 1.7,
                      letterSpacing: -0.3,
                      fontWeight: FontWeight.w500,
                      color: T.g800)),
            ),
            const SizedBox(height: 30),
            for (final g in s.groups) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  KText(g.title,
                      style: const TextStyle(
                          fontFamily: T.ff,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.35,
                          color: T.g900)),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _openUrl(g.url),
                    child: KText(
                      g.domain,
                      style: const TextStyle(
                          fontFamily: T.ff,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: T.g400,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              for (final it in g.items)
                Padding(
                  padding: const EdgeInsets.only(bottom: 9),
                  child: GestureDetector(
                    onTap: () => _openUrl(it.url),
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 3,
                          height: 3,
                          margin: const EdgeInsets.only(top: 9, right: 9),
                          decoration: const BoxDecoration(
                              color: T.g400, shape: BoxShape.circle),
                        ),
                        Expanded(
                          child: KText(
                            it.name,
                            style: const TextStyle(
                                fontFamily: T.ff,
                                fontSize: 14,
                                height: 1.6,
                                letterSpacing: -0.3,
                                color: T.g700,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 24),
            ],
            Container(
              padding: const EdgeInsets.only(top: 18),
              decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: T.g100, width: 1))),
              child: KText(s.outro,
                  style: const TextStyle(
                      fontFamily: T.ff,
                      fontSize: 12.5,
                      height: 1.7,
                      color: T.g500)),
            ),
          ],
        ),
      ),
    );
  }
}