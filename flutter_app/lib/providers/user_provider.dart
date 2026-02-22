import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/goal.dart';

class UserProvider with ChangeNotifier {
  User _user = User();
  bool _isLoggedIn = false;
  bool _isLoading = false;

  User get user => _user;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        _user = User(
          email: response.user!.email,
          avatar: response.user!.userMetadata?['avatar_url'],
          createdAt: response.user!.createdAt,
          isCloudMode: true,
        );
        _isLoggedIn = true;
      }
    } catch (e) {
      debugPrint('登录失败: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> register(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        _user = User(
          email: response.user!.email,
          avatar: response.user!.userMetadata?['avatar_url'],
          createdAt: response.user!.createdAt,
          isCloudMode: true,
        );
        _isLoggedIn = true;
      }
    } catch (e) {
      debugPrint('注册失败: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> guestLogin() async {
    _user = User(
      isCloudMode: false,
      createdAt: DateTime.now(),
    );
    _isLoggedIn = true;
    _saveUserLocally();
    notifyListeners();
  }

  Future<void> logout() async {
    await Supabase.instance.client.auth.signOut();
    _user = User();
    _isLoggedIn = false;
    notifyListeners();
  }

  Future<void> _saveUserLocally() async {
    // 使用 SharedPreferences 保存用户信息
    // 暂时留空,后续实现
  }

  Future<void> loadUserLocally() async {
    // 从本地加载用户信息
    // 暂时留空,后续实现
  }

  Future<void> syncToCloud() async {
    if (!_isLoggedIn || !_user.isCloudMode) {
      return;
    }

    try {
      // 同步数据到 Supabase
      // 暂时留空,后续实现
    } catch (e) {
      debugPrint('同步失败: $e');
    }
  }
}
