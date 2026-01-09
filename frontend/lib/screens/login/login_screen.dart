import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import '../../services/api_service.dart';
import '../../utils/name_validator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _nameController = TextEditingController();
  String? _errorText;
  bool _isLoading = false;

  void _handleLogin() async {
    final name = _nameController.text.trim();

    setState(() {
      _isLoading = true;
      _errorText = NameValidator.validate(name);
    });

    if (_errorText != null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final user = await ApiService.login(name);

      if (!mounted) return;

      await context.read<AuthProvider>().login(user);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${user.userName}님, 돌아온걸 환영합니다.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      context.go('/');
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('로그인에 실패했습니다. 다시 시도해주세요.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('로그인'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person, size: 100, color: Colors.blue),
                SizedBox(height: 30),
                Text(
                  'MBTI 검사를 위해 \n로그인해주세요',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _nameController,
                    enabled: !_isLoading,
                    decoration: InputDecoration(
                      labelText: '이름',
                      hintText: '이름을 입력하세요',
                      border: OutlineInputBorder(),
                      errorText: _errorText,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _errorText = NameValidator.validate(value);
                      });
                    },
                  ),
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: 300,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey[400],
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            '로그인하기',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '계정이 없으신가요?',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    TextButton(
                      onPressed: _isLoading
                          ? null
                          : () => context.go('/signup'),
                      child: Text('회원가입하기'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
