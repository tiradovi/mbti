import 'package:flutter/material.dart';
import 'package:frontend/services/api_service.dart';
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

  bool _validateName() {
    String name = _nameController.text.trim();

    if (name.isEmpty) {
      setState(() {
        _errorText = "이름을 입력해주세요.";
      });
      return false;
    }

    if (name.length < 2) {
      setState(() {
        _errorText = "이름은 최소 2글자 이상이어야 합니다.";
      });
      return false;
    }

    if (!RegExp(r'^[가-힣a-zA-Z]+$').hasMatch(name)) {
      setState(() {
        _errorText = "한글 또는 영문만 입력 가능합니다. \n(특수문자, 숫자 불가))";
      });
      return false;
    }

    setState(() {
      _errorText = null;
    });
    return true;
  }

  void _handleSignup() async {
    _isLoading = true;
    if (_validateName()) {
      String name = _nameController.text.trim();
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('회원가입에 실패했습니다. 다시 시도해주세요.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }else{
      _isLoading=false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('양식이 맞지 않습니다. 다시 시도해주세요.'),
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
                        if (RegExp(r'[0-9]').hasMatch(value)) {
                          _errorText = '숫자는 입력할 수 없습니다.';
                        } else if (RegExp(r'[^가-힣a-zA-Z]').hasMatch(value)) {
                          _errorText = '한글과 영어만 입력 가능합니다.';
                        } else {
                          _errorText = null;
                        }
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
