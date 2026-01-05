import 'package:flutter/material.dart';
import 'package:frontend/common/constants.dart';
import 'package:frontend/models/result_model.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/screens/history/result_detail_screen.dart';
import 'package:frontend/screens/home/home_screen.dart';
import 'package:frontend/screens/login/login_screen.dart';
import 'package:frontend/screens/result/result_screen.dart';
import 'package:frontend/screens/signup/signup_screen.dart';
import 'package:frontend/screens/test/test_screen.dart';
import 'package:frontend/screens/types/mbti_types_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
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
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
        providers:[
          ChangeNotifierProvider(create:(_) => AuthProvider()),
        ],

        child: MaterialApp.router(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          routerConfig: _router,)


    );
  }
}
