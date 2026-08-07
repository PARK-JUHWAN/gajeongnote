# 가정간호노트

프로토타입 `가정간호앱_프로토타입_v5.html`을 Flutter로 이식한 것.
**디자인은 확정이다.** 토큰·라운딩·모션 값을 바꾸지 않는다.

---

## 설치

이미 `flutter create` 로 만든 `C:\Users\user\Desktop\gajeongnote` 안에
이 압축을 풀어 덮어쓴다.

```powershell
cd C:\Users\user\Desktop\gajeongnote

# 압축 풀기 (다운로드 폴더 경로는 실제 위치로)
Expand-Archive -Path "$HOME\Downloads\gajeongnote.zip" -DestinationPath $env:TEMP\gn -Force
Copy-Item "$env:TEMP\gn\*" . -Recurse -Force

# 표시 이름 박기 + 폰트 상태 확인
.\setup.ps1

flutter pub get
dart analyze
flutter run
```

`flutter create` 가 만든 `lib\main.dart` 는 덮어써진다.

---

## 폰트

`fonts\` 에 Pretendard OTF **5종**을 넣는다.
Regular 400 · Medium 500 · SemiBold 600 · Bold 700 · ExtraBold 800

https://github.com/orioncactus/pretendard/releases (OFL 1.1)

넣은 뒤:

```powershell
.\setup.ps1 -EnableFonts
flutter pub get
```

`-EnableFonts` 는 pubspec 에 폰트 블록을 **추가**한다. 5종이 다 있어야 실행되고,
하나라도 없으면 거부하고 멈춘다.

**폰트가 없어도 앱은 돈다.** pubspec 에 폰트 블록이 아예 없어서 시스템 폰트로 뜬다.
자간이 달라 보이니 확인용으로만 쓴다.

---

## 구조

```
lib/
  design/tokens.dart      v5 :root 토큰. 색·타입·라운딩·모션
  design/ch_icons.dart    13개 챕터 아이콘 SVG path (v5에서 추출)
  design/routes.dart      화면 전환. MaterialPageRoute 안 쓴다
  models/chapter.dart     content.json 스키마
  data/content_repo.dart  로컬 JSON 로드
  state/app_state.dart    화자·진도. hive_ce
  screens/                intro → home → toc → read → quiz, settings
  widgets/                shell · segment · row · body · cta · icon
assets/content.json       본문 전체
setup.ps1                 표시 이름 · 폰트
verify_app_content.py     이관 검증
```

---

## 본문 작성

`assets\content.json` 만 채우면 된다. **코드는 건드릴 필요 없다.**

```json
{ "type": "lead",   "p": "도입 문단" }
{ "type": "p",      "p": "본문. {{이 구간}}은 accent 색 강조" }
{ "type": "notice", "h": "이럴 땐 연락하세요", "p": "..." }
{ "type": "ref",    "p": "참고: ..." }
```

**배제 서술을 쓴 섹션은 반드시 `notice` 블록으로 닫는다.**
(자료집 통합 정리 C — 배치 규칙 「나」)

필드명 `expert` `caregiver` `quiz` `options` `answer` `explain` 은
검증 스크립트가 의존한다. **바꾸지 않는다.**

---

## 검증

챕터를 채울 때마다 돌린다. 육안으로 훑는 것보다 안전하다.

```powershell
python verify_app_content.py assets\content.json ..\가정간호통합묶음.md
```

**검출 = 위반이 아니다.** 자료집 「통합 정리 C 7-3절」 판정 기준으로 1건씩 판단한다.
알려진 오탐 두 가지:

- 법정 요건 수치(처방 90일, 지시서 180일, 인력 2명) — 허용
- 검사 8이 문단 단위라 `caregiver` 중간 문단이 걸린다 — 섹션의 마지막이 `notice` 면 통과로 본다

---

## 화면에 없는 것 — 새 화면 설계 전에 먼저 본다

- 입력 필드 없음
- 점수·판정 UI 없음
- 계정·서버·네트워크 권한 없음
- 체크박스·순서 목록 없음
- 상처 사진·시술 도해 없음

전부 의료 리젝 회피에서 내려온 제약이고 디자인에 못 박혀 있다.

## 코드 제약

주석을 쓰지 않는다. 지켜야 할 것은 전부 여기 적는다.

| 제약 | 이유 |
|---|---|
| `MaterialPageRoute` 를 쓰지 않는다 | 이 앱은 `WidgetsApp` 위에 서 있어 `Theme` 가 없다. 화면 이동은 `design/routes.dart` 의 `fadeRoute()` |
| `Scaffold` · `AppBar` · `MaterialApp` 을 쓰지 않는다 | 같은 이유. 셸은 `widgets/app_shell.dart` |
| `content.json` 필드명 고정 | `expert` `caregiver` `quiz` `options` `answer` `explain` 은 검증 스크립트가 의존한다 |
| `answer` 는 0-based 인덱스 | 선지 배열 위치 |
| 토큰 값을 바꾸지 않는다 | 색·타입·라운딩·모션은 v5 프로토타입에서 확정 |
| 진도는 뱃지 채움으로만 | 퍼센트·점수 표시 금지 |
| 배제 서술 섹션은 `notice` 로 닫는다 | 자료집 통합 정리 C — 배치 규칙 「나」 |

## 아이콘 규칙

24×24 · stroke 1.75 · round cap · currentColor · **기하 형태만**.
신체·상처·처치·인체 실루엣을 그리지 않는다.
**Material Icons 로 대체하지 않는다** — 톤이 완전히 달라진다.

---

## 미확정

- 챕터 9·10 보호자용 본문 — osk
- ASO 4종 (이름 확정 / 부제 · 키워드 · 설명문) — osk
- 앱 아이콘 1024×1024 (투명도 없음 · 글자 없음 · 십자·하트 없음) — 별도 생성 중

## 제출 전

- [ ] `.\setup.ps1 -EnableFonts` 후 실제 폰트로 확인
- [ ] Android cmdline-tools 설치 + `flutter doctor --android-licenses`
- [ ] targetSdk 36 확인 (`android\app\build.gradle.kts`)
- [ ] 카테고리 Education
- [ ] 개인정보처리방침 URL 공개 (자료집 통합 정리 D 3절에 문안)
- [ ] Google Health apps declaration
- [ ] 심사 노트 (자료집 통합 정리 F 7절)
