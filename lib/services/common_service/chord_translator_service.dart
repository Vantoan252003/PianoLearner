class ChordTranslatorService {
  static const List<String> noteNames = [
    'C',
    'C#',
    'D',
    'D#',
    'E',
    'F',
    'F#',
    'G',
    'G#',
    'A',
    'A#',
    'B'
  ];

  static String midiToNote(int midi) => noteNames[midi % 12];

  static String translateChord(List<int> midiNumbers) {
    if (midiNumbers.isEmpty) return 'Không có nốt';
    if (midiNumbers.length < 2) return midiToNote(midiNumbers[0]);

    List<int> base = midiNumbers.map((m) => m % 12).toList();
    base = base.toSet().toList()..sort();

    for (var root in base) {
      final intervals = base.map((n) => (n - root) % 12).toList()..sort();
      final type = _identifyChord(intervals);
      if (type != null) return '${noteNames[root]} $type';
    }

    return '${noteNames[base.first]} Unknown';
  }

  static String? _identifyChord(List<int> iv) {
    final s = iv.toSet();

    if (s.containsAll({0, 4, 7})) return 'Major';
    if (s.containsAll({0, 3, 7})) return 'Minor';
    if (s.containsAll({0, 3, 6})) return 'Diminished';
    if (s.containsAll({0, 4, 8})) return 'Augmented';
    if (s.containsAll({0, 2, 7})) return 'Sus2';
    if (s.containsAll({0, 5, 7})) return 'Sus4';

    if (s.containsAll({0, 4, 7, 11})) return 'Major 7';
    if (s.containsAll({0, 3, 7, 10})) return 'Minor 7';
    if (s.containsAll({0, 4, 7, 10})) return 'Dominant 7';
    if (s.containsAll({0, 3, 6, 9})) return 'Diminished 7';
    if (s.containsAll({0, 3, 6, 10})) return 'Half-Diminished 7';
    if (s.containsAll({0, 3, 7, 11})) return 'Minor Major 7';
    if (s.containsAll({0, 4, 8, 10})) return 'Augmented 7';

    if (s.containsAll({0, 4, 7, 2}) && !s.contains(11)) return 'Add9';
    if (s.containsAll({0, 4, 7, 9})) return '6';
    if (s.containsAll({0, 3, 7, 9})) return 'Minor 6';

    if (s.length == 2 && s.containsAll({0, 7})) return '5';

    return null;
  }

  static String _identifyChordType(List<int> intervals) {
    Set<int> intervalSet = intervals.toSet();

    if (intervalSet.containsAll([0, 4, 7])) {
      return 'Major';
    }
    if (intervalSet.containsAll([0, 3, 7])) {
      return 'Minor';
    }

    if (intervalSet.containsAll([0, 3, 6])) {
      return 'Diminished';
    }

    if (intervalSet.containsAll([0, 4, 8])) {
      return 'Augmented';
    }

    if (intervalSet.containsAll([0, 2, 7])) {
      return 'Sus2';
    }

    if (intervalSet.containsAll([0, 5, 7])) {
      return 'Sus4';
    }

    if (intervalSet.containsAll([0, 4, 7, 11])) {
      return 'Major 7';
    }
    if (intervalSet.containsAll([0, 3, 7, 10])) {
      return 'Minor 7';
    }

    if (intervalSet.containsAll([0, 4, 7, 10])) {
      return 'Dominant 7';
    }
    if (intervalSet.containsAll([0, 3, 6, 9])) {
      return 'Diminished 7';
    }

    if (intervalSet.containsAll([0, 3, 6, 10])) {
      return 'Half-Diminished 7';
    }

    if (intervalSet.containsAll([0, 3, 7, 11])) {
      return 'Minor Major 7';
    }

    if (intervalSet.containsAll([0, 4, 8, 10])) {
      return 'Augmented 7';
    }

    if (intervalSet.containsAll([0, 4, 7, 11]) &&
        (intervalSet.contains(2) || intervalSet.contains(14))) {
      return 'Major 9';
    }

    if (intervalSet.containsAll([0, 3, 7, 10]) &&
        (intervalSet.contains(2) || intervalSet.contains(14))) {
      return 'Minor 9';
    }

    if (intervalSet.containsAll([0, 4, 7, 10]) &&
        (intervalSet.contains(2) || intervalSet.contains(14))) {
      return 'Dominant 9';
    }

    if (intervalSet.length == 2 && intervalSet.containsAll([0, 7])) {
      return '5 (Power Chord)';
    }

    if (intervalSet.containsAll([0, 4, 7, 2]) && !intervalSet.contains(11)) {
      return 'Add9';
    }

    if (intervalSet.containsAll([0, 4, 7, 9])) {
      return '6';
    }

    if (intervalSet.containsAll([0, 3, 7, 9])) {
      return 'Minor 6';
    }

    return 'Unknown';
  }

  static String translateChordVietnamese(List<int> midiNumbers) {
    String englishName = translateChord(midiNumbers);
    return _toVietnamese(englishName);
  }

  /// Chuyển tên tiếng Anh sang tiếng Việt
  static String _toVietnamese(String englishName) {
    Map<String, String> translations = {
      'Major': 'Trưởng',
      'Minor': 'Thứ',
      'Diminished': 'Giảm',
      'Augmented': 'Tăng',
      'Sus2': 'Treo 2',
      'Sus4': 'Treo 4',
      'Major 7': 'Trưởng 7',
      'Minor 7': 'Thứ 7',
      'Dominant 7': 'Bảy',
      'Diminished 7': 'Giảm 7',
      'Half-Diminished 7': 'Nửa Giảm 7',
      'Minor Major 7': 'Thứ Trưởng 7',
      'Augmented 7': 'Tăng 7',
      'Major 9': 'Trưởng 9',
      'Minor 9': 'Thứ 9',
      'Dominant 9': 'Chín',
      '5 (Power Chord)': '5 (Power Chord)',
      'Add9': 'Cộng 9',
      '6': 'Sáu',
      'Minor 6': 'Thứ 6',
      'Unknown': 'Không xác định',
    };

    // Tách root note và chord type
    List<String> parts = englishName.split(' ');
    if (parts.isEmpty) return englishName;

    String rootNote = parts[0];
    String chordType = parts.length > 1 ? parts.sublist(1).join(' ') : '';

    String vietnameseType = translations[chordType] ?? chordType;

    return chordType.isEmpty ? rootNote : '$rootNote $vietnameseType';
  }

  /// Lấy thông tin chi tiết về hợp âm
  static Map<String, dynamic> getChordInfo(List<int> midiNumbers) {
    if (midiNumbers.isEmpty) {
      return {
        'name': 'Không có nốt',
        'vietnameseName': 'Không có nốt',
        'notes': [],
        'intervals': [],
        'root': null,
      };
    }

    List<int> sorted = midiNumbers.toSet().toList()..sort();
    List<int> baseNotes = sorted.map((midi) => midi % 12).toSet().toList()
      ..sort();
    int root = baseNotes[0];
    List<int> intervals = baseNotes.map((note) => (note - root) % 12).toList();

    return {
      'name': translateChord(midiNumbers),
      'vietnameseName': translateChordVietnamese(midiNumbers),
      'notes': sorted.map((midi) => midiToNote(midi)).toList(),
      'intervals': intervals,
      'root': noteNames[root],
      'midiNumbers': sorted,
    };
  }

  /// Kiểm tra xem một tập hợp nốt có phải là hợp âm hợp lệ không
  static bool isValidChord(List<int> midiNumbers) {
    if (midiNumbers.length < 2) return false;
    String chordType = translateChord(midiNumbers);
    return chordType != 'Unknown';
  }
}
