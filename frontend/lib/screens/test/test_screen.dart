import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TestScreen extends StatefulWidget {
  final String userName;

  const TestScreen({super.key, required this.userName});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  // 변수선언
  // 데이터 선언
  // 기능 선언
  // 현재 질문 번호(1~12)
  int currentQuestion = 1;
  Map<int, String> answer = {}; // 답변 저장 {질문번호: 'A' or 'B'}

  final List<Map<String, String>> questions = [
    {
      'text': '친구들과 노는 것이 좋다',
      'optionA': '매우 그렇다 (E)',
      'optionB': '혼자 있는 게 좋다 (I)',
    },
    {'text': '계획을 세우는 것이 좋다', 'optionA': '계획적이다 (J)', 'optionB': '즉흥적이다 (P)'},
  ];

  // selectAnswer(String option)
  // 선택한 답변 저장
  // 다음 질문으로 넘어가고 12문제가 끝나면 결과 화면 이동

  // void showResult(){}

  @override
  Widget build(BuildContext context) {
    int questionIndex = currentQuestion - 1;
    if (questionIndex >= questions.length) {
      questionIndex = questions.length - 1;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.userName}님의 검사"),
        leading: IconButton(
          onPressed: () => context.go('/'),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '질문 $currentQuestion/12 ',
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
            SizedBox(height: 20),

            // 진행바
            LinearProgressIndicator(value: currentQuestion / 12, minHeight: 10),
            SizedBox(height: 20),
            Text(
              /*
              만약에 데이터가 없는 경우
               questions[questionIndex]['text'] ?? '질문 없음', -> 질문없음을 text내부에 사용
               questions[questionIndex]['text'] ! -> data가 null이 아닌 반드시 존재
               questions[questionIndex]['text'] as String
               */
              questions[questionIndex]['text'] ?? '질문 없음',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 60),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () => context.go('/selectAnswer'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue
                ),
                child: Text(questions[questionIndex]['optionA']!,
                style: TextStyle(fontSize: 20, color: Colors.white),),
              ),
            ),
            SizedBox(height: 60),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () => context.go('/selectAnswer'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue
                ),
                child: Text(questions[questionIndex]['optionB']!,
                  style: TextStyle(fontSize: 20, color: Colors.white),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
