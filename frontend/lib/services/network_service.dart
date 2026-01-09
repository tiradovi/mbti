import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:frontend/common/env_config.dart';

class NetworkService {
  /*
  1. 클라이언트가 회원가입 - 게시물 작성시 게시물이 계속 업로드 중 상태인 경우
  -> 어플의 문제라고 오해 가능, 따라서 데이터 문제 여부 전달

  2. 은행 보안 관련 어플은 인증 절차와 같은 사용기간에는 wi-fi 사용 못하게 해야할 경우 있음
  이럴 때 wifi로 접속한 것이 아니라 모바일 데이터로만 접속을 해야지만 ok

  3. 어플 다운 / 대용량 다운 / 동영상 재생 유무 -> 스마트폰 기기나 어플에서
  wifi가 연결되어야지만 다운이 되거나 동영상 자동 재생 처리할 수 있게 설정
  wifi 모바일 데이터 관계없이 실행하겠다와 같은 서비스 설정 가능

   */

  // 싱글톤으로 private instance 변수 생성
  // static 클래스 레벨 변수 (모든 곳에서 공유)
  // final vs const
  // const : 메모리 관리하며 상수 사용 주기적으로 호출해야할 때 사용
  // final : 1회, 일시적 호출시 사용

  // 만약 외부에서 _instance 내부에 존재하는 데이터에 접근하려는 경우
  // 기존에 사용했던 방법처럼 NetworkService._instance NetworkService에 존재하는 변수이름
  // 과 같이 직접 접근 불가
  static final NetworkService _instance = NetworkService._internal();

  // service라는 객체를 생성하여 NetworkService()를 복제하여 사용
  // factory = 항상 새 인스턴스를 만들지 않아도 되는 생성자
  // 기존 인스턴스를 반환하거나 조건에 따른 인스턴스 반환 가능
  // return을 사용하거나 => 사용
  factory NetworkService() => _instance;

  NetworkService._internal();

  // connectivity_plus 제공하는 클래스
  // wifi 모바일데이터 이더넷 등 네트워크 연결 타입을 감지하는 기능
  final Connectivity _connectivity = Connectivity();
  final Dio _dio = Dio();

  /* 현재 연결 타입 가져오기*/
  // _connectivity 내부에서만 사용가능한 변수명칭
  // 외부 dart파일은 접근 불가
  Future<List<ConnectivityResult>> getConnectionType() async {
    return await _connectivity.checkConnectivity();
  }

  /* wifi 연결 여부 */
  Future<bool> isWifiConnected() async {
    final results = await getConnectionType();
    return results.contains(ConnectivityResult.wifi);
  }

  /* 모바일 데이터 연결 여부 */
  Future<bool> isMobileConnected() async {
    final results = await getConnectionType();
    return results.contains(ConnectivityResult.mobile);
  }

  /* 네트워크 연결 여부(Wifi 또는 Mobile) */
  Future<bool> isConnected() async {
    final results = await getConnectionType();
    return results.contains(ConnectivityResult.wifi) ||
        results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.ethernet);
  }

  /* 실제 인터넷 연결 여부 체크 (ping 테스트)*/
  Future<bool> hasInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /* 백엔드 서버 연결 체크 (Health Check) */
  Future<bool> isServerConnected() async{
    try{
      final res = await _dio.get(
        '${EnvConfig.apiBaseUrl}/health',
        options: Options(
          sendTimeout: const Duration(seconds: 3),
          receiveTimeout: const Duration(seconds: 3)
        )
      );
      return res.statusCode==200;
    }catch(e){
      print('서버 연결 실패: $e');
      return false;
    }
  }

  /* 네트워크 변경 감지 스트림 */
  Future<String> checkStatus() async{
    // 네트워크 연결 체크
    if(!await isConnected()){
      return '네트워크에 연결되어 있지 않습니다.';
    }

    // 인터넷 연결체크
    if(await hasInternet()){
      return '인터넷에 연결되어 있지 않습니다.';
    }

    // 서버 연결 체크
    if(!await isServerConnected()){
      return '서버에 연결되어 있지 않습니다.';
    }

    return "모든 연결이 정상입니다.";
  }


}
