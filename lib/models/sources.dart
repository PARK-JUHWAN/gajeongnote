class SourceItem {
  final String name;
  final String url;

  const SourceItem({required this.name, required this.url});

  factory SourceItem.fromJson(dynamic j) {
    if (j is Map<String, dynamic>) {
      return SourceItem(
        name: (j['name'] ?? '') as String,
        url: (j['url'] ?? '') as String,
      );
    }
    // 기존 문자열 형식에 대한 하위 호환 처리
    return SourceItem(
      name: '$j',
      url: '',
    );
  }
}

class SourceGroup {
  final String title;
  final String domain;
  final String url;
  final List<SourceItem> items;

  const SourceGroup({
    required this.title,
    required this.domain,
    required this.url,
    required this.items,
  });

  factory SourceGroup.fromJson(Map<String, dynamic> j) => SourceGroup(
        title: (j['title'] ?? '') as String,
        domain: (j['domain'] ?? '') as String,
        url: (j['url'] ?? '') as String,
        items: ((j['items'] ?? []) as List)
            .map((e) => SourceItem.fromJson(e))
            .toList(),
      );
}

class Sources {
  final String intro;
  final String outro;
  final List<SourceGroup> groups;

  const Sources({
    required this.intro,
    required this.outro,
    required this.groups,
  });

  static const empty = Sources(intro: '', outro: '', groups: []);

  factory Sources.fromJson(Map<String, dynamic>? j) {
    if (j == null) return empty;
    return Sources(
      intro: (j['intro'] ?? '') as String,
      outro: (j['outro'] ?? '') as String,
      groups: ((j['groups'] ?? []) as List)
          .map((e) => SourceGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}