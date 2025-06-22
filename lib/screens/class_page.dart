// // import 'package:flutter/material.dart';
// // import '../services/class_service.dart';

// // class ClassPage extends StatefulWidget {
// //   const ClassPage({super.key});

// //   @override
// //   State<ClassPage> createState() => _ClassPageState();
// // }

// // class _ClassPageState extends State<ClassPage> {
// //   List<ClassModel> _classes = [];
// //   final _maLopController = TextEditingController();
// //   final _tenLopController = TextEditingController();
// //   final _searchController = TextEditingController();
// //   bool isEditing = false;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadClasses();
// //   }

// //   Future<void> _loadClasses() async {
// //     final data = await ClassService.fetchAllClasses();
// //     setState(() {
// //       _classes = data;
// //     });
// //   }

// //   void _showForm({ClassModel? existing}) {
// //     if (existing != null) {
// //       _maLopController.text = existing.maLop;
// //       _tenLopController.text = existing.tenLop;
// //       isEditing = true;
// //     } else {
// //       _maLopController.clear();
// //       _tenLopController.clear();
// //       isEditing = false;
// //     }

// //     showDialog(
// //       context: context,
// //       builder: (_) => AlertDialog(
// //         title: Text(isEditing ? 'Cập nhật lớp học' : 'Thêm lớp học'),
// //         content: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             TextField(
// //               controller: _maLopController,
// //               decoration: const InputDecoration(labelText: 'Mã lớp'),
// //               enabled: !isEditing,
// //             ),
// //             const SizedBox(height: 10),
// //             TextField(
// //               controller: _tenLopController,
// //               decoration: const InputDecoration(labelText: 'Tên lớp'),
// //             ),
// //           ],
// //         ),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.pop(context),
// //             child: const Text('Thoát'),
// //           ),
// //           ElevatedButton(
// //             onPressed: () async {
// //               final maLop = _maLopController.text.trim();
// //               final tenLop = _tenLopController.text.trim();

// //               if (maLop.isEmpty || tenLop.isEmpty) {
// //                 ScaffoldMessenger.of(context).showSnackBar(
// //                   const SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin')),
// //                 );
// //                 return;
// //               }

// //               final success = isEditing
// //                   ? await ClassService.updateClass(maLop, tenLop)
// //                   : await ClassService.addClass(maLop, tenLop);

// //               Navigator.pop(context);

// //               ScaffoldMessenger.of(context).showSnackBar(
// //                 SnackBar(
// //                   content: Text(
// //                     success
// //                         ? (isEditing ? 'Cập nhật lớp thành công' : 'Thêm lớp thành công')
// //                         : (isEditing ? 'Cập nhật lớp thất bại' : 'Thêm lớp thất bại'),
// //                   ),
// //                   backgroundColor: success ? Colors.green : Colors.red,
// //                 ),
// //               );

