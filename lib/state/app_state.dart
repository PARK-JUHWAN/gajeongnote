import 'package:flutter/foundation.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import '../design/tokens.dart';
import '../models/chapter.dart';
import '../models/sources.dart';
import '../data/content_repo.dart';

class AppState extends ChangeNotifier {
  static const _boxName = 'progress';
  static const _kDisclaimer = 'disclaimer_ack';

  Box? _b;
  List<Chapter> chapters = const [];
  Sources sources = Sources.empty;
  bool loading = true;
  String? loadError;

  Track track = Track.nurse;
  int? currentId;

  Future<void> init() async {
    try {
      await Hive.initFlutter();
      _b = await Hive.openBox(_boxName);
      final loaded = await ContentRepo.load();
      chapters = loaded.$1;
      sources = loaded.$2;
    } catch (e) {
      loadError = '$e';
    }
    loading = false;
    notifyListeners();
  }

  bool get disclaimerAcked => _b?.get(_kDisclaimer, defaultValue: false) == true;

  Future<void> ackDisclaimer() async {
    await _b?.put(_kDisclaimer, true);
    notifyListeners();
  }

  void setTrack(Track t) {
    if (track == t) return;
    track = t;
    notifyListeners();
  }

  void openChapter(int id) {
    currentId = id;
    notifyListeners();
  }

  Chapter? get current {
    for (final c in chapters) {
      if (c.id == currentId) return c;
    }
    return null;
  }

  String _key(int id, Track t) => 'read_${t.name}_$id';

  bool isRead(int id, Track t) =>
      _b?.get(_key(id, t), defaultValue: false) == true;

  Future<void> markRead(int id, Track t) async {
    await _b?.put(_key(id, t), true);
    notifyListeners();
  }

  Future<void> resetProgress() async {
    final keys = _b?.keys.where((k) => '$k'.startsWith('read_')).toList() ?? [];
    await _b?.deleteAll(keys);
    notifyListeners();
  }
}
