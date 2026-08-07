import 'package:flutter/widgets.dart';

class T {
  T._();

  static const w = Color(0xFFFFFFFF);
  static const g50 = Color(0xFFF9FAFB);
  static const g100 = Color(0xFFF2F4F6);
  static const g200 = Color(0xFFE5E8EB);
  static const g400 = Color(0xFFB0B8C1);
  static const g500 = Color(0xFF8B95A1);
  static const g600 = Color(0xFF6B7684);
  static const g700 = Color(0xFF4E5968);
  static const g800 = Color(0xFF333D4B);
  static const g900 = Color(0xFF191F28);

  static const nurse = Color(0xFF00857A);
  static const nurseBg = Color(0xFFE6F4F2);
  static const fam = Color(0xFFE1580E);
  static const famBg = Color(0xFFFDEEE4);

  static const noticeInk = Color(0xFF7A3608);

  static const ff = 'Pretendard';

  static const h1 = TextStyle(
      fontFamily: ff,
      fontSize: 27,
      fontWeight: FontWeight.w700,
      letterSpacing: 27 * -0.035,
      height: 1.34,
      color: g900);
  static const h2 = TextStyle(
      fontFamily: ff,
      fontSize: 31,
      fontWeight: FontWeight.w700,
      letterSpacing: 31 * -0.04,
      height: 1.28,
      color: g900);
  static const body = TextStyle(
      fontFamily: ff,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 16 * -0.015,
      height: 1.8,
      color: g700);
  static const label = TextStyle(
      fontFamily: ff,
      fontSize: 13,
      fontWeight: FontWeight.w600,
      letterSpacing: 13 * -0.015,
      color: g600);

  static const rButton = 15.0;
  static const rCard = 18.0;
  static const rBadge = 13.0;
  static const rNotice = 16.0;
  static const rSeg = 12.0;

  static const ctaHeight = 56.0;
  static const pad = 24.0;

  static const ease = Cubic(.32, .72, 0, 1);
  static const dView = Duration(milliseconds: 340);
  static const dVoice = Duration(milliseconds: 400);
}

enum Track { nurse, family }

extension TrackX on Track {
  bool get isNurse => this == Track.nurse;
  Color get accent => isNurse ? T.nurse : T.fam;
  Color get accentBg => isNurse ? T.nurseBg : T.famBg;

  String get key => isNurse ? 'expert' : 'caregiver';
  String get tocEyebrow => isNurse ? '간호사 · 학생' : '대상자 · 가족';
  String get segLabel => isNurse ? '간호사에게' : '가족에게';
}
