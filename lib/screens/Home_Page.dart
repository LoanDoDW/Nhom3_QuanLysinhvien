// import 'package:flutter/material.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});
  
//   @override
//   Widget build(BuildContext context) {
//     return const DashboardWidget();
//   }
// }

// class DashboardWidget extends StatelessWidget {
//   const DashboardWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(24),
//       child: Column(
//         children: [
//           const SizedBox(height: 40),
//           const Icon(Icons.school, size: 80, color: Colors.blue),
//           const SizedBox(height: 10),
//           const Text(
//             "Chào mừng bạn đến với EduHPC",
//             textAlign: TextAlign.center,
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 20),
//           Expanded(
//             child: GridView.count(
//               crossAxisCount: 3,
//               crossAxisSpacing: 12,
//               mainAxisSpacing: 12,
//               childAspectRatio: 1,
//               physics: const NeverScrollableScrollPhysics(),
//               children: [
//                 _buildMenuCard(
//                   icon: Icons.people,
//                   title: "Sinh viên",
//                   onTap: () => Navigator.pushNamed(context, '/students'),
//                 ),
//                 _buildMenuCard(
//                   icon: Icons.class_,
//                   title: "Lớp học",
//                   onTap: () => Navigator.pushNamed(context, '/classes'),
//                 ),
//                 _buildMenuCard(
//                   icon: Icons.book,
//                   title: "Môn học",
//                   onTap: () => Navigator.pushNamed(context, '/subjects'),
//                 ),
//                 _buildMenuCard(
//                   icon: Icons.account_tree,
//                   title: "Ngành",
//                   onTap: () => Navigator.pushNamed(context, '/majors'),
//                 ),
//                 _buildMenuCard(
//                   icon: Icons.grade,
//                   title: "Điểm",
//                   onTap: () => Navigator.pushNamed(context, '/scores'),
//                 ),
//                 _buildMenuCard(
//                   icon: Icons.info_outline,
//                   title: "Thông tin",
//                   onTap: () => Navigator.pushNamed(context, '/info'),
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
//         elevation: 2,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         child: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(icon, size: 30, color: Colors.blue),
//               const SizedBox(height: 6),
//               Text(
//                 title,
//                 style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
