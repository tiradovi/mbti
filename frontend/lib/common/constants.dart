/*
Flutter / Dart 앱의 상수 정의 파일
MBTI 성격 유형 검사앱에서 사용되는 각종 설정값과 메세지를 중앙에서 관리하기 위한 구조

주요 구성 요소
ApiConstants - API 엔드포인트 주소들
  baseUrl : 백엔드 서버 주소(로컬/ 에뮬레이터/실제 서버 옵션 주석 처리하여 사용)
    실제 회사 : dev_api_constants / stage_api_constants / droid_api_constants
  API 경로들 : 질문 목록, 답변 제출, 결과 조회 등

AppConstants - 앱 기본 설정
  앱 이름과 질문 개수등 앱 전반에서 사용되는 설정

MbtiDimensions - MBTI 4가지 척도
  EI(외향-내향), SN(감각-직관), TF(사고-감정), JP(판단-인식)

ErrorMessages - 사용자에게 표시할 오류 메세지
  네트워크 오류, 서버 오류, 입력 오류 등 다양한 상황의 안내 메세지

 static const vs static final = 언제 값이 결정되는가의 차이
 static const : 컴파일 단계에서 값이 결정, 값이 하드코딩되어있어 모든 인스턴스가 공유(효율적)
 static final : 런타임(실행 시점)에 값이 결정됨, 할당되면 변경 불가, 계산된 값이나 함수 호출 결과도 가능(비효율적) const 권장

 Dart는 컴파일러와 인터프리터 두가지를 모두 지원하는 언어
 fluter 앱에서는 컴파일로 실행을 주로 한다(이유는 속도)
*/

class ApiConstants {
  /*
  안드로이드 에뮬 : http://10.0.2.2:8080/api
  Ios 시뮬레이터 : http://localhost:8080/api
  실제 기기용 : http:192.168.x.x:8080/api
  백엔드 주소 : https://도메인.도메인/api

  Chrome(web)이나 Edge(web)으로 console.log 확인하며 개발하고자 할 경우
  flutter run -d chrome --web-port=개발자가 원하는 포트

  프로젝트 루트에 .flutter 폴더 생성후 chrome_device.json 파일 형태로
  {
  "prot" :51093 과 같은 포트번호 지적ㅇ
  }
  환경변수 파일 사용(.env)를 이용하여 constants 상태관리를 할 수 있다.
   */
  static const String baseUrl = 'http://localhost:8080/api';
  static const String mbtiUrl = '/mbti';
  static const String userUrl = '/users';
  static const String submit = '$mbtiUrl/submit';
  static const String result = '$mbtiUrl/result';
  static const String results = '$mbtiUrl/results';
  static const String types = '$mbtiUrl/types';
  static const String health = '$mbtiUrl/health';
  static const String questions = '$mbtiUrl/questions';
  static const String login = '$userUrl/login';
  static const String signup = '$userUrl/signup';
  static const String name = '$userUrl/name';
}

class AppConstants {
  static const String appName = 'MBTI 성격 유형 검사';
  static const int totalQuestion = 12; // 전체 질문
  static const int questionsPerDimension = 3; // 차원당 질문 수
  /*
1. E/I 차원 질문 3가지
2. S/N 차원 질문 3가지
3. T/F 차원 질문 3가지
4. J/P 차원 질문 3가지
 */
}

class MbtiDimensions {
  static const String ei = 'EI';
  static const String sn = 'SN';
  static const String tf = 'TF';
  static const String jp = 'JP';
}

class ErrorMessages {
  static const String networkError = '네트워크 연결을 확인해주세요.';
  static const String serverError = '서버 오류가 발생했습니다.';
  static const String deleteFailed = '삭제에 실패했습니다.';
  static const String loadFailed = '데이터를 불러오는데 실패했습니다.';
  static const String submitFailed = '제출에 실패했습니다.';
  static const String emptyName = '이름을 입력해주세요.';
  static const String incompleteTest = '모든 질문에 답변해주세요.';
}
