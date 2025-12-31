import 'package:flutter/material.dart';
import 'package:frontend/models/question_model.dart';
import 'package:frontend/services/api_service.dart';
import 'package:go_router/go_router.dart';

class TestScreen extends StatefulWidget {
  final String userName;

  const TestScreen({super.key, required this.userName});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  List<dynamic> questions = [];
  int currentQuestion = 0;
  Map<int, String> answers = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  void loadQuestions() async {
    try {
      final data = await ModelApiService.getQuestions();
      setState(() {
        questions = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  /* api로 교체함
  final List<Map<String, String>> questions = [
    {
      'text': '친구들과 노는 것이 좋다',
      'optionA': '매우 그렇다 (E)',
      'optionB': '혼자 있는 게 좋다 (I)',
    },
    {'text': '계획을 세우는 것이 좋다', 'optionA': '계획적이다 (J)', 'optionB': '즉흥적이다 (P)'},
  ];
*/

  // selectAnswer(String option)
  // 선택한 답변 저장
  // 다음 질문으로 넘어가고 12문제가 끝나면 결과 화면 이동
  void selectAnswer(String option) {
    setState(() {
      answers[questions[currentQuestion].id] = option; // 답변들 저장
      if (currentQuestion < questions.length - 1) {
        currentQuestion++;
      } else {
        // 결과 화면으로 이동
        submitTest();
        //_showResult();
      }
    });
  }

  void _showResult() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('검사 완료'),
        content: Text('${widget.userName}님의 답변 : \n ${answers.toString()}'),
        actions: [
          TextButton(
            onPressed: () {
              context.go('/');
            },
            child: Text('처음으로'),
          ),
        ],
      ),
    );
  }

  void submitTest() async {
    try {
      final result = await ModelApiService.submitTest(widget.userName, answers);
      if(mounted){
        context.go("/result", extra: {
          'userName': widget.userName,
          'resultType':result.resultType
        });
      }
    /* showDialog(context: context, builder: (context)=>AlertDialog(
        title: Text('검사 완료'),
        content :Text(
          '${widget.userName}님은 ${result['resultType']}입니다.'
        ),
        actions: [
          TextButton(onPressed: ()=> context.go("/"), child: Text('처음으로'),)
        ],
      ));*/
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("제출 실패")));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('불러오는중 ')),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    Question q = questions[currentQuestion];

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
              '질문 ${currentQuestion + 1} /${questions.length} ',
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
            SizedBox(height: 20),

            // 진행바
            LinearProgressIndicator(
              value: (currentQuestion + 1) / questions.length,
              minHeight: 10,
            ),
            SizedBox(height: 20),
            Text(
              q.questionText,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 60),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () => selectAnswer('A'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: Text(
                  q.optionA,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 60),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () => selectAnswer('B'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: Text(
                  q.optionB,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
