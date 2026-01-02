import 'package:flutter/material.dart';
import 'package:frontend/models/result_model.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/widgets/loading_view.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/error_view.dart';

class ResultDetailScreen extends StatefulWidget {
  final String userName;

  const ResultDetailScreen({super.key, required this.userName});

  @override
  State<ResultDetailScreen> createState() => _ResultDetailScreenState();
}

class _ResultDetailScreenState extends State<ResultDetailScreen> {
  List<Result> results = [];
  bool isLoading = true;
  String? errorMessage;


  @override
  void initState() {
    super.initState();
    loadResults();
  }

  void loadResults() async {
    try {
      final data = await ApiService.getResultsByUserName(widget.userName);
      setState(() {
        results = data;
        isLoading = false;
        errorMessage = null;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = '결과 불러오기 실패';
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('불러오는중 ')),
        body: LoadingView(message: "결과 가져오는 중"),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: Text("오류 발생")),
        body: ErrorView(message: errorMessage!, onRetry: loadResults),
      );
    }


    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.userName}님의 검사 기록'),
        leading: IconButton(
          onPressed: () => context.go('/'),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: results.isEmpty?
          Center(
            child: Text('검사 기록이 없습니다.', style: TextStyle(fontSize: 18),),
          )
          : ListView.builder(
              itemCount: results.length,
              padding: EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final r = results[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text(
                        r.resultType,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      r.resultType,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'E:${r.eScore} I:${r.iScore} S:${r.sScore} N:${r.nScore} \n'
                      'T:${r.tScore} F:${r.fScore} j:${r.jScore} P:${r.pScore}',
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(r.resultType),
                          content: Text(
                            '${r.typeName ?? r.resultType} \n\n ${r.description ?? "정보 없음"}',
                          ),
                          actions: [
                            TextButton(onPressed: ()=> Navigator.pop(context), child: Text('닫기'))
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

/* 개발자가 작성하는 경우
      ListView(children: [
        Text('ABCD'),
        Text('EFGH'),
        Text('IJKL'),
      ],)

    DB에서 가져오는 경우
    ListView.builder(
        itemCount : results.length
        itemBuilder: (context,index){
          final r = results[index];
          return Card(child: ListTile(
              child: Text(r.resultType, style: TextStyle(color: Colors.white),),
          );
        },
      )

      RangeError (length): Invalid value: Only valid value is 0: 1
 */