// //               if (success) _loadClasses();
// //             },
// //             child: Text(isEditing ? 'Cập nhật' : 'Thêm'),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   void _confirmDelete(String maLop) {
// //     showDialog(
// //       context: context,
// //       builder: (_) => AlertDialog(
// //         title: const Text('Xác nhận xoá lớp'),
// //         content: const Text('Bạn có chắc muốn xoá lớp học này không?'),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.pop(context),
// //             child: const Text('Huỷ'),
// //           ),
// //           ElevatedButton(
// //             onPressed: () async {
// //               final success = await ClassService.deleteClass(maLop);
// //               if (success) {
// //                 Navigator.pop(context);
// //                 _loadClasses();
// //                 ScaffoldMessenger.of(context).showSnackBar(
// //                   const SnackBar(content: Text('Xoá lớp thành công'), backgroundColor: Colors.green),
// //                 );
// //               } else {
// //                 ScaffoldMessenger.of(context).showSnackBar(
// //                   const SnackBar(content: Text('Xoá lớp thất bại'), backgroundColor: Colors.red),
// //                 );
// //               }
// //             },
// //             child: const Text('Xoá'),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   void _searchClass() async {
// //     final keyword = _searchController.text.trim();
// //     if (keyword.isEmpty) {
// //       _loadClasses();
// //     } else {
// //       final result = await ClassService.searchClassByMaLop(keyword);
// //       setState(() {
// //         _classes = result;
// //       });
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text('Quản lý lớp học')),
// //       body: Column(
// //         children: [
// //           Padding(
// //             padding: const EdgeInsets.all(12),
// //             child: Material(
// //               elevation: 3,
// //               shadowColor: Colors.grey.withOpacity(0.5),
// //               borderRadius: BorderRadius.circular(30),
// //               child: TextField(
// //                 controller: _searchController,
// //                 onSubmitted: (_) => _searchClass(),
// //                 decoration: InputDecoration(
// //                   hintText: 'Tìm kiếm theo mã lớp...',
// //                   prefixIcon: const Icon(Icons.search),
// //                   suffixIcon: IconButton(
// //                     icon: const Icon(Icons.clear),
// //                     onPressed: () {
// //                       _searchController.clear();
// //                       _loadClasses();
// //                     },
// //                   ),
// //                   border: OutlineInputBorder(
// //                     borderRadius: BorderRadius.circular(30),
// //                     borderSide: BorderSide.none,
// //                   ),
// //                   filled: true,
// //                   fillColor: Colors.white,
// //                   contentPadding: const EdgeInsets.symmetric(vertical: 0),
// //                 ),
// //               ),
// //             ),
// //           ),
// //           Expanded(
// //             child: _classes.isEmpty
// //                 ? const Center(child: Text('Không có lớp nào.'))
// //                 : ListView.builder(
// //                     padding: const EdgeInsets.symmetric(horizontal: 12),
// //                     itemCount: _classes.length,
// //                     itemBuilder: (context, index) {
// //                       final cls = _classes[index];
// //                       return Card(
// //                         shape: RoundedRectangleBorder(
// //                           borderRadius: BorderRadius.circular(15),
// //                         ),
// //                         elevation: 4,
// //                         margin: const EdgeInsets.symmetric(vertical: 8),
// //                         child: ListTile(
// //                           contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// //                           title: Text(
// //                             cls.tenLop,
// //                             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
// //                           ),
// //                           subtitle: Text('Mã lớp: ${cls.maLop}'),
// //                           trailing: Row(
// //                             mainAxisSize: MainAxisSize.min,
// //                             children: [
// //                               IconButton(
// //                                 icon: const Icon(Icons.edit, color: Colors.orange),
// //                                 onPressed: () => _showForm(existing: cls),
// //                               ),
// //                               IconButton(
// //                                 icon: const Icon(Icons.delete, color: Colors.red),
// //                                 onPressed: () => _confirmDelete(cls.maLop),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       );
// //                     },
// //                   ),
// //           ),
// //         ],
// //       ),
// //       floatingActionButton: FloatingActionButton(
// //         onPressed: () => _showForm(),
// //         tooltip: 'Thêm lớp mới',
// //         child: const Icon(Icons.add),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import '../services/class_service.dart';
// import '../models/class_model.dart';

// class ClassPage extends StatefulWidget {
//   final VoidCallback onBack;

//   const ClassPage({super.key, required this.onBack});

//   @override
//   State<ClassPage> createState() => _ClassPageState();
// }

// class _ClassPageState extends State<ClassPage> {
//   List<ClassModel> _classes = [];
//   final _maLopController = TextEditingController();
//   final _tenLopController = TextEditingController();
//   final _searchController = TextEditingController();
//   bool isEditing = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadClasses();
//   }

//   Future<void> _loadClasses() async {
//     final data = await ClassService.fetchAllClasses();
//     setState(() {
//       _classes = data;
//     });
//   }

//   void _showForm({ClassModel? existing}) {
//     if (existing != null) {
//       _maLopController.text = existing.maLop;
//       _tenLopController.text = existing.tenLop;
//       isEditing = true;
//     } else {
//       _maLopController.clear();
//       _tenLopController.clear();
//       isEditing = false;
//     }

//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text(isEditing ? 'Cập nhật lớp học' : 'Thêm lớp học'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: _maLopController,
//               decoration: const InputDecoration(labelText: 'Mã lớp'),
//               enabled: !isEditing,
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: _tenLopController,
//               decoration: const InputDecoration(labelText: 'Tên lớp'),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Thoát'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               final maLop = _maLopController.text.trim();
//               final tenLop = _tenLopController.text.trim();

