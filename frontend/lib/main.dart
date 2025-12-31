import 'package:flutter/material.dart';
import 'package:frontend/common/constants.dart';
import 'package:frontend/screens/history/result_detail_screen.dart';
import 'package:frontend/screens/home/home_screen.dart';
import 'package:frontend/screens/result/result_screen.dart';
import 'package:frontend/screens/test/test_screen.dart';
import 'package:frontend/screens/types/mbti_types_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: "/", builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: "/test",
      builder: (context, state) {
        final userName = state.extra as String;
        return TestScreen(userName: userName);
      },
    ),
    GoRoute(
      path: "/result",
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return ResultScreen(
          userName: data['userName']!,
          resultType: data['resultType']!,
        );
      },
    ),
    GoRoute(
      path: "/history",
      builder: (context, state) {
        final userName = state.extra as String;
        return ResultDetailScreen(userName: userName);
      },
    ),
    GoRoute(
      path: "/types",
      builder: (context, state) => const MbtiTypesScreen(),
    ),
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
