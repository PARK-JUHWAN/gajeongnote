import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../design/ch_icons.dart';
import '../design/kbreak.dart';
import '../design/routes.dart';
import '../design/tokens.dart';
import '../state/app_state.dart';
import '../widgets/app_shell.dart';
import '../widgets/svg_icon.dart';
import 'license_screen.dart';
import 'privacy_screen.dart';
import 'sources_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  static const disclaimer =
      '본 앱은 학습 및 정보 제공을 목적으로 합니다.\n'
      '의료기기가 아니며, 어떠한 질병도 진단·치료·완화·예방하지 않습니다.\n'
      '건강에 관한 판단은 반드시 의사 등 의료 전문가와 상담하시기 바랍니다.';

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _asking = false;
  bool _done = false;
  Timer? _flash;

  @override
  void dispose() {
    _flash?.cancel();
    super.dispose();
  }

  void _reset() {
    context.read<AppState>().resetProgress();
    setState(() {
      _asking = false;
      _done = true;
    });
    _flash?.cancel();
    _flash = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _done = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      onBack: () => Navigator.of(context).pop(),
      child: ViewIn(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(T.pad, 16, T.pad, 44),
          children: [
            const KText('설정', style: T.h2),
            const SizedBox(height: 30),
            const _Group('읽기'),
            _Row(
              label: '읽은 위치 초기화',
              note: _done ? '초기화했습니다' : null,
              onTap: () => setState(() {
                _asking = !_asking;
                _done = false;
              }),
            ),
            if (_asking) _Confirm(onCancel: () => setState(() => _asking = false), onOk: _reset),
            const SizedBox(height: 26),
            const _Group('정보'),
            _Row(
                label: '개인정보처리방침',
                onTap: () =>
                    Navigator.of(context).push(fadeRoute(const PrivacyScreen()))),
            _Row(
                label: '근거 자료',
                onTap: () =>
                    Navigator.of(context).push(fadeRoute(const SourcesScreen()))),
            _Row(
                label: '오픈소스 라이선스',
                onTap: () =>
                    Navigator.of(context).push(fadeRoute(const LicenseScreen()))),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                  color: T.g50, borderRadius: BorderRadius.circular(T.rNotice)),
              child: const KText(SettingsScreen.disclaimer,
                  style: TextStyle(
                      fontFamily: T.ff,
                      fontSize: 13.5,
                      height: 1.75,
                      letterSpacing: -0.3,
                      color: T.g600)),
            ),
          ],
        ),
      ),
    );
  }
}

class _Confirm extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onOk;
  const _Confirm({required this.onCancel, required this.onOk});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 2, bottom: 4),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
          color: T.g50, borderRadius: BorderRadius.circular(T.rNotice)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const KText('읽은 표시가 모두 지워집니다. 본문은 그대로 남습니다.',
            style: TextStyle(
                fontFamily: T.ff,
                fontSize: 14,
                height: 1.7,
                letterSpacing: -0.3,
                color: T.g700)),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(
              child: _Mini(label: '취소', bg: T.g100, ink: T.g700, onTap: onCancel)),
          const SizedBox(width: 8),
          Expanded(child: _Mini(label: '초기화', bg: T.g900, ink: T.w, onTap: onOk)),
        ]),
      ]),
    );
  }
}

class _Mini extends StatelessWidget {
  final String label;
  final Color bg, ink;
  final VoidCallback onTap;
  const _Mini(
      {required this.label,
      required this.bg,
      required this.ink,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 46,
        alignment: Alignment.center,
        decoration:
            BoxDecoration(color: bg, borderRadius: BorderRadius.circular(T.rButton)),
        child: KText(label,
            style: TextStyle(
                fontFamily: T.ff,
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.3,
                color: ink)),
      ),
    );
  }
}

class _Group extends StatelessWidget {
  final String t;
  const _Group(this.t);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: KText(t, style: T.label.copyWith(color: T.g400, fontSize: 12)),
      );
}

class _Row extends StatelessWidget {
  final String label;
  final String? note;
  final VoidCallback? onTap;
  const _Row({required this.label, this.note, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(children: [
          Expanded(
            child: KText(label,
                style: const TextStyle(
                    fontFamily: T.ff,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.35,
                    color: T.g900)),
          ),
          if (note != null) ...[
            KText(note!,
                style: const TextStyle(
                    fontFamily: T.ff,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
                    color: T.nurse)),
            const SizedBox(width: 8),
          ],
          const RawIcon(ChIcons.chevron, color: T.g400, size: 17),
        ]),
      ),
    );
  }
}
