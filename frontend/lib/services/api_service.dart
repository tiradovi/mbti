import 'dart:convert';

import 'package:frontend/common/constants.dart';
import 'package:frontend/models/answer_model.dart';
import 'package:frontend/models/question_model.dart';
import 'package:frontend/models/result_model.dart';
import 'package:frontend/models/test_request_model.dart';
import 'package:dio/dio.dart';

import '../models/mbti_type_model.dart';
import '../models/user_model.dart';

class ApiService {
  static const String url = ApiConstants.baseUrl;

  /*
  Dio의 장점
  1. 자동으로 JSON 인코딩/ 디코딩 처리
  2. Interceptor를 통한 로깅, 인증 토큰 추가 가능
  3. 백엔드 통신 타임 아웃 설정이 더 간편
  4. FormData 파일 업로드 지원이 더 편리
  5. 에러 처리가 더 구조화
  6. queryParameters를 쉽게 추가 가능

  http와의 차이점
  http: json.encode()/json.decode() 필요
  dio: 자동으로 처리, response.data로 바로 접근

  http: Uri.parse() 필요
  dio : baseUrl 설정 후 상대 경로만 작성

  http : 에러처리가 statusCode 기반
  dio : DioException으로 다양한 에러타입 처리 가능
   */
  // Dio 인스턴스 생성
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: url,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );


  static Future<User> login(String userName) async {
    final res = await _dio.post(
        ApiConstants.login,
        data: {'userName': userName}
    );

    if (res.statusCode == 200) {
      return User.fromJson(res.data);
    } else {
      throw Exception(ErrorMessages.submitFailed);
    }
  }

  // 회원가입
  static Future<User> signup(String userName) async {
    final res = await _dio.post(
      ApiConstants.signup,

      data: {'userName': userName},
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      return User.fromJson(res.data);
    } else {
      throw Exception(ErrorMessages.submitFailed);
    }
  }

  static Future<List<Question>> getQuestions() async {
    final res = await _dio.get('/questions');

    if (res.statusCode == 200) {
      List<dynamic> jsonList = res.data;
      return jsonList.map((json) => Question.fromJson(json)).toList();
    } else {
      throw Exception(ErrorMessages.loadFailed);
    }
  }

  static Future<Result> submitTest(String userName, Map<int, String> answers,) async {
    List<TestAnswer> answerList = answers.entries.map((en) {
      return TestAnswer(questionId: en.key, selectedOption: en.value);
    }).toList();

    TestRequest request = TestRequest(userName: userName, answers: answerList);

    final res = await _dio.post(
      ApiConstants.submit,
      data: request.toJson(),
    );
    if (res.statusCode == 200) {
      return Result.fromJson(res.data);
    } else {
      throw Exception(ErrorMessages.submitFailed);
    }
  }

  static Future<List<Result>> getResultsByUserName(String userName) async {
    final res = await _dio.get(
      ApiConstants.results,
      queryParameters: {'userName': userName},
    );

    if (res.statusCode == 200) {
      List<dynamic> jsonList = res.data;
      return jsonList.map((json) => Result.fromJson(json)).toList();
    } else {
      // constants 에서 지정한 에러 타입으로 교체
      throw Exception(ErrorMessages.loadFailed);
    }
  }

  static Future<List<MbtiType>> getAllMbtiTypes() async {
    final res = await _dio.get(ApiConstants.types);

    if (res.statusCode == 200) {
      List<dynamic> jsonList = res.data;
      return jsonList.map((json) => MbtiType.fromJson(json)).toList();
    } else {
      throw Exception(ErrorMessages.loadFailed);
    }
  }

  static Future<MbtiType> getMbtiTypeByCode(String typeCode) async {
    final res = await _dio.get('${ApiConstants.types}$typeCode');

    if (res.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(res.data);
      return MbtiType.fromJson(jsonData);
    } else {
      throw Exception(ErrorMessages.loadFailed);
    }
  }


  static Future<Result> getResultById(int id) async {
    final res = await _dio.get('${ApiConstants.result}/$id');

    if (res.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(res.data);
      return Result.fromJson(jsonData);
    } else {
      throw Exception(ErrorMessages.loadFailed);
    }
  }

  static Future<void> deleteResult(int id) async {
    final res = await _dio.delete('${ApiConstants.result}/$id');

    if (res.statusCode != 200) {
      throw Exception("삭제에 실패했습니다.");
    }
  }

  static Future<Result> healthCheck(int id) async {
    final res = await _dio.get(ApiConstants.health);

    if (res.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(res.data);
      return Result.fromJson(jsonData);
    } else {
      throw Exception(ErrorMessages.serverError);
    }
  }
}
/*class HTTPApiService {
  static const String url = ApiConstants.baseUrl;

  // ================ 사용자 관련 API ==================
  // 로그인
  static Future<User> login(String userName) async {
    final res = await http.post(
      Uri.parse('$url${ApiConstants.login}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'userName': userName}),
    );

    if (res.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(res.body);
      return User.fromJson(jsonData);
    } else {
      throw Exception(ErrorMessages.submitFailed);
    }
  }

  // 회원가입
  static Future<User> signup(String userName) async {
    final res = await http.post(
      Uri.parse('$url${ApiConstants.signup}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'userName': userName}),
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      Map<String, dynamic> jsonData = json.decode(res.body);
      return User.fromJson(jsonData);
    } else {
      throw Exception(ErrorMessages.submitFailed);
    }
  }

  static Future<User?> getUserByUserName(String userName) async {
    final res = await http.get(Uri.parse('$url${ApiConstants.name}/$userName'));

    if (res.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(res.body);
      return User.fromJson(jsonData);
    } else {
      throw Exception(ErrorMessages.loadFailed);
    }
  }

  static Future<List<User>> getAllUsers() async {
    final res = await http.get(Uri.parse('$url${ApiConstants.userUrl}'));

    if (res.statusCode == 200) {
      List<dynamic> jsonList = json.decode(res.body);

      return jsonList.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception(ErrorMessages.loadFailed);
    }
  }

  // ================ 질문 관련 API ==================
  static Future<List<Question>> getQuestions() async {
    final res = await http.get(Uri.parse('$url${ApiConstants.questions}'));

    if (res.statusCode == 200) {
      List<dynamic> jsonList = json.decode(res.body);

      return jsonList.map((json) => Question.fromJson(json)).toList();
    } else {
      throw Exception(ErrorMessages.loadFailed);
    }
  }


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

  static Future<Result> submitTest(
    String userName,
    Map<int, String> answers,
  ) async {
    List<TestAnswer> answerList = answers.entries.map((en) {
      return TestAnswer(questionId: en.key, selectedOption: en.value);
    }).toList();

    TestRequest request = TestRequest(userName: userName, answers: answerList);

    final res = await http.post(
      Uri.parse('$url${ApiConstants.submit}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(request.toJson()),
    );

    if (res.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(res.body);
      return Result.fromJson(jsonData);
    } else {
      throw Exception(ErrorMessages.submitFailed);
    }
  }

  // 모든 MBTI 유형 조회
  static Future<List<MbtiType>> getAllMbtiTypes() async {
    final res = await http.get(Uri.parse('$url${ApiConstants.types}'));

    if (res.statusCode == 200) {
      List<dynamic> jsonList = json.decode(res.body);
      return jsonList.map((json) => MbtiType.fromJson(json)).toList();
    } else {
      throw Exception(ErrorMessages.loadFailed);
    }
  }

  // 특정 MBTI 유형 조회
  static Future<MbtiType> getMbtiTypeByCode(String typeCode) async {
    final res = await http.get(
      Uri.parse('$url${ApiConstants.types}/$typeCode'),
    );

    if (res.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(res.body);
      return MbtiType.fromJson(jsonData);
    } else {
      throw Exception(ErrorMessages.loadFailed);
    }
  }


  static Future<List<Result>> getResultsByUserName(String userName) async {
    final res = await http.get(
      Uri.parse('$url${ApiConstants.results}?userName=$userName'),
    );

    if (res.statusCode == 200) {
      List<dynamic> jsonList = json.decode(res.body);
      return jsonList.map((json) => Result.fromJson(json)).toList();
    } else {
      throw Exception(ErrorMessages.loadFailed);
    }
  }

  // ID로 결과 조회
  static Future<Result> getResultById(int id) async {
    final res = await http.get(Uri.parse('$url${ApiConstants.result}/$id'));

    if (res.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(res.body);
      return Result.fromJson(jsonData);
    } else {
      throw Exception(ErrorMessages.loadFailed);
    }
  }

  // 결과 삭제 (문제가 생겼을 때만 처리)
  static Future<void> deleteResult(int id) async {
    final res = await http.delete(Uri.parse('$url${ApiConstants.result}/$id'));

    if (res.statusCode != 200) {
      throw Exception(ErrorMessages.deleteFailed);
    }
  }

  // 상태 확인
  static Future<String> healthCheck() async {
    final res = await http.get(Uri.parse('$url${ApiConstants.health}'));

    if (res.statusCode == 200) {
      return res.body;
    } else {
      throw Exception(ErrorMessages.serverError);
    }
  }
}*/

