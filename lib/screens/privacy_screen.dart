import 'package:flutter/widgets.dart';
import '../design/kbreak.dart';
import '../design/tokens.dart';
import '../widgets/app_shell.dart';

/// 개인정보처리방침 전문.
///
/// 웹 공개본과 같은 문안이다.
/// https://park-juhwan.github.io/gajeongnote-web/privacy.html
///
/// 링크를 열지 않는다. 주소는 맨 아래에 글자로만 적는다.
/// 탭 가능한 링크를 만들면 url_launcher 가 들어가고,
/// 「네트워크 통신을 하지 않는다」는 심사 서신 문장이 흔들린다.
class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      onBack: () => Navigator.of(context).pop(),
      child: ViewIn(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(T.pad, 16, T.pad, 44),
          children: const [
            KText('개인정보처리방침', style: T.h2),
            SizedBox(height: 8),
            KText('가정간호노트 · 2026년 8월 5일',
                style: TextStyle(
                    fontFamily: T.ff,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.3,
                    color: T.g400)),
            SizedBox(height: 26),

            _P('가정간호노트는 사용자가 누구인지 묻지 않습니다. 계정도 로그인도 회원가입도 없습니다.'),

            SizedBox(height: 8),
            _Box(),
            SizedBox(height: 26),

            _H('기기에만 남는 것'),
            _P('다시 열었을 때 읽던 자리에서 이어 볼 수 있도록 다음을 기억합니다. '
                '전부 사용자의 기기 안에만 저장되고, 앱을 삭제하면 함께 사라집니다.'),
            SizedBox(height: 4),
            _B('어떤 주제를 읽었는지'),
            _B('어느 갈래(간호사 · 가족)를 선택했는지'),
            _B('표시해 둔 북마크'),
            _B('면책 고지 확인 여부'),
            SizedBox(height: 10),
            _P('이 중 어느 것도 외부로 전송되지 않습니다.'),

            _H('네트워크'),
            _P('가정간호노트는 **인터넷에 접속하지 않습니다.** 모든 내용이 앱 안에 포함되어 있으며, '
                '앱이 기기 밖과 통신하는 경우는 없습니다.'),

            _H('건강정보'),
            _P('이 앱은 **건강정보를 수집하거나 처리하지 않습니다.** 증상이나 수치를 입력받는 화면이 없고, '
                '위험도를 계산하거나 판정하지 않으며, Apple 건강 앱을 포함한 어떤 건강 데이터에도 '
                '접근하지 않습니다.'),

            _H('하지 않는 것'),
            _B('추적 및 분석 도구를 일절 사용하지 않습니다'),
            _B('광고와 광고 식별자가 없습니다'),
            _B('위치, 카메라, 마이크, 연락처, 사진에 접근하지 않습니다'),
            _B('무엇을 언제 얼마나 읽었는지가 기기 밖으로 나가지 않습니다'),
            _B('어떤 정보도 제3자에게 판매하거나 공유하지 않습니다'),

            _H('결제'),
            _P('가정간호노트는 **무료이며 앱 내 결제가 없습니다.** 결제 정보를 다루지 않습니다.'),

            _H('아동'),
            _P('이 앱은 아동을 대상으로 하지 않습니다. 아동을 포함해 누구에게서도 개인정보를 '
                '수집하지 않습니다.'),

            _H('이용자의 권리'),
            _P('수집하는 개인정보가 없으므로 열람·정정·삭제를 요청할 대상이 존재하지 않습니다. '
                '기기에 저장된 읽기 기록은 앱 설정에서 초기화하거나 앱을 삭제하여 언제든 지울 수 있습니다.'),

            _H('변경'),
            _P('이 방침이 바뀌면 새 날짜와 함께 웹 공개본에 게시합니다. 수집하는 정보가 없으므로 '
                '변경이 있다면 새로운 처리 방식이 아니라 설명의 보완일 가능성이 높습니다.'),

            _H('문의'),
            _P('이 방침에 관한 질문은 아래로 보내주시면 답변드립니다.'),
            SizedBox(height: 4),
            KText('naruto0414@gmail.com',
                style: TextStyle(
                    fontFamily: T.ff,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
                    color: T.g900)),

            SizedBox(height: 34),
            _Foot(),
          ],
        ),
      ),
    );
  }
}

class _H extends StatelessWidget {
  final String t;
  const _H(this.t);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 28, bottom: 10),
        child: KText(t,
            style: const TextStyle(
                fontFamily: T.ff,
                fontSize: 15.5,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.4,
                color: T.g900)),
      );
}

const TextStyle _bodyStyle = TextStyle(
    fontFamily: T.ff,
    fontSize: 14.5,
    height: 1.78,
    letterSpacing: -0.3,
    color: T.g700);

/// `**굵게**` 만 해석한다.
List<TextSpan> _emph(String src) {
  final re = RegExp(r'\*\*(.+?)\*\*', dotAll: true);
  final parts = <String>[];
  final hot = <bool>[];
  var i = 0;
  for (final m in re.allMatches(src)) {
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
  final wrapped = kbRuns(parts);
  const hi = TextStyle(fontWeight: FontWeight.w700, color: T.g900);
  return [
    for (var k = 0; k < wrapped.length; k++)
      TextSpan(text: wrapped[k], style: hot[k] ? hi : null),
  ];
}

class _P extends StatelessWidget {
  final String t;
  const _P(this.t);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text.rich(TextSpan(children: _emph(t), style: _bodyStyle)),
      );
}

class _B extends StatelessWidget {
  final String t;
  const _B(this.t);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 7),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 3,
            height: 3,
            margin: const EdgeInsets.only(top: 11, right: 9),
            decoration: const BoxDecoration(color: T.g400, shape: BoxShape.circle),
          ),
          Expanded(child: KText(t, style: _bodyStyle)),
        ]),
      );
}

class _Box extends StatelessWidget {
  const _Box();
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
            color: T.nurseBg, borderRadius: BorderRadius.circular(T.rNotice)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
          KText('수집하는 개인정보 0건',
              style: TextStyle(
                  fontFamily: T.ff,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.35,
                  color: T.nurse)),
          SizedBox(height: 8),
          KText(
              '이름, 연락처, 이메일, 생년월일, 건강정보를 포함해 어떤 개인정보도 수집·저장·전송하지 '
              '않습니다. 사용자에 관한 정보를 보관하는 서버가 없습니다.',
              style: TextStyle(
                  fontFamily: T.ff,
                  fontSize: 14,
                  height: 1.75,
                  letterSpacing: -0.3,
                  fontWeight: FontWeight.w500,
                  color: T.g800)),
        ]),
      );
}

class _Foot extends StatelessWidget {
  const _Foot();
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.only(top: 18),
        decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: T.g100, width: 1))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
          KText('같은 내용을 아래 주소에서도 볼 수 있습니다.',
              style: TextStyle(
                  fontFamily: T.ff, fontSize: 12.5, height: 1.7, color: T.g500)),
          SizedBox(height: 3),
          KText('park-juhwan.github.io/gajeongnote-web/privacy.html',
              style: TextStyle(
                  fontFamily: T.ff,
                  fontSize: 12.5,
                  height: 1.7,
                  fontWeight: FontWeight.w500,
                  color: T.g500)),
        ]),
      );
}
