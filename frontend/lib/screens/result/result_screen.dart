import 'package:flutter/material.dart';
import 'package:frontend/models/result_model.dart';
import 'package:frontend/widgets/score_bar.dart';
import 'package:go_router/go_router.dart';

class ResultScreen extends StatefulWidget {
  // 로딩 추가 예정
  final Result result;

  const ResultScreen({
    super.key,
     required this.result,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('검사 결과'), automaticallyImplyLeading: false),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.celebration, size: 100, color: Colors.amber),
              SizedBox(height: 30),
              Text(
                '검사완료',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 40),

              Container(
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.purple,
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text('${widget.result.userName}님의 MBTI는'),
                    SizedBox(height: 20),
                    Text(
                      '${widget.result.resultType}!',
                      style: TextStyle(fontSize: 30),
                    ),
                    SizedBox(height: 10),
                    Text('입니다.'),
                  ],
                ),
              ),
              SizedBox(height: 60),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey[300]!, width: 2),
                ),
                child: Column(
                  children: [
                    Text(
                      '상세 점수',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(height: 16),
                    ScoreBar(
                      label1: 'E (외향)',
                      label2: 'I (내향)',
                      score1: widget.result.eScore,
                      score2: widget.result.iScore,
                    ),
                    ScoreBar(
                      label1: 'S (감각)',
                      label2: 'N (직관)',
                      score1: widget.result.sScore,
                      score2: widget.result.nScore,
                    ),
                    ScoreBar(
                      label1: 'T (사고)',
                      label2: 'F (감정)',
                      score1: widget.result.tScore,
                      score2: widget.result.fScore,
                    ),
                    ScoreBar(
                      label1: 'J (판단)',
                      label2: 'P (인식)',
                      score1: widget.result.jScore,
                      score2: widget.result.pScore,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 60),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () => context.go('/'),
                  child: Text('처음으로'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
