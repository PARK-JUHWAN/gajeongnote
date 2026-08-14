library;

enum BlockType { lead, p, notice, ref }

BlockType _bt(String? s) => switch (s) {
      'lead' => BlockType.lead,
      'notice' => BlockType.notice,
      'ref' => BlockType.ref,
      _ => BlockType.p,
    };

class LinkItem {
  final String label;
  final String url;

  const LinkItem({required this.label, required this.url});

  factory LinkItem.fromJson(Map<String, dynamic> j) => LinkItem(
        label: (j['label'] ?? '') as String,
        url: (j['url'] ?? '') as String,
      );
}

class Block {
  final BlockType type;

  final String? h;

  final String p;

  final List<LinkItem>? links;

  const Block({
    required this.type,
    this.h,
    required this.p,
    this.links,
  });

  factory Block.fromJson(Map<String, dynamic> j) => Block(
        type: _bt(j['type'] as String?),
        h: j['h'] as String?,
        p: (j['p'] ?? '') as String,
        links: j['links'] != null
            ? ((j['links'] as List)
                .map((e) => LinkItem.fromJson(e as Map<String, dynamic>))
                .toList())
            : null,
      );
}

class QuizItem {
  final String q;
  final List<String> options;

  final int answer;
  final String explain;

  const QuizItem({
    required this.q,
    required this.options,
    required this.answer,
    required this.explain,
  });

  factory QuizItem.fromJson(Map<String, dynamic> j) => QuizItem(
        q: (j['q'] ?? '') as String,
        options: ((j['options'] ?? []) as List).map((e) => '$e').toList(),
        answer: (j['answer'] ?? 0) as int,
        explain: (j['explain'] ?? '') as String,
      );
}

class Chapter {
  final int id;
  final String title;

  final String ref;
  final String icon;

  final bool core;

  final List<Block> expert;
  final List<Block> caregiver;
  final List<QuizItem> quiz;

  const Chapter({
    required this.id,
    required this.title,
    required this.ref,
    required this.icon,
    required this.core,
    required this.expert,
    required this.caregiver,
    required this.quiz,
  });

  factory Chapter.fromJson(Map<String, dynamic> j) => Chapter(
        id: (j['id'] ?? 0) as int,
        title: (j['title'] ?? '') as String,
        ref: (j['ref'] ?? '') as String,
        icon: (j['icon'] ?? 'line') as String,
        core: (j['core'] ?? false) as bool,
        expert: _blocks(j['expert']),
        caregiver: _blocks(j['caregiver']),
        quiz: ((j['quiz'] ?? []) as List)
            .map((e) => QuizItem.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  static List<Block> _blocks(dynamic v) => ((v ?? []) as List)
      .map((e) => Block.fromJson(e as Map<String, dynamic>))
      .toList();

  List<Block> body(bool nurse) => nurse ? expert : caregiver;

  bool written(bool nurse) => body(nurse).isNotEmpty;
}