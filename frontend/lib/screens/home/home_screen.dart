import 'package:flutter/material.dart';
import 'package:frontend/common/constants.dart';
import 'package:go_router/go_router.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppConstants.appName)),
      body: Center(
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
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: '이름',
                  hintText: '이름을 입력하세요',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 300,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  String name = _nameController.text.trim();
                  if(name.isEmpty){
                    return;
                  }
                  context.go("/test",extra: name);
                  },
                child: Text('검사 시작하기', style: TextStyle(fontSize: 16),),
              ),
            ),
            /* div와 성격이 같은 SizeBox를 이용해서 이전 결과 보기 버튼 생성 가능, 상태관리를 위해 box로 감싸기 추천 */
          ],
        ),
      ),
    );
  }
}
