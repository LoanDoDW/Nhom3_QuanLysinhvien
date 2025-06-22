// import 'package:flutter/material.dart';

// class DashboardWidget extends StatelessWidget {
//   final Function(int) onNavigate;

//   const DashboardWidget({super.key, required this.onNavigate});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(24.0),
//       child: Column(
//         children: [
//           const SizedBox(height: 40),

//           // 👉 Thay icon bằng ảnh
//           SizedBox(
//             height: 100,
//             child: Image.asset('assets/img/logo.png'), // Đường dẫn logo của bạn
//           ),

//           const SizedBox(height: 10),
//           const Text(
//             "Chào mừng bạn đến với EduHPC",
//             textAlign: TextAlign.center,
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 20),

//           Expanded(
//             child: GridView.count(
//               crossAxisCount: 2,
//               crossAxisSpacing: 16,
//               mainAxisSpacing: 16,
//               childAspectRatio: 1.2,
//               children: [
//                 _buildMenuCard(
//                   icon: Icons.people,
//                   title: "Sinh viên",
//                   onTap: () => onNavigate(3),
//                 ),
//                 _buildMenuCard(
//                   icon: Icons.book,
//                   title: "Môn học",
//                   onTap: () => onNavigate(5),
//                 ),
//                 _buildMenuCard(
//                   icon: Icons.account_tree,
//                   title: "Ngành",
//                   onTap: () => onNavigate(4),
//                 ),
//                 _buildMenuCard(
//                   icon: Icons.grade,
//                   title: "Điểm",
//                   onTap: () => onNavigate(6),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMenuCard({
//     required IconData icon,
//     required String title,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         elevation: 3,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Center(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(icon, size: 40, color: Color(0xFF0D47A1)),
//                 const SizedBox(height: 10),
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'package:flutter/material.dart';

class DashboardWidget extends StatefulWidget {
  final Function(int) onNavigate;

  const DashboardWidget({super.key, required this.onNavigate});

  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;
  Timer? _timer;

  final List<Map<String, String>> newsList = [
    {
      'image': 'assets/img/new4.jpg',
      'title': 'Ngôn ngữ Trung',
      'desc': 'Tiếng Trung phổ biến toàn cầu, mở ra cơ hội học tập ....',
    },
    {
      'image': 'assets/img/new6.jpg',
      'title': 'Ngôn ngữ và văn hóa Hàn Quốc',
      'desc': 'Tiếng Hàn ngày càng được ưa chuộng nhờ làn sóng Hallyu,...',
    },
    {
      'image': 'assets/img/new5.jpg',
      'title': 'Ngôn ngữ Nhật',
      'desc': 'Tiếng Nhật là ngôn ngữ công nghệ và văn hoá....',
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        _currentPage = (_currentPage + 1) % newsList.length;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
          SizedBox(height: 80, child: Image.asset('assets/img/logo.png')),
          const SizedBox(height: 10),
          const Text(
            "Chào mừng bạn đến với EduHPC",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // DANH MỤC
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Danh mục',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMenuItem(Icons.people, "Sinh viên", () => widget.onNavigate(3)),
              _buildMenuItem(Icons.book, "Môn học", () => widget.onNavigate(5)),
              _buildMenuItem(Icons.account_tree, "Ngành", () => widget.onNavigate(4)),
              _buildMenuItem(Icons.grade, "Điểm", () => widget.onNavigate(6)),
            ],
          ),

          const SizedBox(height: 32),

          // TIN TỨC
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Nổi bật',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),

          SizedBox(
            height: 250,
            child: PageView.builder(
              controller: _pageController,
              itemCount: newsList.length,
              itemBuilder: (context, index) {
                final news = newsList[index];
                return _buildNewsCard(news['image']!, news['title']!, news['desc']!);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 32, color: Color(0xFF0D47A1)),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNewsCard(String image, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        color: Colors.white, // hoặc Colors.grey[200] cho nền nhẹ
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              image,
              height: 155,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(description),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

