class SourceGroup {
  final String title;
  final String domain;
  final List<String> items;

  const SourceGroup(
      {required this.title, required this.domain, required this.items});

  factory SourceGroup.fromJson(Map<String, dynamic> j) => SourceGroup(
        title: (j['title'] ?? '') as String,
        domain: (j['domain'] ?? '') as String,
        items: ((j['items'] ?? []) as List).map((e) => '$e').toList(),
      );
}

class Sources {
  final String intro;
  final String outro;
  final List<SourceGroup> groups;

  const Sources(
      {required this.intro, required this.outro, required this.groups});

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
