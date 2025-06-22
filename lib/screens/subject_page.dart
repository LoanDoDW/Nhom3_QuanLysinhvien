// import 'package:flutter/material.dart';
// import '../models/subject_model.dart';
// import '../services/subject_service.dart';

// class SubjectPage extends StatefulWidget {
//   final VoidCallback onBack;

//   const SubjectPage({super.key, required this.onBack});

//   @override
//   State<SubjectPage> createState() => _SubjectPageState();
// }

// class _SubjectPageState extends State<SubjectPage> {
//   List<SubjectModel> _subjects = [];
//   final _maMonController = TextEditingController();
//   final _tenMonController = TextEditingController();
//   final _soTinChiController = TextEditingController();
//   final _searchController = TextEditingController();
//   bool isEditing = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadSubjects();
//   }

//   Future<void> _loadSubjects() async {
//     final data = await SubjectService.fetchAll();
//     setState(() => _subjects = data);
//   }

//   void _showForm({SubjectModel? existing}) {
//     if (existing != null) {
//       _maMonController.text = existing.maMon;
//       _tenMonController.text = existing.tenMon;
//       _soTinChiController.text = existing.soTinChi.toString();
//       isEditing = true;
//     } else {
//       _maMonController.clear();
//       _tenMonController.clear();
//       _soTinChiController.clear();
//       isEditing = false;
//     }

//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text(isEditing ? 'Cập nhật môn học' : 'Thêm môn học'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: _maMonController,
//               decoration: const InputDecoration(labelText: 'Mã môn'),
//               enabled: !isEditing,
//             ),
//             TextField(
//               controller: _tenMonController,
//               decoration: const InputDecoration(labelText: 'Tên môn'),
//             ),
//             TextField(
//               controller: _soTinChiController,
//               decoration: const InputDecoration(labelText: 'Số tín chỉ'),
//               keyboardType: TextInputType.number,
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context), child: const Text('Thoát')),
//           ElevatedButton(
//             onPressed: () async {
//               final maMon = _maMonController.text.trim();
//               final tenMon = _tenMonController.text.trim();
//               final soTinChi = int.tryParse(_soTinChiController.text.trim());

//               if (maMon.isEmpty || tenMon.isEmpty || soTinChi == null) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Vui lòng nhập đầy đủ và đúng định dạng')),
//                 );
//                 return;
//               }

//               final success = isEditing
//                   ? await SubjectService.updateSubject(maMon, tenMon, soTinChi)
//                   : await SubjectService.addSubject(maMon, tenMon, soTinChi);

