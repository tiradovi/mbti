import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import '../../services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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

  void _handleLogin() async {
    if (_validateName()) {
      _isLoading = true;
      String name = _nameController.text.trim();
      try {
        /*
        final user = await ApiService.login(name);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${user.userName}님, 돌아온걸 환영합니다.'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        context.go('/test', extra: name);
      */
      String name = _nameController.text.trim();
      final user = await ApiService.login(name);

      if(mounted){
        await context.read<AuthProvider>().login(user);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${user.userName}님, 돌아온걸 환영합니다.'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
      context.go('/');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('이름이 없습니다. 회원가입을 하거나 다시 시도해주세요.'),
            backgroundColor: Colors.red,
          ),
        );
      }finally{
        _isLoading=false;
      }
    }else{
      return;
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
                    onChanged: (value) {
                      _validateName;
                    },
                    decoration: InputDecoration(
                      labelText: '이름',
                      hintText: '이름을 입력하세요',
                      border: OutlineInputBorder(),
                      errorText: _errorText,
                    ),
                  ),
                ),

                SizedBox(height: 30),
                SizedBox(
                  width: 300,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      '로그인하기',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
