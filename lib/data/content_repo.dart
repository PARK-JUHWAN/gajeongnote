import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/chapter.dart';
import '../models/sources.dart';

class ContentRepo {
  static const _asset = 'assets/content.json';

  static Future<(List<Chapter>, Sources)> load() async {
    final raw = await rootBundle.loadString(_asset);
    final map = jsonDecode(raw) as Map<String, dynamic>;
    final chapters = ((map['chapters'] ?? []) as List)
        .map((e) => Chapter.fromJson(e as Map<String, dynamic>))
        .toList();
    final sources = Sources.fromJson(map['sources'] as Map<String, dynamic>?);
    return (chapters, sources);
  }
}
