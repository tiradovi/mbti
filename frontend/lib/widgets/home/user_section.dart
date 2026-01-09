import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserSection extends StatelessWidget {
  final String? userName;

  const UserSection({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          child: Text(
            '$userName 님 환영합니다',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          ),
        ),
        SizedBox(height: 30),
        SizedBox(
          width: 300,
          height: 50,
          child: ElevatedButton(
            onPressed: () => context.go("/map"),
            child: Text("내 위치 확인하기"),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
