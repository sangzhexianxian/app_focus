import 'package:flutter/material.dart';
import '../models/goal.dart';

class PointsProvider with ChangeNotifier {
  UserPoints _points = UserPoints();

  static const List<LevelConfig> levels = [
    LevelConfig(level: 1, minPoints: 0, title: '专注新手'),
    LevelConfig(level: 2, minPoints: 100, title: '入门者'),
    LevelConfig(level: 3, minPoints: 300, title: '专注达人'),
    LevelConfig(level: 4, minPoints: 600, title: '专注大师'),
    LevelConfig(level: 5, minPoints: 1000, title: '专注专家'),
    LevelConfig(level: 6, minPoints: 2000, title: '专注传奇'),
  ];

  static const List<Achievement> achievements = [
    Achievement(
      id: 'first_checkin',
      name: '首次签到',
      description: '完成第一次每日签到',
      points: 10,
      icon: '📅',
    ),
    Achievement(
      id: 'week_streak',
      name: '连续七天',
      description: '连续签到7天',
      points: 20,
      icon: '🔥',
    ),
    Achievement(
      id: 'month_streak',
      name: '连续一月',
      description: '连续签到30天',
      points: 30,
      icon: '💪',
    ),
    Achievement(
      id: 'goals_completed',
      name: '目标达成',
      description: '完成所有设定的目标',
      points: 100,
      icon: '✅',
    ),
    Achievement(
      id: 'points_100',
      name: '百积分',
      description: '累计获得100积分',
      points: 0,
      icon: '💎',
    ),
    Achievement(
      id: 'points_500',
      name: '五百分',
      description: '累计获得500积分',
      points: 0,
      icon: '🌟',
    ),
  ];

  UserPoints get points => _points;
  LevelConfig get currentLevel => levels.firstWhere(
        (level) => _points.totalPoints >= level.minPoints,
        orElse: () => levels.last,
      );
  LevelConfig get nextLevel {
    final currentIndex = levels.indexOf(currentLevel);
    return currentIndex < levels.length - 1
        ? levels[currentIndex + 1]
        : currentLevel;
  }
  List<Achievement> get unlockedAchievements {
    return achievements.where((a) => a.unlocked).toList();
  }

  void addPoints(int amount, {String? reason}) {
    _points.totalPoints += amount;
    _updateLevel();
    _checkAchievements();
    _savePoints();
    notifyListeners();
  }

  void _updateLevel() {
    for (var level in levels.reversed) {
      if (_points.totalPoints >= level.minPoints) {
        _points.level = level.level;
        break;
      }
    }
  }

  void _checkAchievements() {
    // 检查积分成就
    if (_points.totalPoints >= 100) {
      _unlockAchievement('points_100');
    }
    if (_points.totalPoints >= 500) {
      _unlockAchievement('points_500');
    }
  }

  void _unlockAchievement(String achievementId) {
    final achievement = achievements.firstWhere((a) => a.id == achievementId);
    if (!_points.achievements.containsKey(achievementId)) {
      _points.achievements[achievementId] = DateTime.now().millisecondsSinceEpoch;
      _points.totalPoints += achievement.points;
    }
  }

  Future<void> dailyCheckIn() async {
    final today = DateTime.now();
    final todayStr = '${today.year}-${today.month}-${today.day}';

    if (_points.lastCheckIn != null) {
      final lastDate = _points.lastCheckIn!;
      final lastDateStr = '${lastDate.year}-${lastDate.month}-${lastDate.day}';

      if (lastDateStr == todayStr) {
        return; // 今天已经签到过
      }

      final yesterday = today.subtract(const Duration(days: 1));
      final yesterdayStr = '${yesterday.year}-${yesterday.month}-${yesterday.day}';

      if (lastDateStr == yesterdayStr) {
        // 连续签到
        _points.streak++;
      } else {
        // 中断了,重新开始
        _points.streak = 1;
      }
    } else {
      // 第一次签到
      _points.streak = 1;
    }

    _points.lastCheckIn = today;

    // 基础积分
    addPoints(10, reason: '每日签到');

    // 连续签到奖励
    if (_points.streak == 7) {
      addPoints(20, reason: '连续7天');
      _unlockAchievement('week_streak');
    } else if (_points.streak == 30) {
      addPoints(30, reason: '连续30天');
      _unlockAchievement('month_streak');
    }

    _unlockAchievement('first_checkin');

    _savePoints();
  }

  void completeGoals() {
    addPoints(50, reason: '完成专注卡');
    _unlockAchievement('goals_completed');
  }

  void shareCard() {
    addPoints(15, reason: '分享专注卡');
  }

  String getLevelProgress() {
    final currentMin = currentLevel.minPoints;
    final nextMin = nextLevel.minPoints;
    final current = _points.totalPoints;
    final progress = ((current - currentMin) / (nextMin - currentMin) * 100).toInt();
    return '$current / $nextMin';
  }

  double getLevelProgressPercent() {
    final currentMin = currentLevel.minPoints;
    final nextMin = nextLevel.minPoints;
    final current = _points.totalPoints;
    return ((current - currentMin) / (nextMin - currentMin)).clamp(0.0, 1.0);
  }

  Future<void> _savePoints() async {
    // 保存到本地
    // 暂时留空,后续实现
  }

  Future<void> loadPoints() async {
    // 从本地加载
    // 暂时留空,后续实现
  }

  Future<void> syncToCloud() async {
    // 同步到云端
    // 暂时留空,后续实现
  }
}
