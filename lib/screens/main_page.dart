import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'setting_page.dart';
import 'student_page.dart';
import 'major_page.dart';
import 'subject_page.dart';
import 'dashboard_widget.dart';
import 'score_page.dart';

class MainPage extends StatefulWidget {
  final Map<String, dynamic> user;

  const MainPage({super.key, required this.user});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  void _setPageIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      DashboardWidget(onNavigate: _setPageIndex),  // 0
      ProfilePage(user: widget.user),              // 1
     SettingPage(userId: widget.user['id']),
                   // 2
      StudentPage(onBack: () => _setPageIndex(0)), // 3
      MajorPage(onBack: () => _setPageIndex(0)),   // 4 (chuyển lên vì đã xoá class)
      SubjectPage(onBack: () => _setPageIndex(0)), // 5
      ScorePage(onBack:() =>_setPageIndex(0)),//6
    ];
  }

  int _bottomNavIndex() => _selectedIndex <= 2 ? _selectedIndex : 0;

  void _onItemTapped(int index) => _setPageIndex(index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex(),
        onTap: _onItemTapped,
        selectedItemColor: Color(0xFF0D47A1),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Trang chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Tài khoản'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Cài đặt'),
        ],
      ),
    );
  }
}
