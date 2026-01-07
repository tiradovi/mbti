import 'package:flutter/material.dart';

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
        SizedBox(child: Text("내 주변 10km 다른 유저의 MBTI 확인하기")),
      ],
    );
  }
}
