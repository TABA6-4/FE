import 'package:flutter/material.dart';
import 'package:focus/screens/info5.dart'; // 다음 페이지
import '../widgets/header.dart'; // 헤더 가져오기

class Info4Screen extends StatelessWidget {
  const Info4Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Info5Screen()),
        );
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Header(),
          toolbarHeight: 118,
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "실시간 알림을 통해\n집중도 향상을\n도와줍니다.",
                style: TextStyle(
                  fontSize: 40,
                  fontFamily: "Noto Sans",
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: Image.asset(
                  'assets/images/5.png',
                  width: 700,
                  height: 700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
