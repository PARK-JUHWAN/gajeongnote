/// 한글 어절 단위 줄바꿈.
///
/// Flutter 의 줄바꿈은 한글을 음절 단위로 끊는다. 그래서 「박주환입니다」가
/// 「박 / 주환입니다」처럼 어절 가운데서 잘린다. 어절 안의 글자 사이에
/// ZERO WIDTH JOINER(U+200D) 를 넣으면 그 자리에서 줄을 끊지 못하므로
/// 결국 공백에서만 줄이 바뀐다. CSS 의 word-break: keep-all 과 같은 결과다.
///
/// ZWJ 는 폭이 0 이고 자소(grapheme)를 새로 만들지 않는다. 그래서 자간
/// (letterSpacing)과 글자 폭에 영향을 주지 않는다. 본문 텍스트 자체는
/// 바뀌지 않는다 — 눈에 보이는 글자는 한 자도 더하거나 빼지 않는다.
library;

import 'package:flutter/widgets.dart';

/// ZERO WIDTH JOINER. 이 자리에서는 줄이 끊기지 않는다.
const String zwj = '\u200D';

/// 이 길이를 넘는 어절은 묶지 않는다.
/// 화면 폭보다 긴 어절까지 묶어 버리면 끊을 자리가 없어 넘칠 수 있다.
/// 앱 본문의 최장 어절은 17자다.
const int _maxToken = 18;

bool _isSpace(int c) =>
    c == 0x20 || // space
    c == 0x0A || // \n
    c == 0x0D ||
    c == 0x09 ||
    c == 0x0B ||
    c == 0x0C ||
    c == 0xA0 || // nbsp
    c == 0x3000; // 전각 공백

/// 이모지 앞뒤에는 ZWJ 를 넣지 않는다.
/// ZWJ 는 이모지 결합 문자이기도 해서, 잘못 끼면 다른 그림이 된다.
bool _joinable(int c) {
  if (c >= 0xD800 && c <= 0xDFFF) return false; // 서로게이트 = 이모지 영역
  if (c == 0x00A9 || c == 0x00AE) return false; // © ®
  if (c >= 0x2190 && c <= 0x2BFF) return false; // 화살표·도형·기타 기호
  if (c >= 0xFE00 && c <= 0xFE0F) return false; // 변이 선택자
  if (c == 0x20E3 || c == 0x3030 || c == 0x303D) return false;
  return true;
}

final Map<String, String> _memo = {};

/// 한 덩어리 문자열에 적용한다.
String kb(String s) {
  if (s.length < 2) return s;
  final hit = _memo[s];
  if (hit != null) return hit;
  final out = kbRuns([s]).first;
  if (_memo.length > 3000) _memo.clear();
  _memo[s] = out;
  return out;
}

/// 스타일이 다른 조각으로 쪼개진 한 문단에 적용한다.
///
/// 강조 구간이 어절 가운데서 끝나는 경우(「{{연결점}}이다」)가 있어서,
/// 조각별로 따로 처리하면 그 경계에서 줄이 끊긴다. 전체를 이어 붙인 뒤
/// 어절을 찾고, 경계에 걸린 ZWJ 는 앞 조각의 끝에 붙인다.
List<String> kbRuns(List<String> parts) {
  final all = parts.join();
  if (all.length < 2) return parts;

  // all[i] 뒤에 ZWJ 를 넣을지
  final mark = List<bool>.filled(all.length, false);
  var i = 0;
  while (i < all.length) {
    if (_isSpace(all.codeUnitAt(i))) {
      i++;
      continue;
    }
    var j = i;
    while (j < all.length && !_isSpace(all.codeUnitAt(j))) {
      j++;
    }
    final len = j - i;
    if (len >= 2 && len <= _maxToken) {
      for (var k = i; k < j - 1; k++) {
        if (_joinable(all.codeUnitAt(k)) && _joinable(all.codeUnitAt(k + 1))) {
          mark[k] = true;
        }
      }
    }
    i = j;
  }

  final out = <String>[];
  var pos = 0;
  for (final p in parts) {
    final b = StringBuffer();
    for (var k = 0; k < p.length; k++) {
      b.writeCharCode(p.codeUnitAt(k));
      if (mark[pos + k]) b.write(zwj);
    }
    out.add(b.toString());
    pos += p.length;
  }
  return out;
}

/// 어절 단위로 줄이 바뀌는 Text.
///
/// const 생성자를 그대로 두었다. 호출부는 `Text(` 를 `KText(` 로 바꾸기만
/// 하면 되고, `const` 를 떼지 않아도 된다.
class KText extends StatelessWidget {
  final String data;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const KText(
    this.data, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) => Text(
        kb(data),
        style: style,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      );
}
