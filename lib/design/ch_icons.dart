library;

class ChIcons {
  ChIcons._();

  static const Map<String, String> _inner = {
    'law':
        '<path d="M7 3h8l4 4v14H7z" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round"/><path d="M15 3v4h4" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round"/><circle cx="12" cy="15" r="2.2" stroke="currentColor" stroke-width="1.75"/>',
    'cycle':
        '<path d="M4.5 12a7.5 7.5 0 0 1 13-5.1" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"/><path d="M19.5 12a7.5 7.5 0 0 1-13 5.1" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"/><path d="M17.5 3v4h-4M6.5 21v-4h4" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"/>',
    'fork':
        '<path d="M12 3.5v6" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"/><path d="M12 9.5L5.5 15.5v5M12 9.5v11M12 9.5l6.5 6v5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"/>',
    'line':
        '<path d="M4 8h16" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"/><path d="M4 16h3M10.5 16h3M17 16h3" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"/>',
    'door':
        '<path d="M6 3h12v18H6z" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round"/><circle cx="14.5" cy="12" r="1.1" fill="currentColor"/>',
    'load':
        '<path d="M6 3.5v6M12 3.5v6M18 3.5v6" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"/><path d="M4 14h16v6H4z" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round"/>',
    'check':
        '<path d="M4 7h9M4 12h9M4 17h6" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"/><path d="M16 15.5l2 2 4-4.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"/>',
    'time':
        '<circle cx="12" cy="12" r="8.5" stroke="currentColor" stroke-width="1.75"/><path d="M12 7.5V12l3 2" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"/>',
    'flip':
        '<path d="M4 9h13l-3.5-3.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"/><path d="M20 15H7l3.5 3.5" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"/>',
    'tube':
        '<path d="M3.5 8h5a5 5 0 0 1 5 5 5 5 0 0 0 5 5h2" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"/><circle cx="3.5" cy="8" r="1.4" fill="currentColor"/><circle cx="20.5" cy="18" r="1.4" fill="currentColor"/>',
    'call':
        '<path d="M4 5.5h16V16H9.5L4 20z" stroke="currentColor" stroke-width="1.75" stroke-linejoin="round"/>',
    'roofs':
        '<path d="M2.5 11l4.5-3.5L11.5 11" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"/><path d="M12.5 15l4.5-3.5L21.5 15" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"/><path d="M2.5 20h9M12.5 20h9" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"/>',
    'shift':
        '<path d="M3.5 9h9" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"/><path d="M11.5 15h9" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"/><path d="M12.5 9h8M3.5 15h8" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-dasharray="1 3.2"/>',
  };

  static String svg(String key, {required String hex, double size = 24}) {
    final inner = (_inner[key] ?? _inner['line']!).replaceAll('currentColor', hex);
    return '<svg xmlns="http://www.w3.org/2000/svg" width="$size" height="$size" '
        'viewBox="0 0 24 24" fill="none">$inner</svg>';
  }

  static bool has(String key) => _inner.containsKey(key);

  static const back =
      '<path d="M15 5l-7 7 7 7" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"/>';
  static const chevron =
      '<path d="M9 5l7 7-7 7" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"/>';
  static const gear =
      '<circle cx="12" cy="12" r="3" stroke="currentColor" stroke-width="1.75"/><path d="M12 2.5v3M12 18.5v3M2.5 12h3M18.5 12h3M5.2 5.2l2.1 2.1M16.7 16.7l2.1 2.1M18.8 5.2L16.7 7.3M7.3 16.7L5.2 18.8" stroke="currentColor" stroke-width="1.75" stroke-linecap="round"/>';

  static String raw(String inner, {required String hex, double size = 24}) =>
      '<svg xmlns="http://www.w3.org/2000/svg" width="$size" height="$size" '
      'viewBox="0 0 24 24" fill="none">${inner.replaceAll('currentColor', hex)}</svg>';
}