//               Navigator.pop(context);
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(
//                     success
//                         ? (isEditing ? 'Cập nhật thành công' : 'Thêm thành công')
//                         : (isEditing ? 'Cập nhật thất bại' : 'Thêm thất bại'),
//                   ),
//                   backgroundColor: success ? Color(0xFF003366) : Colors.red,
//                 ),
//               );

//               if (success) _loadSubjects();
//             },
//             child: Text(isEditing ? 'Cập nhật' : 'Thêm'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _confirmDelete(String maMon) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text('Xác nhận xoá'),
//         content: const Text('Bạn có chắc muốn xoá môn học này không?'),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context), child: const Text('Huỷ')),
//           ElevatedButton(
//             onPressed: () async {
//               final success = await SubjectService.deleteSubject(maMon);
//               Navigator.pop(context);
//               if (success) {
//                 _loadSubjects();
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Xoá thành công'), backgroundColor: Color(0xFF003366)),
//                 );
//               } else {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Xoá thất bại'), backgroundColor: Color(0xFF003366)),
//                 );
//               }
//             },
//             child: const Text('Xoá'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _searchSubject() async {
//     final keyword = _searchController.text.trim();
//     if (keyword.isEmpty) {
//       _loadSubjects();
//     } else {
//       final result = await SubjectService.searchSubjectByMaMon(keyword);
//       setState(() => _subjects = result);
//       if (result.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Không tìm thấy môn học')),
//         );
//       }
//     }
//   }

//   void _showSubjectDetail(SubjectModel subject) async {
//     try {
//       final students = await SubjectService.fetchStudentsBySubject(subject.maMon);

//       showDialog(
//         context: context,
//         builder: (_) => AlertDialog(
//           title: const Text('Thông tin môn học'),
//           content: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Mã môn: ${subject.maMon}'),
//                 Text('Tên môn: ${subject.tenMon}'),
//                 Text('Số tín chỉ: ${subject.soTinChi}'),
//                 const SizedBox(height: 12),
//                 const Text('Danh sách sinh viên:', style: TextStyle(fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 6),
//                 students.isEmpty
//                     ? const Text('Không có sinh viên học môn này')
//                     : Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: students.map((sv) => Text('• ${sv['ma_sv']} - ${sv['ten_sv']}')).toList(),
//                       ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Trở về'),
//             ),
//           ],
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Lỗi khi tải thông tin môn học: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//   appBar: AppBar(
//   backgroundColor: Color(0xFF003366), // Nền xanh
//   iconTheme: const IconThemeData(color: Colors.white), // Icon trắng
//   title: const Text(
//     'Quản lý môn học',
//     style: TextStyle(
//       color: Colors.white,
//       fontWeight: FontWeight.bold, // In đậm
//     ),
//   ),
//   leading: IconButton(
//     icon: const Icon(Icons.arrow_back),
//     onPressed: widget.onBack,
//   ),
//   // Đã xoá actions hoặc giữ trống nếu muốn giữ cấu trúc
//   actions: [],
// ),

//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: Material(
//               elevation: 3,
//               shadowColor: Colors.grey.withOpacity(0.5),
//               borderRadius: BorderRadius.circular(30),
//               child: TextField(
//                 controller: _searchController,
//                 onSubmitted: (_) => _searchSubject(),
//                 decoration: InputDecoration(
//                   hintText: 'Tìm kiếm theo mã môn...',
//                   prefixIcon: IconButton(
//                     icon: const Icon(Icons.search),
//                     color: Color(0xFF003366),
//                     onPressed: _searchSubject,
//                   ),
//                   suffixIcon: IconButton(
//                     icon: const Icon(Icons.clear),
//                     color: Color(0xFF003366),
//                     onPressed: () {
//                       _searchController.clear();
//                       _loadSubjects();
//                     },
//                   ),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30),
//                     borderSide: BorderSide.none,
//                   ),
//                   filled: true,
//                   fillColor: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: _subjects.isEmpty
//                 ? const Center(child: Text('Không có môn học nào'))
//                 : ListView.builder(
//                     itemCount: _subjects.length,
//                     itemBuilder: (context, index) {
//                       final subject = _subjects[index];
//                       return Card(
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//                         elevation: 4,
//                         margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                         child: ListTile(
//                           contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                           title: Text(
//                             subject.tenMon,
//                             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                           ),
//                           subtitle: Text('Mã: ${subject.maMon} | Số TC: ${subject.soTinChi}'),
//                           onTap: () => _showSubjectDetail(subject),
//                           trailing: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               IconButton(
//                                 icon: const Icon(Icons.edit, color: Color(0xFF003366)),
//                                 onPressed: () => _showForm(existing: subject),
//                               ),
//                               IconButton(
//                                 icon: const Icon(Icons.delete, color: Color(0xFF003366)),
//                                 onPressed: () => _confirmDelete(subject.maMon),
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
//         tooltip: 'Thêm môn mới',
//         backgroundColor: Color(0xFF003366),
//         child: const Icon(Icons.add, color: Colors.white,),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../models/subject_model.dart';
import '../services/subject_service.dart';

class SubjectPage extends StatefulWidget {
  final VoidCallback onBack;
  const SubjectPage({super.key, required this.onBack});

  @override
  State<SubjectPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  List<SubjectModel> _subjects = [];
  final _maMonController = TextEditingController();
  final _tenMonController = TextEditingController();
  final _soTinChiController = TextEditingController();
  final _searchController = TextEditingController();
  bool isEditing = false;
  String? _formErrorMessage;

  @override
  void initState() {
    super.initState();
    _loadSubjects();
  }

  Future<void> _loadSubjects() async {
    final data = await SubjectService.fetchAll();
    setState(() => _subjects = data);
  }

  void _showForm({SubjectModel? existing}) {
    if (existing != null) {
      _maMonController.text = existing.maMon;
      _tenMonController.text = existing.tenMon;
      _soTinChiController.text = existing.soTinChi.toString();
      isEditing = true;
    } else {
      _maMonController.clear();
      _tenMonController.clear();
      _soTinChiController.clear();
      isEditing = false;
    }

    _formErrorMessage = null;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: Text(
            isEditing ? 'Cập nhật môn học' : 'Thêm môn học',
            style: const TextStyle(
              color: Color(0xFF003366),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _maMonController,
                decoration: const InputDecoration(labelText: 'Mã môn'),
                enabled: !isEditing,
              ),
              TextField(
                controller: _tenMonController,
                decoration: const InputDecoration(labelText: 'Tên môn'),
              ),
              TextField(
                controller: _soTinChiController,
                decoration: const InputDecoration(labelText: 'Số tín chỉ'),
                keyboardType: TextInputType.number,
              ),
              if (_formErrorMessage != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _formErrorMessage!,
                          style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Thoát')),
            ElevatedButton(
              onPressed: () async {
                final maMon = _maMonController.text.trim();
                final tenMon = _tenMonController.text.trim();
                final soTinChi = int.tryParse(_soTinChiController.text.trim());

                if (maMon.isEmpty || tenMon.isEmpty || soTinChi == null) {
                  setStateDialog(() {
                    _formErrorMessage = 'Vui lòng nhập đầy đủ và đúng định dạng';
                  });
                  return;
                }

                Map<String, dynamic> result;

                if (isEditing) {
                  result = await SubjectService.updateSubject(maMon, tenMon, soTinChi);
                } else {
                  result = await SubjectService.addSubjectWithMessage(maMon, tenMon, soTinChi);
                }

                if (result['success']) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(result['message']), backgroundColor: Color(0xFF003366)),
                  );
                  _loadSubjects();
                } else {
                  setStateDialog(() {
                    _formErrorMessage = result['message'];
                  });
                }
              },
              child: Text(isEditing ? 'Cập nhật' : 'Thêm'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(String maMon) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          'Xoá môn học',
          style: TextStyle(color: Color(0xFF003366), fontWeight: FontWeight.bold),
        ),
        content: const Text('Bạn có chắc muốn xoá môn học này không?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Huỷ')),
          ElevatedButton(
            onPressed: () async {
              final success = await SubjectService.deleteSubject(maMon);
              Navigator.pop(context);
              if (success) {
                _loadSubjects();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Xoá thành công'), backgroundColor: Color(0xFF003366)),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Xoá thất bại'), backgroundColor: Colors.redAccent),
                );
              }
            },
            child: const Text('Xoá'),
          ),
        ],
      ),
    );
  }

  void _showDetails(SubjectModel subject) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          'Thông tin môn học',
          style: TextStyle(color: Color(0xFF003366), fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mã môn: ${subject.maMon}'),
            Text('Tên môn: ${subject.tenMon}'),
            Text('Số tín chỉ: ${subject.soTinChi}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  void _searchSubject() async {
    final keyword = _searchController.text.trim();
    if (keyword.isEmpty) {
      _loadSubjects();
    } else {
      final result = await SubjectService.searchSubjectByMaMon(keyword);
      setState(() => _subjects = result);
      if (result.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không tìm thấy môn học')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF003366),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Quản lý môn học',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Material(
              elevation: 3,
              shadowColor: Colors.grey.withOpacity(0.5),
              borderRadius: BorderRadius.circular(30),
              child: TextField(
                controller: _searchController,
                onSubmitted: (_) => _searchSubject(),
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm theo mã môn...',
                  prefixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    color: Color(0xFF003366),
                    onPressed: _searchSubject,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    color: Color(0xFF003366),
                    onPressed: () {
                      _searchController.clear();
                      _loadSubjects();
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: _subjects.isEmpty
                ? const Center(child: Text('Không có môn học nào'))
                : ListView.builder(
                    itemCount: _subjects.length,
                    itemBuilder: (context, index) {
                      final subject = _subjects[index];
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          title: GestureDetector(
                            onTap: () => _showDetails(subject),
                            child: Text(subject.tenMon,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ),
                          subtitle: Text('Mã: ${subject.maMon} | Số TC: ${subject.soTinChi}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Color(0xFF003366)),
                                onPressed: () => _showForm(existing: subject),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Color(0xFF003366)),
                                onPressed: () => _confirmDelete(subject.maMon),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(),
        tooltip: 'Thêm môn mới',
        backgroundColor: Color(0xFF003366),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
