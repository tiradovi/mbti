import 'package:flutter/material.dart';
import 'package:frontend/common/constants.dart';
import 'package:frontend/screens/home/home_screen.dart';
import 'package:frontend/screens/test/test_screen.dart';
import 'package:go_router/go_router.dart';


final GoRouter _router = GoRouter(

  initialLocation: '/',
  routes: [
    GoRoute(path: "/", builder: (context, state) => const HomeScreen()),
    GoRoute(path: "/test", builder: (context, state) {
      final userName = state.extra as String; // 잠시 사용할 문자열 이름
      /*
      생성된 객체를 사용할 수는 있으나 매개변수는 존재하지 않은 상태
      단순히 화면만 보여주는 형태
      const TestScreen({super.key});

       */
      return TestScreen(userName:userName);
    }),
  ],
);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}