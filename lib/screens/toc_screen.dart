import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../design/routes.dart';
import '../design/tokens.dart';
import '../state/app_state.dart';
import '../widgets/app_shell.dart';
import '../widgets/chapter_row.dart';
import 'read_screen.dart';
import 'settings_screen.dart';
import '../design/kbreak.dart';

class TocScreen extends StatelessWidget {
  const TocScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final t = s.track;
    return AppShell(
      onBack: () => Navigator.of(context).pop(),
      onGear: () => Navigator.of(context)
          .push(fadeRoute(const SettingsScreen())),
      child: ViewIn(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(T.pad, 20, T.pad, 40),
          children: [
            KText(t.tocEyebrow,
                style: T.label.copyWith(color: t.accent, fontSize: 12.5)),
            const SizedBox(height: 6),
            const KText('차례', style: T.h2),
            const SizedBox(height: 22),
            for (final c in s.chapters)
              ChapterRow(
                ch: c,
                track: t,
                read: s.isRead(c.id, t),
                empty: !c.written(t.isNurse),
                onTap: () {
                  s.openChapter(c.id);
                  Navigator.of(context).push(
                      fadeRoute(const ReadScreen()));
                },
              ),
          ],
        ),
      ),
    );
  }
}
