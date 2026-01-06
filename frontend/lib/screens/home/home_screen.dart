import 'package:flutter/material.dart';
import 'package:frontend/common/constants.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /*
  만약 Input이나 TextArea 를 사용할 경우
  사용자들이 작성한 값을 읽고 읽은 값을 가져오기 위해 기능 작성 필요
  -> dart에서는 TextEditingController 객체를 미리 만들어 놓았음

  사용방법
  1. 컨트롤러를 담을 변수 공간 설정 private 설정 권장
  2. TextField에 연결
    TextField(
    controller:_nameController와 같은 형태로 내부에서 작성된 value를 연결
    )
  3. 값을 가져와서 확인거나 사용
  String name = _nameController.text;
  */
  final TextEditingController _nameController = TextEditingController();

  String? _errorText;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().loadSaveUser();
    });
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

  void _handleLogout() {}

  /*
  키보드를 화면에서 사용해야하는 경우
  화면이 가려지는 것을 방지하기 위해 스크롤 가능하게 처리
   */
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
                PopupMenuButton<String>(
                  icon: Icon(Icons.account_circle),
                  onSelected: (value) {
                    if (value == 'logout') {
                      _handleLogout();
                    } else if (value == 'history') {
                      context.go("/history", extra: userName);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(child: Text('$userName님')),
                    PopupMenuItem(value: 'history', child: Text('내 기록 보기')),
                    PopupMenuDivider(),
                    PopupMenuItem(value: 'logout', child: Text('로그아웃')),
                  ],
                ),
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
                    SizedBox(
                      width: 300,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => context.go("/login"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                        ),
                        child: Text('로그인하기', style: TextStyle(fontSize: 20)),
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: 300,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => context.go("/signup"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                        ),
                        child: Text('회원가입하기', style: TextStyle(fontSize: 20)),
                      ),
                    ),
                    SizedBox(height: 20),
                    /*
            방법1: 입력할 때마다 유효성 검사
            방법2: ElevatedButton 클릭시 유효성 검사
             */
                    SizedBox(
                      width: 300,
                      child: TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: '이름',
                          hintText: '이름을 입력하세요',
                          border: OutlineInputBorder(),
                          errorText: _errorText,
                        ),
                        onChanged: (value) {
                          // 모든 상태 실시간 변경은 setState 내부에 작성해야함
                          _validateName();
                        },
                        /*
                    글자를 입력하면 에러메세지 비우기
                    onChanged: (value) {
                      if (_errorText != null) {
                        setState(() {
                          _errorText = null;
                        });
                      }
                    },*/
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: 300,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          String name = _nameController.text.trim();
                          if (_validateName()) {
                            context.go("/test", extra: name);
                          }
                        },
                        child: Text('검사 시작하기', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    /* div와 성격이 같은 SizeBox를 이용해서 이전 결과 보기 버튼 생성 가능, 상태관리를 위해 box로 감싸기 추천 */
                    SizedBox(height: 20),
                    SizedBox(
                      width: 300,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          String name = _nameController.text.trim();
                          if (_validateName()) {
                            context.go('/history', extra: name);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black87,
                        ),
                        child: Text("이전 결과 보기"),
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
}
