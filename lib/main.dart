
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:focus/screens/errorScreen.dart';
import 'package:focus/screens/login.dart';
import 'package:focus/screens/register.dart';
import 'package:focus/screens/info1.dart';
import 'package:focus/screens/info2.dart';
import 'package:focus/screens/info3.dart';
import 'package:focus/screens/info4.dart';
import 'package:focus/screens/info5.dart';
import 'package:focus/screens/planner.dart';
import 'package:focus/screens/waitingRoom.dart';
import 'package:focus/screens/waitingRoom2.dart';
import 'package:focus/screens/concentrateScreen.dart';
import 'package:focus/screens/dailyReport.dart';
import 'package:focus/widgets/auth_guard.dart';
import 'package:focus/widgets/header.dart';
import 'package:focus/screens/myPage.dart';
import 'package:focus/widgets/websocket_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // 기본 경로
      routes: {
        '/': (context) => AuthGuard(child: const MainScreen()), // 메인 화면 보호
        '/login': (context) => const LoginScreen(), // 로그인 화면
        '/register': (context) => RegisterScreen(), // 회원가입 화면
        '/register/info1': (context) => const Info1Screen(),
        '/register/info2': (context) => const Info2Screen(),
        '/register/info3': (context) => const Info3Screen(),
        '/register/info4': (context) => const Info4Screen(),
        '/register/info5': (context) => const Info5Screen(),
        '/planner': (context) => AuthGuard(
          child: const PlannerScreen(userId: 1, date: 2024 - 12 - 05),
        ), // 플래너 화면 보호
        '/waitingRoom': (context) => const WaitingRoom(), // 대기실 화면 보호
        '/waitingRoom2': (context) => const WaitingRoom2(), // 대기실 2 화면 보호
        '/concentrateScreen': (context) =>
        const ConcentrateScreen(), // 집중 화면 보호
        '/dailyReport': (context) => AuthGuard(
          child: DailyReportScreen(userId: 1, date: "2024-12-05"),
        ), // 일일 리포트 화면 보호
        '/myPage': (context) => AuthGuard(child: const MyPageScreen()), // 마이페이지 보호
      },
      onUnknownRoute: (settings) {
        // 잘못된 경로 처리
        return MaterialPageRoute(
          builder: (context) => const ErrorScreen(),
        );
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  final WebSocketManager _webSocketManager = WebSocketManager(); // WebSocket 매니저 초기화


  @override
  void initState() {
    super.initState();
    _webSocketManager.connect(); // WebSocket 연결
  }

  // ignore: unused_field
  int _currentIndex = 0;

  final List<String> _images = [
    'images/download.png',
    'images/download(1).png',
    'images/download(2).png',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _webSocketManager.disconnect(); // WebSocket 종료
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Header(
                onPlannerTap: () {
                  Navigator.pushNamed(context, '/planner');
                },
                onLoginTap: () {
                  Navigator.pushNamed(context, '/login');
                },
                onRegisterTap: () {
                  Navigator.pushNamed(context, '/register');
                },
                onMyReportTap: () {
                  Navigator.pushNamed(context, '/dailyReport'); // 마이리포트로 연결
                },
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 511,
                    color: Colors.white,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _images.length,
                      itemBuilder: (context, index) {
                        return Image.asset(
                          _images[index],
                          width: double.infinity,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                  _TopBlock(
                    onMeasureTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WaitingRoom(), // WaitingRoom으로 이동
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 45),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "About FOCUS",
                        style: TextStyle(
                          fontSize: 48,
                          height: 1.25,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Noto Sans",
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "2000년대 이후로 문제가 되고 있는 청년들의 집중력..! ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 48,
                          fontFamily: "Noto Sans",
                          fontWeight: FontWeight.w400,
                          height: 1.2,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Image.asset(
                          'images/3.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 45),
              _buildImageTextSection(
                imagePath: 'images/1.png',
                title: "일일 리포트",
                description: "매일 집중도를 측정하고\n이를 일일 리포트로\n기록해줍니다.",
                isImageLeft: true,
              ),
              const SizedBox(height: 45),
              _buildImageTextSection(
                imagePath: 'images/4.png',
                title: "주간 집중도 현황",
                description: "주간 집중도를\n그래프로 보여주고\n맞춤형 솔루션을 제공해줍니다.",
                isImageLeft: false,
              ),
              const SizedBox(height: 45),
              _buildImageTextSection(
                imagePath: 'images/5.png',
                title: "플래너",
                description: "플래너 기능을 통해\n오늘 공부할 양을\n기록합니다.",
                isImageLeft: true,
              ),
              const SizedBox(height: 45),
              _buildImageTextSection(
                imagePath: 'images/2.png',
                title: "측정 화면",
                description: "스스로의 집중도를 측정할 수 있습니다.\n실시간 알림을 통해\n 집중도 향상을 도와줍니다.",
                isImageLeft: false,
              ),
              const SizedBox(height: 45),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageTextSection({
    required String imagePath,
    required String title,
    required String description,
    required bool isImageLeft,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: isImageLeft
            ? [
          Image.asset(
            imagePath,
            width: 300,
            height: 300,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 74),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Noto Sans",
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  description,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Noto Sans",
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ]
            : [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Noto Sans",
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  description,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Noto Sans",
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 74),
          Image.asset(
            imagePath,
            width: 300,
            height: 300,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}

class _TopBlock extends StatelessWidget {
  final VoidCallback onMeasureTap;

  const _TopBlock({required this.onMeasureTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 616,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      child: Column(
        children: [
          const Text(
            "(웹 사이트 회원 이름)님의 오늘을 응원합니다",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w600,
              fontFamily: "Inter",
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 29),
          const Text(
            "더 효율적인 하루를 만들어드립니다.",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              fontFamily: "Inter",
              color: Color(0xFFA39797),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 29),
          ElevatedButton(
            onPressed: onMeasureTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4C9BB8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              padding: const EdgeInsets.symmetric(
                  vertical: 16.0, horizontal: 32.0),
            ),
            child: const Text(
              "측정 시작하기",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w600,
                fontFamily: "Inter",
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}