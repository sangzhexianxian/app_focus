import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/goal.dart';

class GoalProvider with ChangeNotifier {
  final List<Goal> _allGoals = [];
  List<Goal> _top5Goals = [];
  List<WeightGoal> _top3Goals = [];
  int _currentStep = 1;
  ChallengeMode _challengeMode = ChallengeMode.yearly3;

  List<Goal> get allGoals => _allGoals;
  List<Goal> get top5Goals => _top5Goals;
  List<WeightGoal> get top3Goals => _top3Goals;
  int get currentStep => _currentStep;
  ChallengeMode get challengeMode => _challengeMode;

  static const List<String> goalIcons = [
    '🎯', '💪', '📚', '🏃', '💼', '🚀', '✨', '🌟', '🔥', '💎',
  ];

  void addGoal(String text) {
    if (text.trim().isEmpty) return;

    final goal = Goal(
      id: const Uuid().v4(),
      text: text.trim(),
      icon: goalIcons[_allGoals.length % goalIcons.length],
      createdAt: DateTime.now(),
      selected: false,
    );

    _allGoals.add(goal);
    _saveData();
    notifyListeners();
  }

  void removeGoal(String id) {
    _allGoals.removeWhere((goal) => goal.id == id);
    _saveData();
    notifyListeners();
  }

  void toggleGoalSelection(String id) {
    final goal = _allGoals.firstWhere((g) => g.id == id);
    goal.selected = !goal.selected;
    notifyListeners();
  }

  void goToStep2() {
    final selectedGoals = _allGoals.where((g) => g.selected).toList();

    if (selectedGoals.isEmpty) {
      _top5Goals = List.from(_allGoals);
    } else {
      _top5Goals = selectedGoals.map((g) => Goal.fromJson(g.toJson())..selected = false).toList();
    }

    _currentStep = 2;
    _saveData();
    notifyListeners();
  }

  void toggleStep2Goal(String id) {
    final goal = _top5Goals.firstWhere((g) => g.id == id);
    goal.selected = !goal.selected;
    notifyListeners();
  }

  void goToStep3() {
    final selectedGoals = _top5Goals.where((g) => g.selected).toList();

    if (selectedGoals.isEmpty) {
      // 使用全部 goals
      _top3Goals = _top5Goals.map((g) => WeightGoal.fromJson({
        'id': g.id,
        'text': g.text,
        'icon': g.icon,
        'weight': 0,
      })).toList();
    } else {
      // 使用选中的 goals
      _top3Goals = selectedGoals.map((g) => WeightGoal.fromJson({
        'id': g.id,
        'text': g.text,
        'icon': g.icon,
        'weight': 0,
      })).toList();
    }

    _currentStep = 3;
    _saveData();
    notifyListeners();
  }

  void toggleStep3Goal(String id) {
    final goal = _top3Goals.firstWhere((g) => g.id == id);
    goal.selected = !goal.selected;
    notifyListeners();
  }

  void goToStep4() {
    _currentStep = 4;
    _saveData();
    notifyListeners();
  }

  void updateWeight(int index, int weight) {
    _top3Goals[index].weight = weight;
    _saveData();
    notifyListeners();
  }

  bool isWeightValid() {
    final total = _top3Goals.fold<int>(0, (sum, goal) => sum + goal.weight);
    return total == 100;
  }

  int getTotalWeight() {
    return _top3Goals.fold<int>(0, (sum, goal) => sum + goal.weight);
  }

  void generateCard() {
    _currentStep = 5;
    _saveData();
    notifyListeners();
  }

  void setChallengeMode(ChallengeMode mode) {
    _challengeMode = mode;
    notifyListeners();
  }

  void reset() {
    _allGoals.clear();
    _top5Goals.clear();
    _top3Goals.clear();
    _currentStep = 1;
    _saveData();
    notifyListeners();
  }

  Future<void> _saveData() async {
    // 这里使用 Hive 或 SharedPreferences 保存数据
    // 暂时留空,后续实现
  }

  Future<void> loadData() async {
    // 从本地加载数据
    // 暂时留空,后续实现
  }

  void goBackToStep(int step) {
    _currentStep = step;
    _saveData();
    notifyListeners();
  }
}
