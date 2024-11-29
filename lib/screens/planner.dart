import 'package:flutter/material.dart';
import 'package:focus/widgets/header.dart'; // Header 추가
import 'package:table_calendar/table_calendar.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({Key? key}) : super(key: key);

  @override
  _PlannerScreenState createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // 날짜별로 할 일 목록 관리
  Map<DateTime, List<Map<String, dynamic>>> _tasksByDate = {};

  String? _selectedSubject; // 드롭다운에서 선택된 과목
  final TextEditingController _taskController = TextEditingController();

  final List<String> _subjects = ['수학', '영어', '과학', '국어']; // 예시 과목 리스트

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  // 선택된 날짜의 할 일 목록 가져오기
  List<Map<String, dynamic>> get _tasksForSelectedDate {
    if (_selectedDay != null) {
      final selectedDate = DateTime(
        _selectedDay!.year,
        _selectedDay!.month,
        _selectedDay!.day,
      );
      return _tasksByDate[selectedDate] ?? [];
    }
    return [];
  }

  void _addTask() {
    if (_selectedSubject != null && _taskController.text.isNotEmpty) {
      setState(() {
        if (_selectedDay != null) {
          final selectedDate = DateTime(
            _selectedDay!.year,
            _selectedDay!.month,
            _selectedDay!.day,
          );

          if (_tasksByDate[selectedDate] == null) {
            _tasksByDate[selectedDate] = [];
          }

          _tasksByDate[selectedDate]?.add({
            "subject": _selectedSubject,
            "task": _taskController.text,
            "completed": false,
          });

          _taskController.clear();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "플래너",
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Hero",
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 캘린더
                  Expanded(
                    flex: 2,
                    child: TableCalendar(
                      firstDay: DateTime.utc(2021, 10, 16),
                      lastDay: DateTime.utc(2030, 3, 14),
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) =>
                          isSameDay(_selectedDay, day),
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      },
                      calendarStyle: const CalendarStyle(
                        todayDecoration: BoxDecoration(
                          color: Color(0xFF8AD2E6),
                          shape: BoxShape.circle,
                        ),
                        selectedDecoration: BoxDecoration(
                          color: Color(0xFF4F378A),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // 드롭다운과 할 일 입력
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        // 드롭다운
                        DropdownButtonFormField<String>(
                          value: _selectedSubject,
                          hint: const Text("과목을 선택하세요"),
                          items: _subjects.map((subject) {
                            return DropdownMenuItem<String>(
                              value: subject,
                              child: Text(subject),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedSubject = value;
                            });
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "과목 선택",
                          ),
                        ),
                        const SizedBox(height: 8),
                        // 할 일 입력 필드
                        TextField(
                          controller: _taskController,
                          decoration: const InputDecoration(
                            labelText: "할 일 입력",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // 추가 버튼
                        ElevatedButton(
                          onPressed: _addTask,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8AD2E6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "추가",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // 할 일 목록
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFB6F9FF).withOpacity(0.24),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _tasksForSelectedDate.length,
                            itemBuilder: (context, index) {
                              var task = _tasksForSelectedDate[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 4.0,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF8AD2E6),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          task["subject"][0],
                                          style: const TextStyle(
                                            color: Color(0xFF4F378A),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            task["subject"],
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            task["task"],
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Checkbox(
                                      value: task["completed"],
                                      onChanged: (value) {
                                        setState(() {
                                          task["completed"] = value ?? false;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
