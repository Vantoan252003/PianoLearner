// models/achievement.dart

import 'dart:convert';

class Achievement {
  final int achievementId;
  final String achievementName;
  final String? description;
  final String? iconUrl;
  final String? requirementType;
  final int? requirementValue;
  final int expReward;

  Achievement({
    required this.achievementId,
    required this.achievementName,
    this.description,
    this.iconUrl,
    this.requirementType,
    this.requirementValue,
    required this.expReward,
  });

  /// Tạo từ Map/JSON
  factory Achievement.fromJson(Map<String, dynamic> json) {
    int? reqValue;
    if (json['requirementValue'] != null) {
      final v = json['requirementValue'];
      if (v is num)
        reqValue = v.toInt();
      else if (v is String) reqValue = int.tryParse(v);
    }

    return Achievement(
      achievementId: (json['achievementId'] is num)
          ? (json['achievementId'] as num).toInt()
          : int.parse(json['achievementId'].toString()),
      achievementName: json['achievementName']?.toString() ?? '',
      description: json['description']?.toString(),
      iconUrl: json['iconUrl']?.toString(),
      requirementType: json['requirementType']?.toString(),
      requirementValue: reqValue,
      expReward: (json['expReward'] is num)
          ? (json['expReward'] as num).toInt()
          : int.parse(json['expReward'].toString()),
    );
  }

  Map<String, dynamic> toJson() => {
        'achievementId': achievementId,
        'achievementName': achievementName,
        'description': description,
        'iconUrl': iconUrl,
        'requirementType': requirementType,
        'requirementValue': requirementValue,
        'expReward': expReward,
      };

  Achievement copyWith({
    int? achievementId,
    String? achievementName,
    String? description,
    String? iconUrl,
    String? requirementType,
    int? requirementValue,
    int? expReward,
  }) {
    return Achievement(
      achievementId: achievementId ?? this.achievementId,
      achievementName: achievementName ?? this.achievementName,
      description: description ?? this.description,
      iconUrl: iconUrl ?? this.iconUrl,
      requirementType: requirementType ?? this.requirementType,
      requirementValue: requirementValue ?? this.requirementValue,
      expReward: expReward ?? this.expReward,
    );
  }

  @override
  String toString() {
    return 'Achievement(id: $achievementId, name: $achievementName, exp: $expReward)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Achievement &&
          runtimeType == other.runtimeType &&
          achievementId == other.achievementId &&
          achievementName == other.achievementName &&
          expReward == other.expReward;

  @override
  int get hashCode =>
      achievementId.hashCode ^ achievementName.hashCode ^ expReward.hashCode;
}

List<Achievement> achievementsFromJsonString(String jsonStr) {
  final data = json.decode(jsonStr);
  if (data is List) {
    return data.map((e) {
      if (e is Map<String, dynamic>) return Achievement.fromJson(e);
      return Achievement.fromJson(Map<String, dynamic>.from(e as Map));
    }).toList();
  }
  throw FormatException('Expected a JSON array');
}
