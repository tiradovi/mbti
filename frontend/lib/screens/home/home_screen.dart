import 'package:flutter/material.dart';
import 'package:frontend/common/constants.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/widgets/home/guest_section.dart';
import 'package:frontend/widgets/home/profile_menu.dart';
import 'package:frontend/widgets/home/user_section.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _nameController = TextEditingController();
  String? _errorText;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().loadSaveUser();
    });
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("로그아웃"),
        content: Text("로그아웃 하시겠습니까?"),
        actions: [
          TextButton(onPressed: () => context.pop(context), child: Text('취소')),
          TextButton(
            onPressed: () async {
              await context.read<AuthProvider>().logout();
              context.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("로그아웃 되었습니다.")));
            },
            child: Text('로그아웃', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  bool _validateName() {
    String name = _nameController.text.trim();

    // 빈값 체크
    if (name.isEmpty) {
      setState(() {
        _errorText = "이름을 입력해주세요";
      });
      return false;
    }

    // 글자 수 체크
    if (name.length < 2) {
      setState(() {
        _errorText = "이름은 2글자 이상이어야 합니다";
      });
      return false;
    }

    // 한글/영문 이외 특수문자나 숫자 포함 체크
    if (!RegExp(r'^[가-힣a-zA-Z]+$').hasMatch(name)) {
      setState(() {
        _errorText = '한글 또는 영문만 입력 가능합니다.';
      });
      return false;
    }

    setState(() {
      _errorText = null;
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final isLoggedIn = authProvider.isLoggedIn;
        final userName = authProvider.user?.userName;
        return Scaffold(
          appBar: AppBar(
            title: Text(AppConstants.appName),
            actions: [
              if (isLoggedIn)
                ProfileMenu(userName: userName, onLogout: _handleLogout),
            ],
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.psychology, size: 100, color: Colors.blue),
                    SizedBox(height: 30),
                    Text(
                      '나의 성격을 알아보는 ${AppConstants.totalQuestion}가지 질문',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 40),
                    if (!isLoggedIn)
                      GuestSection(
                        nameController: _nameController,
                        errorText: _errorText,
                        onValidate: _validateName,
                      )
                    else
                      UserSection(userName: userName),
                    SizedBox(
                      width: 300,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (isLoggedIn) {
                            context.go("/test", extra: userName);
                          } else {
                            if (_validateName()) {
                              final guestName = _nameController.text.trim();
                              context.go("/test", extra: guestName);
                            }
                          }
                        },
                        child: Text('검사 시작하기', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: 300,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => context.go('/types'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[300],
                          foregroundColor: Colors.black87,
                        ),
                        child: Text("MBTI 유형 보기"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
