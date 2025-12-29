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
  static const String baseUrl = 'http://localhost:8080/api/mbti';
  static const String submit = '/submit';
  static const String result = '/result';
  static const String results = '/results';
  static const String types = '/types';
  static const String health = '/health';
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
  static const String loadFailed = '데이터를 불러오는데 실패했습니다.';
  static const String submitFailed = '제출에 실패했습니다.';
  static const String emptyName = '이름을 입력해주세요.';
  static const String incompleteTest = '모든 질문에 답변해주세요.';
}