/*
class ModelApiService {
  // models에 작성한 자료형 변수이름 활용하여 데이터 타입 지정
  static const String url = 'http://localhost:8080/api/mbti';

  // 백엔드 컨트롤러에서 질문 가져오기
  // 보통 백엔드나 외부 api 데이터를 가져올 때 자료형으로 Future 특정 자료형을 감싸서 사용
  static Future<List<Question>> getQuestions() async {
    final res = await http.get(Uri.parse('$url/questions'));

    res.body = 백엔드에서 가져온 JSON 문자열 -> 한 줄
    json.decode = 한줄을 Dart 객체로 변환


    if (res.statusCode == 200) {
      List<dynamic> jsonList = json.decode(res.body);

      return jsonList.map((json) => Question.fromJson(json)).toList();
    } else {
      throw Exception('불러오기 실패');
    }
  }


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

  static Future<Result> submitTest(String userName, Map<int, String> answers,) async {
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

      dynamic 사용 이유 : 컴파일단계에서는 타입 상관X, 런타임에서 타입 상관하여 에러발생 가능
      key: 'id','userName',.. 전부 String
      value: 1,'김씨'         전부 다를 수 있음

      Object 사용이 불가한 이유: Dart에서 컴파일 단계에서 연산 불가
      중간에 null인 경우 Object는 처리 불가
      단 java의 경우 null 가능

      return Result.fromJson(jsonData);
    } else {
      throw Exception('제출 실패');
    }
  }

// 모든 MBTI 유형 조회
  static Future<List<MbtiType>> getAllMbtiTypes() async {
    final res = await http.get(Uri.parse('$url/types'));

    if(res.statusCode == 200) {
      List<dynamic> jsonList = json.decode(res.body);
      return jsonList.map((json) => MbtiType.fromJson(json)).toList();
    } else {
      throw Exception('MBTI 유형 불러오기 실패');
    }
  }

// 특정 MBTI 유형 조회
  static Future<MbtiType> getMbtiTypeByCode(String typeCode) async {
    final res = await http.get(Uri.parse('$url/types/$typeCode'));

    if(res.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(res.body);

      return MbtiType.fromJson(jsonData);
    } else {
      throw Exception('MBTI 유형 조회 실패');
    }
  }



  static Future<List<Result>> getResultsByUserName(String userName) async {
    final res = await http.get(Uri.parse('$url/results?userName=$userName'));

    if (res.statusCode == 200) {
      List<dynamic> jsonList = json.decode(res.body);
      return jsonList.map((json) => Result.fromJson(json)).toList();
    } else {
      throw Exception('불러오기 실패');
    }
  }
}*/
/*

class DynamicApiService {

  단기적으로 값 변경 불가 = final
  장기적으로 전체 공유하는 상수 = const

  const = 어플 전체적으로 사용
  final = 특정 기능이나 특정 화면에서만 부분적으로 사용되는 상수 명칭


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
*/
