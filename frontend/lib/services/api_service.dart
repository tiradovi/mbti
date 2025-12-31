import 'dart:convert';

import 'package:frontend/models/answer_model.dart';
import 'package:frontend/models/question_model.dart';
import 'package:frontend/models/result_model.dart';
import 'package:frontend/models/test_request_model.dart';
import 'package:http/http.dart' as http;

class ModelApiService {
  // models에 작성한 자료형 변수이름 활용하여 데이터 타입 지정
  static const String url = 'http://localhost:8080/api/mbti';

  // 백엔드 컨트롤러에서 질문 가져오기
  // 보통 백엔드나 외부 api 데이터를 가져올 때 자료형으로 Future 특정 자료형을 감싸서 사용
  static Future<List<Question>> getQuestions() async {
    final res = await http.get(Uri.parse('$url/questions'));
    /*
    res.body = 백엔드에서 가져온 JSON 문자열 -> 한 줄
    json.decode = 한줄을 Dart 객체로 변환
     */

    if (res.statusCode == 200) {
      List<dynamic> jsonList = json.decode(res.body);

      return jsonList.map((json) => Question.fromJson(json)).toList();
    } else {
      throw Exception('불러오기 실패');
    }
  }

  /*
  Map<int, String> answer내에는 소비자가 작성한 원본 데이터가 존재
 { 1:'A',
   2:'B',
   3:'A'..}

  answer.entries 의 경우 Map을 MapEntry 리스트로 변환
  결과 = [
    MapEntry(key:1, value='A'),
    MapEntry(key:2, value='B'),
    MapEntry(key:3, value='A'),..
  ]
   */
  static Future<Result> submitTest(
    String userName,
    Map<int, String> answers,
  ) async {
    List<TestAnswer> answerList = answers.entries.map((en) {
      return TestAnswer(questionId: en.key, selectedOption: en.value);
    }).toList();

    TestRequest request = TestRequest(userName: userName, answers: answerList);

    final res = await http.post(
      Uri.parse('$url/submit'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(request.toJson()),
    );

    if (res.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(res.body);
      /*
      dynamic 사용 이유 : 컴파일단계에서는 타입 상관X, 런타임에서 타입 상관하여 에러발생 가능
      key: 'id','userName',.. 전부 String
      value: 1,'김씨'         전부 다를 수 있음

      Object 사용이 불가한 이유: Dart에서 컴파일 단계에서 연산 불가
      중간에 null인 경우 Object는 처리 불가
      단 java의 경우 null 가능
       */
      return Result.fromJson(jsonData);
    } else {
      throw Exception('제출 실패');
    }
  }

  /*
   * 사용자별 결과 조회
   * GET /api/mbti/results?userName={userName}
   * Dart는 변수 이름 뒤에 하위 변수나 하위 기능이 존재하지 않는 경우
   * $변수이름 {} 없이 작성가능
   * 기능 존재시
   * ${변수이름.세부기능()}으로 작성
   */
  static Future<List<Result>> getResultsByUserName(String userName) async {
    final res = await http.get(Uri.parse('$url/results?userName=$userName'));

    if (res.statusCode == 200) {
      List<dynamic> jsonList = json.decode(res.body);
      return jsonList.map((json) => Result.fromJson(json)).toList();
    } else {
      throw Exception('불러오기 실패');
    }
  }
}

class DynamicApiService {
  /*
  단기적으로 값 변경 불가 = final
  장기적으로 전체 공유하는 상수 = const

  const = 어플 전체적으로 사용
  final = 특정 기능이나 특정 화면에서만 부분적으로 사용되는 상수 명칭
   */
  static const String url = 'http://localhost:8080/api/mbti';

  // 백엔드 컨트롤러에서 질문 가져오기
  // 보통 백엔드나 외부 api 데이터를 가져올 때 자료형으로 Future 특정 자료형을 감싸서 사용
  static Future<List<dynamic>> getQuestions() async {
    final res = await http.get(Uri.parse('$url/questions'));

    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      throw Exception('불러오기 실패');
    }
  }

  static Future<Map<String, dynamic>> submitTest(
    String userName,
    Map<int, String> answers,
  ) async {
    List<Map<String, dynamic>> answerList = [];
    answers.forEach((questionId, option) {
      answerList.add({'questionId': questionId, 'selectedOption': option});
    });

    final res = await http.post(
      Uri.parse('$url/submit'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'userName': userName, 'answers': answerList}),
    );

    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      throw Exception('제출 실패');
    }
  }
}
