import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/common/constants.dart';
import 'package:frontend/common/env_config.dart';
import 'package:frontend/models/result_model.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/screens/history/result_detail_screen.dart';
import 'package:frontend/screens/home/home_screen.dart';
import 'package:frontend/screens/login/login_screen.dart';
import 'package:frontend/screens/map/map_screen.dart';
import 'package:frontend/screens/result/result_screen.dart';
import 'package:frontend/screens/signup/signup_screen.dart';
import 'package:frontend/screens/test/test_screen.dart';
import 'package:frontend/screens/types/mbti_types_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env.development");
  /*
  자료형? :
  공간 내부가 비어있을 때 undefined 호출하여 에러를 발생시키는게 아닌 null처리
  ex) String? 변경가능한 데이터를 보관할 수 있는공간 명칭;

  공간명칭!:
  NULL 이 아님을 표기, 개발자가 null이 아니라고 선언
  위험한 연산자이지만 현재는 사용할 것

  ?? null 이면 기본값      name ?? '기본프로필이미지.png'
  ?. null 이면 null 반환   name?.length 이름이 비어있으면 null
   */

  // 개발 환경 확인을 위해 정보 출력
  if (EnvConfig.isDevelopment) EnvConfig.printEnvInfo();
  AuthRepository.initialize(appKey: EnvConfig.kakaoMapKey);
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/signup', builder: (context, state) => const SignupScreen()),
    GoRoute(
      path: '/test',
      builder: (context, state) {
        final userName = state.extra as String;
        return TestScreen(userName: userName);
      },
    ),
    GoRoute(
      path: '/result',
      builder: (context, state) {
        final result = state.extra as Result;
        return ResultScreen(result: result);
      },
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) {
        final userName = state.extra as String;
        return ResultDetailScreen(userName: userName);
      },
    ),
    GoRoute(
      path: '/types',
      builder: (context, state) => const MbtiTypesScreen(),
    ),
    GoRoute(path: '/map', builder: (context, state) => MapScreen()),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],

      child: MaterialApp.router(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        routerConfig: _router,
      ),
    );
  }
}
