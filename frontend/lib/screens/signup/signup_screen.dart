import 'package:flutter/material.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/utils/name_validator.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  String? _errorText;
  bool _isLoading = false;

  void _handleSignup() async {
    final name = _nameController.text.trim();

    setState(() {
      _isLoading = true;
      _errorText = NameValidator.validate(name);
    });

    if (_errorText != null) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('양식이 맞지 않습니다. 다시 시도해주세요.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final user = await ApiService.signup(name);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${user.userName}님, 회원가입이 완료되었습니다!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      context.go('/');
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('회원가입에 실패했습니다. 다시 시도해주세요.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
        leading: IconButton(
          onPressed: () => {context.go('/')},
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_add, size: 100, color: Colors.green),
                Text(
                  'MBTI 검사를 위해\n회원가입해주세요.',
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
                      prefixIcon: Icon(Icons.person_outline),
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
                SizedBox(height: 40),
                SizedBox(
                  width: 300,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      _isLoading ? null : _handleSignup();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey[400],
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            '회원가입하기',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('이미 계정이 있으신가요?'),
                    TextButton(
                      onPressed: _isLoading ? null : () => context.go('/login'),
                      child: Text('로그인하기'),
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
