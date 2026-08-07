#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
가정간호 학습 앱 — 본문 이관 검증 스크립트

사용법:
    python3 verify_app_content.py content.json 가정간호통합묶음.md

무엇을 하는가:
    자료집(md)에서 🚫앱배제 표시된 항목의 원문 토큰을 자동 추출한 뒤,
    앱 본문 JSON에 그것이 딸려 들어갔는지 대조한다.
    동시에 지시형·수치·조합 판정·제품명·도구 추천을 전수 검사한다.

JSON 구조(권장 — 다른 구조여도 모든 문자열을 재귀 수집하므로 동작한다):
    {
      "chapters": [
        {"id": 1, "title": "...",
         "expert":     [{"h": "소제목", "p": "본문"}, ...],
         "caregiver":  [{"h": "소제목", "p": "본문"}, ...],
         "quiz":       [{"q": "...", "a": ["..."], "explain": "..."}]}
      ]
    }
"""
import sys, json, re, unicodedata

# ─────────────────────────────────────────────────────────────
# 패턴 정의
# ─────────────────────────────────────────────────────────────

# 1. 지시 형태
IMPERATIVE = {
    "종결어미":   r'(한다|하세요|하십시오|해야\s*한다|해야\s*하며|하지\s*않는다|하지\s*마세요|하도록\s*한다|권장된다|권장되지\s*않는다)\s*[.!」\)]?\s*$',
    "명사형지시": r'(할\s*것|하지\s*말\s*것|금지한다|반드시\s|필수적으로|꼭\s+\S+하)',
    "조건부지시": r'(하면|할\s*때|경우에는|시에는|라면).{0,30}(하세요|한다|해야|하시면\s*됩니다)',
    "빈도주기":   r'(매\s*\S{0,6}마다|[0-9]+\s*회\s*/\s*[주일월]|[0-9]+\s*시간\s*간격|하루\s*[0-9]+\s*회|주\s*[0-9]+\s*회|[가-힣]+\s*시간마다)',
    "절차나열":   r'^\s*(①|②|③|④|⑤|⑥|⑦|⑧|⑨|⑩|[0-9]+\s*단계|[0-9]+\)\s|STEP)',
    # 명사형 나열 지시 — "1인용 / 자주 세탁 후 햇빛 소독" 형태. 종결어미가 없어 위 패턴에 안 걸린다.
    "명사형나열":  r'(?:[^/]{2,25}/){2,}[^/]{2,25}$',
}
# 명사형나열 검출 후 아래 지시 명사가 있어야 위반으로 본다
DIRECTIVE_NOUN = (r'(사용|착용|세탁|소독|교체|보관|준비|폐기|분리|씻|닦|말리|건조|'
                  r'금지|유지|확인|점검|제거|삽입|주입|측정|기록|정리|처리)')

# 2. 수치 + 단위 (1차 검증에서 빠졌던 단위 전부 포함)
UNITS = ("점|%|퍼센트|mL|ml|cc|L|cm|mm|kg|g|mg|kcal|g/kg|Fr|CFU|mmHg|℃|도|"
         "분|시간|일|주|개월|년|회|번|차례|단계|등급|배")
ORDINAL = r'(위|아래|앞|뒤|제|위의|다음)\s*[0-9]+\s*(번|번째|절|장|항|호)|[0-9]+\s*번(째|\s*항목|\s*문항)'
NUMERIC = rf'(?<![0-9A-Za-z])[0-9]+(?:\.[0-9]+)?(?:\s*~\s*[0-9]+(?:\.[0-9]+)?)?\s*(?:{UNITS})(?![0-9A-Za-z가-힣]*(?:묶음|절|장|권고|번째))'
KOREAN_NUM = (r'(한|두|세|네|다섯|여섯|일곱|여덟|아홉|열|스무|서른)\s*'
              r'(시간|분|번|회|일|주|개월|가지|단계|차례)(?![가-힣])')

# 3. 배제 서술 / 증상 목록 (조합 판정)
EXCLUSION = (r'(대상이\s*아니|필요\s*없|불필요|권장되지\s*않|권하지\s*않|하지\s*않아도|'
             r'않아도\s*(?:되|괜찮)|치료하지\s*않|제거하지\s*않|중단하지\s*않|정상입니다|괜찮습니다|지켜보)')
SYMPTOM = (r'발열|열이\s*나|오한|통증|아파|악취|냄새|홍반|붉어|부종|붓|경결|화농|출혈|피가|'
           r'구토|오심|메스|설사|어지|의식|섬망|혼돈|식욕|불안|동요|발한|땀|팽만|열감|'
           r'검은|어두운|탈수|누출|새어|배출이\s*없|나오지\s*않')

# 4. 제품·상표
BRAND = (r'®|™|메디폼|듀오덤|아쿠아셀|알레빈|하이드로사이트|컴필|메피렉스|폴리\s*카테터|'
         r'포비돈|베타딘|헥시딘|클로르헥시딘|엔커버|그린비아|하모닐란|뉴케어|컨버텍|홀리스터|'
         r'코로플라스트|스토마헤시브')

# 5. 도구 이름 + 비교/추천
TOOLS = r'(Braden|브레이든|PUSH|Morse|모스|STRATIFY|MMSE|GCS|Glasgow|Norton|Waterlow|Gosnell|NRS|MUST|NUTRIC)'
RECOMMEND = r'(더\s*(낫|좋|우수|정확)|우수하|권장되는\s*도구|가장\s*(널리|많이|적합)|효율적|편의성|민감도|특이도|대비\s)'

# ─────────────────────────────────────────────────────────────


def collect_strings(obj, path="$"):
    """JSON 어떤 구조든 모든 문자열을 (경로, 문자열)로 수집."""
    out = []
    if isinstance(obj, str):
        out.append((path, obj))
    elif isinstance(obj, dict):
        for k, v in obj.items():
            out += collect_strings(v, f"{path}.{k}")
    elif isinstance(obj, list):
        for i, v in enumerate(obj):
            out += collect_strings(v, f"{path}[{i}]")
    return out


def split_sentences(text):
    """문장 단위 분할 (한국어 종결 기준)."""
    parts = re.split(r'(?<=[.!?。])\s+|\n+', text)
    return [p.strip() for p in parts if p.strip()]


def build_blocklist(md_path):
    """자료집에서 🚫앱배제 표시 줄의 원문 토큰을 추출."""
    tokens, sources = set(), {}
    try:
        lines = open(md_path, encoding="utf-8").read().splitlines()
    except OSError:
        print(f"  ⚠️  자료집을 못 읽었습니다: {md_path} — 대조 검사(3)는 건너뜁니다.\n")
        return tokens, sources

    for i, line in enumerate(lines, 1):
        if "🚫앱배제" not in line and "🚫**앱배제" not in line:
            continue
        # 수치+단위 토큰
        for m in re.finditer(rf'[0-9]+(?:\.[0-9]+)?(?:\s*~\s*[0-9]+(?:\.[0-9]+)?)?\s*(?:{UNITS})', line):
            t = re.sub(r'\s+', '', m.group())
            if len(t) >= 2:
                tokens.add(t); sources.setdefault(t, i)
        # 도구 이름
        for m in re.finditer(TOOLS, line):
            tokens.add(m.group()); sources.setdefault(m.group(), i)
    return tokens, sources



def walk_quiz(obj, path="$"):
    """quiz 배열의 각 문항 dict를 (경로, dict)로 수집."""
    out = []
    if isinstance(obj, dict):
        for k, v in obj.items():
            if k in ("quiz", "questions", "문제") and isinstance(v, list):
                for i, it in enumerate(v):
                    if isinstance(it, dict):
                        out.append((f"{path}.{k}[{i}]", it))
            else:
                out += walk_quiz(v, f"{path}.{k}")
    elif isinstance(obj, list):
        for i, v in enumerate(obj):
            out += walk_quiz(v, f"{path}[{i}]")
    return out


def resolve_answer(item):
    """정답 인덱스/문자열을 선지 텍스트로 해석."""
    opts = item.get("options") or item.get("choices") or item.get("선지") or []
    a = item.get("answer", item.get("a", item.get("정답")))
    if isinstance(a, bool):
        return None
    if isinstance(a, int) and 0 <= a < len(opts):
        return opts[a] if isinstance(opts[a], str) else None
    if isinstance(a, str):
        return a
    return None


def scan(items, name, pattern, flags=0):
    hits = []
    rx = re.compile(pattern, flags)
    for path, text in items:
        for sent in split_sentences(text):
            m = rx.search(sent)
            if m:
                hits.append((path, sent, m.group()))
    return name, hits


def report(name, hits, note=""):
    mark = "✅" if not hits else "⚠️"
    print(f"\n{mark} [{name}] {len(hits)}건" + (f"  — {note}" if note else ""))
    for path, sent, tok in hits[:40]:
        print(f"    {path}")
        print(f"      «{tok}»  …{sent[:110]}")
    if len(hits) > 40:
        print(f"    … 외 {len(hits)-40}건")
    return len(hits)


def main():
    if len(sys.argv) < 2:
        print(__doc__); sys.exit(1)
    json_path = sys.argv[1]
    md_path = sys.argv[2] if len(sys.argv) > 2 else "가정간호통합묶음.md"

    data = json.load(open(json_path, encoding="utf-8"))
    items = [(p, unicodedata.normalize("NFC", s)) for p, s in collect_strings(data) if len(s) > 3]

    print("=" * 72)
    print(f"앱 본문 이관 검증  |  문자열 {len(items)}개  |  자료집 {md_path}")
    print("=" * 72)

    total = 0

    # ── 1. 지시 형태
    for label, pat in IMPERATIVE.items():
        name, hits = scan(items, f"1. 지시 형태 — {label}", pat, re.M)
        if label == "명사형나열":
            hits = [h for h in hits if re.search(DIRECTIVE_NOUN, h[1])]
        total += report(name, hits)

    # ── 2. 수치
    name, hits = scan(items, "2. 수치 + 단위", NUMERIC)
    hits = [h for h in hits if not re.search(ORDINAL, h[1])]   # 서수 참조 제외
    total += report(name, hits)
    total += report(*scan(items, "2. 한글 수사", KOREAN_NUM))

    # ── 3. 🚫앱배제 원문 대조
    blocklist, sources = build_blocklist(md_path)
    hits = []
    for path, text in items:
        flat = re.sub(r'\s+', '', text)
        for tok in blocklist:
            if tok in flat:
                hits.append((path, text[:150], f"{tok} (자료집 {sources.get(tok,'?')}행)"))
    total += report("3. 🚫앱배제 항목 유입", hits,
                    f"자료집에서 추출한 배제 토큰 {len(blocklist)}개와 대조")

    # ── 4. 조합 판정 (배제 서술 × 증상 목록)
    combo = []
    for path, text in items:
        sents = split_sentences(text)
        for idx, sent in enumerate(sents):
            if not re.search(EXCLUSION, sent):
                continue
            window = sents[max(0, idx - 2): idx + 3]
            sym = [w for w in window if re.search(SYMPTOM, w)]
            closed = any(re.search(r'연락|알려|문의|상의', w) for w in sents[idx:idx + 3])
            if sym and not closed:
                combo.append((path, sent, "배제×증상, 연락 문장 없음"))
    total += report("4. 조합 판정 위험", combo,
                    "배제 서술 ±2문장 안에 증상 목록이 있고 연락 문장이 없음")

    # ── 5. 제품·상표
    total += report(*scan(items, "5. 제품명·상표명", BRAND))

    # ── 6. 도구 비교·추천
    tool_hits = []
    for path, text in items:
        sents = split_sentences(text)
        for idx, sent in enumerate(sents):
            if not re.search(TOOLS, sent):
                continue
            window = sents[max(0, idx - 1): idx + 3]   # 도구명 이후 문장까지 본다
            for w in window:
                m = re.search(RECOMMEND, w)
                if m:
                    tool_hits.append((path, w, f"도구명 인접 «{m.group()}»"))
                    break
    total += report("6. 도구 비교·추천", tool_hits)

    # ── 7. 금지 표현 (판정 유도)
    total += report(*scan(items, "7-A. 판정 유도 (높음)",
                          r'(를\s*의미합니다|가\s*의심됩니다|(이|가)\s*맞습니다|'
                          r'괜찮습니다|지켜보셔도|안심하셔도|걱정하지\s*않으셔도)'))
    total += report(*scan(items, "7-B. 정도 판단 요구 (중간)",
                          r'(심하면|많으면|적으면|높으면|낮으면|크면|오래되면|자주\s*\S+면)'))
    total += report(*scan(items, "7-C. 증상→결론 구조 (확인 필요)",
                          rf'({SYMPTOM}).{{0,25}}(면|으면|이면)\s*\S{{0,12}}(입니다|이다|입니다\.)'))

    # ── 8. 보호자용 닫기 규칙
    unclosed = []
    for path, text in items:
        if ".quiz" in path or "문제" in path:
            continue          # 문항·해설은 연락 닫기 대상이 아니다 (9-C·9-D가 따로 본다)
        if ".caregiver" not in path and "보호자" not in path:
            continue
        if len(text) < 80:
            continue
        if not re.search(r'(연락|문의|상의|알려\s*주세요|말씀).{0,25}$', text.strip()):
            unclosed.append((path, text[-120:], "연락 문장으로 닫히지 않음"))
    total += report("8. 보호자용 닫기 규칙", unclosed,
                    "보호자용 문단은 연락·문의로 닫혀야 함")

    # ── 9. 확인 문제 전용
    quiz = [(p_, t) for p_, t in items if ".quiz" in p_ or "문제" in p_]
    if quiz:
        total += report(*scan(quiz, "9-A. 증례 제시형 문항 (금지)",
                              r'([0-9]+\s*세\s*(남|여|환자|대상자)|남성이|여성이|'
                              r'인\s*(대상자|환자|경우)\s*(에게|에서|일\s*때)|~한\s*상태)'))
        total += report(*scan(quiz, "9-B. 수치를 답으로 요구 (금지)", NUMERIC))
        # 정답이 "연락한다"인 문항 — 오답 선지가 판정을 가르친다
        ans = []
        for path, item in walk_quiz(data):
            correct = resolve_answer(item)
            if correct and re.search(r'(연락|알린다|알려|문의|상의|전화)', correct):
                ans.append((path, f"정답: {correct}",
                            "오답 선지가 「연락하지 않아도 되는 상황」을 가르친다"))
            # 선지 안에 수치가 섞여 있는지도 함께 본다
            for o in item.get("options") or item.get("choices") or []:
                if isinstance(o, str) and re.search(NUMERIC, o):
                    ans.append((path, f"선지: {o}", "선지에 수치 — 대입 훈련이 된다"))
        total += report("9-C. 정답이 「연락한다」 / 선지 수치 (금지)", ans)
        # 해설 지시형
        expl = [(p_, t) for p_, t in quiz if re.search(r'\.(explain|해설|풀이)', p_)]
        if expl:
            total += report(*scan(expl, "9-D. 해설 지시형", IMPERATIVE["종결어미"], re.M))
            total += report(*scan(expl, "9-D. 해설 — 그러므로~하세요 구조",
                                  r'(그러므로|따라서|그래서).{0,25}(하세요|해야|한다)'))

    print("\n" + "=" * 72)
    print(f"총 검출 {total}건 — 전부 위반은 아니다. 아래 판정 기준으로 1건씩 판단할 것.")
    print("=" * 72)
    sys.exit(0 if total == 0 else 2)


if __name__ == "__main__":
    main()
