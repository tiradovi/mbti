import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class MapScreen extends StatefulWidget {
   const MapScreen({super.key});

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  // 변수나 함수 선언 공간
  // 자료형으로 KakaoMapController 자료형을 사용할 것이며
  // 변수명칭 : _mapController 사용할 것이다.
  // 이 변수 내부에 데이터가 존재하지 않으면 ? = null 값으로 허용하겠다.
  // 에러 발생 방지
  KakaoMapController? _mapController;
  // 위도 경도로 나의 위치 private 변수로 가지고 있기.
  // 자료형으로 LatLng 객체를 사용할 것이며, 내부 데이터가 없으면 null 값 사용
  LatLng? _currentPosition;


  @override
  void initState() {
    super.initState();
    _determinePosition(); // 우리가 만들 기능 화면 시작 시 위치 가져오기 자동로드
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled; // 기기의 GPS가 켜져있는지 확인기능을 담기위해 준비한 변수 공간 true false
    LocationPermission permission; // 우리 어플이 위치 정보를 봐도되는 권한이 있는지 저장

    //  Geolocator.isLocationServiceEnabled 에서 기기 켜져있는지 에 대한 유무를 저장
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if(!serviceEnabled) return; // GPS 가 꺼져있으므로 나의 위치 가져오기 기능을 더이상 진행불가하여 후퇴

    // 허용됨, 거부됨, 이번만 허용, 어플이 실행중일 때만 허용 등
    permission = await Geolocator.checkPermission(); //현재 우리 어플이 위치 권한을 가지고 있는지 상태 확인
    // 만약 권한이 거부 상태라면    denied = 거부
    if(permission == LocationPermission.denied) {
      // requestPermission = 요청권한  사용자에게 위치권한을 허용하시겠습니까? 시스템 팝업 띄우기 기능
      permission = await Geolocator.requestPermission();
      // 팝업창에서 사용자가 거부를 눌렀다면, 좌표 정보를 읽어올 수 없으므로 함수 종료
      if(permission == LocationPermission.denied) return;
    }

    // GPS 접근 가능한 권한이 존재한다면 아래 코드 실행
    // 실제 위도와 경도 데이터를 가져옴 가져온 위치를 position 이라는 변수 공간 내부에 저장
    // position = { "latitude" : 39.3242342, "longitude" : 34.2342424 ,............ } 와 같은 데이터들이 내부에 저장
    // 위치를 5초안에 가져오지 못하면 에러를 내도록 설정
    // try {} catch
    try {
      Position position = await Geolocator.getCurrentPosition(
          locationSettings : LocationSettings(
              accuracy: LocationAccuracy.low, // 정확도 낮게 설정
              timeLimit: Duration(seconds: 5) // 5초 제한
          )

      );
      print("position : $position");

      setState(() {
        // 위도 경도 객체로 변환해 저장
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print("위치를 가져오지 못했습니다. $e");
      // 1번 방법 만약에 위치를 가져오지 못하면 이전 화면으로 되돌리거나
      // 2번 방법 또는 회사 위치를 임의로 지정하여 띄워주기
      setState(() {
        _currentPosition = LatLng(37.402056, 127.108212);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("🗺️ MapScreen build - _currentPosition: $_currentPosition");

    return Scaffold(
      appBar: AppBar(title: Text("내 위치 확인하기")),
      body: _currentPosition == null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("위치 정보를 가져오는 중..."),
          ],
        ),
      )
          : KakaoMap(
        onMapCreated: (controller) {
          print("✅ KakaoMap 생성 완료");
          _mapController = controller;
        },
        center: _currentPosition,
        markers: [
          Marker(
            markerId: 'my_location',
            latLng: _currentPosition!,
          )
        ],
      ),
    );
  }
}