//               if (maLop.isEmpty || tenLop.isEmpty) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin')),
//                 );
//                 return;
//               }

//               final success = isEditing
//                   ? await ClassService.updateClass(maLop, tenLop)
//                   : await ClassService.addClass(maLop, tenLop);

//               Navigator.pop(context);

//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(
//                     success
//                         ? (isEditing ? 'Cập nhật lớp thành công' : 'Thêm lớp thành công')
//                         : (isEditing ? 'Cập nhật lớp thất bại' : 'Thêm lớp thất bại'),
//                   ),
//                   backgroundColor: success ? Colors.blue : Colors.blue,
//                 ),
//               );

//               if (success) _loadClasses();
//             },
//             child: Text(isEditing ? 'Cập nhật' : 'Thêm'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _confirmDelete(String maLop) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text('Xác nhận xoá lớp'),
//         content: const Text('Bạn có chắc muốn xoá lớp học này không?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Huỷ'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               final success = await ClassService.deleteClass(maLop);
//               if (success) {
//                 Navigator.pop(context);
//                 _loadClasses();
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Xoá lớp thành công'), backgroundColor: Colors.blue),
//                 );
//               } else {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Xoá lớp thất bại'), backgroundColor: Colors.blue),
//                 );
//               }
//             },
//             child: const Text('Xoá'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _searchClass() async {
//     final keyword = _searchController.text.trim();
//     if (keyword.isEmpty) {
//       _loadClasses();
//     } else {
//       final result = await ClassService.searchClassByMaLop(keyword);
//       setState(() {
//         _classes = result;
//       });

//       if (result.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Không tìm thấy lớp học phù hợp')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Quản lý lớp học'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: widget.onBack,
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.list),
//             tooltip: 'Hiện toàn bộ danh sách',
//             onPressed: () {
//               _searchController.clear();
//               _loadClasses();
//             },
//           ),
//         ],
//       ),
//       body: Column(
//   children: [
//     Padding(
//       padding: const EdgeInsets.all(12),
//       child: Material(
//         elevation: 3,
//         shadowColor: Colors.grey.withOpacity(0.5),
//         borderRadius: BorderRadius.circular(30),
//         child: TextField(
//           controller: _searchController,
//           onSubmitted: (_) => _searchClass(),
//           decoration: InputDecoration(
//             hintText: 'Tìm kiếm theo mã lớp...',
//             prefixIcon: IconButton(
//               icon: const Icon(Icons.search),
//               color: Colors.lightBlue, // 🔍 Màu xanh da trời
//               onPressed: _searchClass,
//             ),
//             suffixIcon: IconButton(
//               icon: const Icon(Icons.clear),
//               color: Colors.lightBlue, // ❌ Màu xanh da trời
//               onPressed: () {
//                 _searchController.clear();
//                 _loadClasses();
//               },
//             ),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30),
//                     borderSide: BorderSide.none,
//                   ),
//                   filled: true,
//                   fillColor: Colors.white,
//                   contentPadding: const EdgeInsets.symmetric(vertical: 0),
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: _classes.isEmpty
//                 ? const Center(child: Text('Không có lớp nào.'))
//                 : ListView.builder(
//                     padding: const EdgeInsets.symmetric(horizontal: 12),
//                     itemCount: _classes.length,
//                     itemBuilder: (context, index) {
//                       final cls = _classes[index];
//                       return Card(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         elevation: 4,
//                         margin: const EdgeInsets.symmetric(vertical: 8),
//                         child: ListTile(
//                           contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                           title: Text(
//                             cls.tenLop,
//                             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                           ),
//                           subtitle: Text('Mã lớp: ${cls.maLop}'),
//                           trailing: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               IconButton(
//                                 icon: const Icon(Icons.edit, color: Colors.blue),
//                                 onPressed: () => _showForm(existing: cls),
//                               ),
//                               IconButton(
//                                 icon: const Icon(Icons.delete, color: Colors.blue),
//                                 onPressed: () => _confirmDelete(cls.maLop),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _showForm(),
//         tooltip: 'Thêm lớp mới',
//         backgroundColor: Colors.lightBlue,
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
