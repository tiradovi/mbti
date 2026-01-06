import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;

  // Getter
  User? get user => _user;

  bool get isLoading => _isLoading;

  bool get isLoggedIn => _user != null;

  // 로그인 처리 관련 함수
  Future<void> login(User user) async {
    _user = user;
    _isLoading = false;

    // SharedPreferences 에 사용자 정보 저장
    // 어플 재시작 후에도 로그인 유지

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', user.id);
    await prefs.setString('userName', user.userName);

    // UI 업데이트
    notifyListeners();
  }

  // 로그아웃 처리 관련 함수
  Future<void> logout() async {
    _user = null;

    // SharedPreferences 에 사용자 정보 삭제
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('userName');

    // UI 업데이트
    notifyListeners();
  }

  // 어플 시작시 저장된 로그인 상태 복원
  Future<void> loadSaveUser() async {
    _isLoading = true;

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      final userName = prefs.getString('userName');
      if (userId != null && userName != null) {
        _user = User(
          id: userId,
          userName: userName,
          createdAt: null,
          lastLogin: null,
        );
      }
    } catch (e) {
      print('Error loading saved User: $e');
    } finally {
      _isLoading = false;
    }

    notifyListeners();
  }

  // 로딩 상태 설정
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
