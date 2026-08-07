import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import '../design/kbreak.dart';
import '../design/tokens.dart';
import '../widgets/app_shell.dart';

void registerFontLicense() {
  LicenseRegistry.addLicense(() async* {
    final t = await rootBundle.loadString('fonts/PRETENDARD-LICENSE.txt');
    yield LicenseEntryWithLineBreaks(const ['Pretendard'], t);
  });
}

class LicenseScreen extends StatefulWidget {
  const LicenseScreen({super.key});
  @override
  State<LicenseScreen> createState() => _LicenseScreenState();
}

class _LicenseScreenState extends State<LicenseScreen> {
  final Map<String, List<LicenseEntry>> _byPackage = {};
  StreamSubscription<LicenseEntry>? _sub;
  bool _done = false;
  int? _open;

  @override
  void initState() {
    super.initState();
    _sub = LicenseRegistry.licenses.listen((e) {
      for (final p in e.packages) {
        _byPackage.putIfAbsent(p, () => []).add(e);
      }
    }, onDone: () {
      if (mounted) setState(() => _done = true);
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  // 라이선스 전문은 원문 그대로 둔다. 어절 줄바꿈도 넣지 않는다.
  String _text(List<LicenseEntry> es) => es
      .map((e) => e.paragraphs.map((p) => p.text).join('\n\n'))
      .join('\n\n────\n\n');

  @override
  Widget build(BuildContext context) {
    final names = _byPackage.keys.toList()..sort();
    return AppShell(
      onBack: () => Navigator.of(context).pop(),
      child: ViewIn(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(T.pad, 16, T.pad, 44),
          children: [
            const KText('오픈소스 라이선스', style: T.h2),
            const SizedBox(height: 14),
            KText(
                _done
                    ? '이 앱은 아래 오픈소스 소프트웨어와 글꼴을 사용합니다.'
                    : '목록을 불러오는 중입니다.',
                style: const TextStyle(
                    fontFamily: T.ff,
                    fontSize: 14,
                    height: 1.7,
                    letterSpacing: -0.3,
                    color: T.g600)),
            const SizedBox(height: 22),
            for (var i = 0; i < names.length; i++) ...[
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => setState(() => _open = _open == i ? null : i),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  child: Row(children: [
                    Expanded(
                      child: KText(names[i],
                          style: const TextStyle(
                              fontFamily: T.ff,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.3,
                              color: T.g900)),
                    ),
                    KText(_open == i ? '접기' : '보기',
                        style: const TextStyle(
                            fontFamily: T.ff, fontSize: 13, color: T.g500)),
                  ]),
                ),
              ),
              if (_open == i)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: T.g50,
                      borderRadius: BorderRadius.circular(T.rNotice)),
                  child: Text(_text(_byPackage[names[i]]!),
                      style: const TextStyle(
                          fontFamily: T.ff,
                          fontSize: 12,
                          height: 1.65,
                          color: T.g600)),
                ),
              Container(height: 1, color: T.g100),
            ],
          ],
        ),
      ),
    );
  }
}
