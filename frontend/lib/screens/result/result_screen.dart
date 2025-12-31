import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ResultScreen extends StatelessWidget {
  final String userName;
  final String resultType;
  const ResultScreen({super.key,required this.userName, required this.resultType,});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('검사 결과'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.celebration,size: 100,color: Colors.amber,),
              SizedBox(height: 30),
              Text('검사완료',style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold),),
              SizedBox(height: 40),

              Container(
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(color: Colors.purple,border: Border.all(),borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    Text('${userName}님의 MBTI는'),
                    SizedBox(height: 20),
                   Text('${resultType}!',style: TextStyle(fontSize: 30),),
                    SizedBox(height: 10),
                    Text('입니다.'),
                  ],
                ),
              ),
              SizedBox(height: 60),
              SizedBox(width: 200, child: ElevatedButton(onPressed: ()=>context.go('/'), child: Text('처음으로')),)
            ],
          ),
        ),
      ),
    );
  }
}