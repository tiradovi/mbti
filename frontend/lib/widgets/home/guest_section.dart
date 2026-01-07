import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GuestSection extends StatelessWidget {
  final TextEditingController nameController;
  final String? errorText;
  final VoidCallback onValidate;

  const GuestSection({super.key,required this.nameController,required this.errorText,required this.onValidate});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 300,
          child: TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: '이름',
              hintText: '이름을 입력하세요',
              border: OutlineInputBorder(),
              errorText: errorText,
            ),
            onChanged: (value) {
              onValidate();
            },
          ),
        ),
        SizedBox(height: 20),
        SizedBox(
          width: 300,
          height: 50,
          child: ElevatedButton(
            onPressed: () => context.go("/login"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
            ),
            child: Text('로그인하기', style: TextStyle(fontSize: 20)),
          ),
        ),
        SizedBox(height: 10),
        SizedBox(
          width: 300,
          height: 50,
          child: ElevatedButton(
            onPressed: () => context.go("/signup"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
            ),
            child: Text('회원가입하기', style: TextStyle(fontSize: 20)),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}