class Goal {
  final String id;
  final String text;
  final String icon;
  final DateTime createdAt;
  bool selected;

  Goal({
    required this.id,
    required this.text,
    required this.icon,
    required this.createdAt,
    this.selected = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'icon': icon,
      'createdAt': createdAt.toIso8601String(),
      'selected': selected,
    };
  }

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'],
      text: json['text'],
      icon: json['icon'],
      createdAt: DateTime.parse(json['createdAt']),
      selected: json['selected'] ?? false,
    );
  }
}

class WeightGoal {
  final String id;
  final String text;
  final String icon;
  int weight;

  WeightGoal({
    required this.id,
    required this.text,
    required this.icon,
    this.weight = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'icon': icon,
      'weight': weight,
    };
  }

  factory WeightGoal.fromJson(Map<String, dynamic> json) {
    return WeightGoal(
      id: json['id'],
      text: json['text'],
      icon: json['icon'],
      weight: json['weight'] ?? 0,
    );
  }
}

enum ChallengeMode {
  daily1('一天1件事', 1),
  daily3('一天3件事', 3),
  weekly3('一周3件事', 3),
  monthly3('一月3件事', 3),
  yearly3('2026年3件事', 3),
  oneLife('一生1件事', 1);

  final String displayName;
  final int maxGoals;

  const ChallengeMode(this.displayName, this.maxGoals);
}

class User {
  final String? email;
  final String? avatar;
  final DateTime? createdAt;
  bool isCloudMode;

  User({
    this.email,
    this.avatar,
    this.createdAt,
    this.isCloudMode = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'avatar': avatar,
      'createdAt': createdAt?.toIso8601String(),
      'isCloudMode': isCloudMode,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      avatar: json['avatar'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      isCloudMode: json['isCloudMode'] ?? false,
    );
  }
}

class UserPoints {
  int totalPoints;
  int level;
  int streak;
  DateTime? lastCheckIn;
  Map<String, int> achievements;

  UserPoints({
    this.totalPoints = 0,
    this.level = 1,
    this.streak = 0,
    this.lastCheckIn,
    Map<String, int>? achievements,
  }) : achievements = achievements ?? {};

  Map<String, dynamic> toJson() {
    return {
      'totalPoints': totalPoints,
      'level': level,
      'streak': streak,
      'lastCheckIn': lastCheckIn?.toIso8601String(),
      'achievements': achievements,
    };
  }

  factory UserPoints.fromJson(Map<String, dynamic> json) {
    return UserPoints(
      totalPoints: json['totalPoints'] ?? 0,
      level: json['level'] ?? 1,
      streak: json['streak'] ?? 0,
      lastCheckIn: json['lastCheckIn'] != null
          ? DateTime.parse(json['lastCheckIn'])
          : null,
      achievements: Map<String, int>.from(json['achievements'] ?? {}),
    );
  }
}

class LevelConfig {
  final int level;
  final int minPoints;
  final String title;

  LevelConfig({
    required this.level,
    required this.minPoints,
    required this.title,
  });
}

class Achievement {
  final String id;
  final String name;
  final String description;
  final int points;
  final String icon;
  bool unlocked;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.points,
    required this.icon,
    this.unlocked = false,
  });
}
