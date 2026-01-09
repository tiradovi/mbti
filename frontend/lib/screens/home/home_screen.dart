import 'package:flutter/material.dart';
import 'package:frontend/common/constants.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/utils/name_validator.dart';
import 'package:frontend/widgets/home/guest_section.dart';
import 'package:frontend/widgets/home/profile_menu.dart';
import 'package:frontend/widgets/home/user_section.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../services/network_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /*
  textField TextFormField 처럼 텍스트를 제어하고 관리하는 클래스

  _nameController : private

  예시
  TextField(controller : _nameController,)

  클라이언트가 필드내부에 텍스트 작성 후 작성한 텍스트를 가져와서 사용하는 경우
  String name = _nameController.text

  _nameController 내부 텍스트 변경 방법
  _nameController.text = "홍길동"

   */
  final TextEditingController _nameController = TextEditingController();
  String? _errorText;
  final NetworkService _networkService = NetworkService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().loadSaveUser();
    });
    _checkNetwork();
  }

  void _checkNetwork() async {
    final status = await _networkService.checkStatus();

    if (mounted && status.contains("않")) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(status), backgroundColor: Colors.orange,
              duration: Duration(seconds: 3))
      );
    }
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

  void _onGuestNameChanged(String value) {
    setState(() {
      _errorText = NameValidator.validate(value);
    });
  }

  bool _validateBeforeStart() {
    final name = _nameController.text.trim();
    final error = NameValidator.validate(name);

    setState(() {
      _errorText = error;
    });

    return error == null;
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
                        onChanged: _onGuestNameChanged,
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
                            if (_validateBeforeStart()) {
                              context.go("/test", extra: _nameController.text.trim());
                            }
                          }
                        },
                        child: Text('검사 시작하기', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    SizedBox(height: 10),
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
