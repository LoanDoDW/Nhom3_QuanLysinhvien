// import 'package:flutter/material.dart';
// import '../models/score_model.dart';
// import '../models/student_model.dart';
// import '../models/subject_model.dart';
// import '../services/score_service.dart';
// import '../services/student_service.dart';

// class ScorePage extends StatefulWidget {
//   final VoidCallback onBack;
//   const ScorePage({super.key, required this.onBack});

//   @override
//   State<ScorePage> createState() => _ScorePageState();
// }

// class _ScorePageState extends State<ScorePage> {
//   List<ScoreModel> _scores = [];
//   List<Student> _students = [];
//   List<SubjectModel> _filteredSubjects = [];
//   String _searchText = '';

//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }

//   Future<void> _loadData() async {
//     final scores = await ScoreService.fetchAll();
//     final students = await StudentService.fetchAll();
//     setState(() {
//       _scores = scores;
//       _students = students;
//     });
//   }

//   void _showForm({ScoreModel? score}) {
//     final _formKey = GlobalKey<FormState>();
//     final _maSvController = TextEditingController();
//     final _tenSvController = TextEditingController();
//     final _diemController = TextEditingController();
//     int? selectedSubjectId;
//     int? selectedStudentId;

//     if (score != null) {
//       final student = _students.firstWhere((s) => s.id == score.studentId,
//           orElse: () => Student(id: 0, maSv: '', hoTen: '', gioiTinh: '', ngaySinh: '', nganhId: 0));
//       _maSvController.text = student.maSv;
//       _tenSvController.text = score.studentName;
//       _diemController.text = score.diem.toString();
//       selectedSubjectId = score.subjectId;
//       selectedStudentId = score.studentId;

//       ScoreService.fetchSubjectsByMajor(student.nganhId).then((subjects) {
//         setState(() {
//           _filteredSubjects = subjects;
//         });
//       });
//     }

//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text(score == null ? 'Thêm điểm' : 'Sửa điểm'),
//         content: StatefulBuilder(
//           builder: (context, setDialogState) {
//             return Form(
//               key: _formKey,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   TextFormField(
//                     controller: _maSvController,
//                     decoration: const InputDecoration(labelText: 'Mã sinh viên'),
//                     onChanged: (value) async {
//                       final sv = _students.firstWhere(
//                         (s) => s.maSv.toLowerCase() == value.toLowerCase(),
//                         orElse: () => Student(id: 0, maSv: '', hoTen: '', gioiTinh: '', ngaySinh: '', nganhId: 0),
//                       );
//                       if (sv.id != 0) {
//                         selectedStudentId = sv.id;
//                         _tenSvController.text = sv.hoTen;
//                         final subjectsByMajor = await ScoreService.fetchSubjectsByMajor(sv.nganhId);
//                         setDialogState(() {
//                           _filteredSubjects = subjectsByMajor;
//                           selectedSubjectId = null;
//                         });
//                       } else {
//                         selectedStudentId = null;
//                         _tenSvController.clear();
//                         setDialogState(() {
//                           _filteredSubjects = [];
//                           selectedSubjectId = null;
//                         });
//                       }
//                     },
//                     validator: (value) => value == null || value.isEmpty ? 'Nhập mã sinh viên' : null,
//                   ),
//                   const SizedBox(height: 8),
//                   TextFormField(
//                     controller: _tenSvController,
//                     decoration: const InputDecoration(labelText: 'Tên sinh viên'),
//                     readOnly: true,
//                   ),
//                   const SizedBox(height: 8),
//                   DropdownButtonFormField<int>(
//                     value: selectedSubjectId,
//                     decoration: const InputDecoration(labelText: 'Chọn môn học'),
//                     items: _filteredSubjects.map((s) {
//                       return DropdownMenuItem(
//                         value: s.id,
//                         child: Text('${s.maMon} - ${s.tenMon}'),
//                       );
//                     }).toList(),
//                     onChanged: (value) => selectedSubjectId = value,
//                     validator: (value) => value == null ? 'Chọn môn học' : null,
//                   ),
//                   const SizedBox(height: 8),
//                   TextFormField(
//                     controller: _diemController,
//                     keyboardType: TextInputType.number,
//                     decoration: const InputDecoration(labelText: 'Điểm'),
//                     validator: (value) {
//                       final d = double.tryParse(value ?? '');
//                       if (d == null || d < 0 || d > 10) return 'Nhập điểm từ 0 - 10';
//                       return null;
//                     },
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context), child: const Text('Huỷ')),
//           ElevatedButton(
//             onPressed: () async {
//               if (_formKey.currentState!.validate() &&
//                   selectedStudentId != null &&
//                   selectedSubjectId != null) {
//                 final newScore = ScoreModel(
//                   id: score?.id ?? 0,
//                   studentId: selectedStudentId!,
//                   studentName: _tenSvController.text,
//                   subjectId: selectedSubjectId!,
//                   subjectName: '',
//                   diem: double.parse(_diemController.text),
//                 );
//                 final result = score == null
//                     ? await ScoreService.add(newScore)
//                     : await ScoreService.update(newScore);
//                 if (mounted) {
//                   Navigator.pop(context);
//                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                     content: Text(result['message']),
//                     backgroundColor: result['success'] ? Colors.blue : Colors.red,
//                   ));
//                   _loadData();
//                 }
//               }
//             },
//             child: Text(score == null ? 'Thêm' : 'Cập nhật'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final filteredScores = _scores.where((s) {
//       final student = _students.firstWhere(
//         (st) => st.id == s.studentId,
//         orElse: () => Student(id: 0, maSv: '', hoTen: '', gioiTinh: '', ngaySinh: '', nganhId: 0),
//       );
//       return student.maSv.toLowerCase().contains(_searchText) ||
//           s.subjectName.toLowerCase().contains(_searchText);
//     }).toList();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Quản lý điểm'),
//         leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: widget.onBack),
//         actions: [
//           IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
//         ],
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Container(
//               decoration: BoxDecoration(
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black12,
//                     blurRadius: 6,
//                     offset: Offset(0, 2),
//                   ),
//                 ],
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               child: TextField(
//                 decoration: InputDecoration(
//                   hintText: 'Tìm mã sinh viên hoặc tên môn học',
//                   prefixIcon: const Icon(Icons.search, color: Colors.blue),
//                   suffixIcon: _searchText.isNotEmpty
//                       ? IconButton(
//                           icon: const Icon(Icons.clear, color: Colors.blue),
//                           onPressed: () => setState(() => _searchText = ''),
//                         )
//                       : null,
//                   filled: true,
//                   fillColor: Colors.white,
//                   contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//                 onChanged: (value) => setState(() => _searchText = value.toLowerCase()),
//               ),
//             ),
//           ),
//         Expanded(
//   child: filteredScores.isEmpty
//       ? const Center(child: Text('Không có dữ liệu'))
//       : SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: DataTable(
//             border: TableBorder.all(
//               color: Colors.grey.shade400,
//               width: 1,
//             ),
//             columns: const [
//               DataColumn(label: Text('Mã SV')),
//               DataColumn(label: Text('Họ tên')),
//               DataColumn(label: Text('Môn học')),
//               DataColumn(label: Text('Điểm')),
//               DataColumn(label: Text('Hành động')),
//             ],
//             rows: filteredScores.map((s) {
//               final student = _students.firstWhere(
//                 (st) => st.id == s.studentId,
//                 orElse: () => Student(id: 0, maSv: '???', hoTen: '???', gioiTinh: '', ngaySinh: '', nganhId: 0),
//               );
//               return DataRow(cells: [
//                 DataCell(Text(student.maSv)),
//                 DataCell(Text(s.studentName)),
//                 DataCell(Text(s.subjectName)),
//                 DataCell(Text(s.diem.toStringAsFixed(2))),
//                 DataCell(Row(
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.edit, color: Colors.blue),
//                       onPressed: () => _showForm(score: s),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.delete, color: Colors.blue),
//                       onPressed: () async {
//                         final confirm = await showDialog(
//                           context: context,
//                           builder: (_) => AlertDialog(
//                             title: const Text('Xác nhận xoá'),
//                             content: const Text('Bạn có chắc muốn xoá điểm này?'),
//                             actions: [
//                               TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Huỷ')),
//                               TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Xoá')),
//                             ],
//                           ),
//                         );
//                         if (confirm == true) {
//                           final result = await ScoreService.delete(s.id);
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text(result['message']),
//                               backgroundColor: result['success'] ? Colors.blue : Colors.red,
//                             ),
//                           );
//                           _loadData();
//                         }
//                       },
//                     ),
//                   ],
//                 )),
//               ]);
//             }).toList(),
//           ),
//         ),
// )

//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _showForm(),
//         child: const Icon(Icons.add),
//         backgroundColor: Colors.blue,
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../models/score_model.dart';
import '../models/student_model.dart';
import '../models/subject_model.dart';
import '../services/score_service.dart';
import '../services/student_service.dart';

class ScorePage extends StatefulWidget {
  final VoidCallback onBack;
  const ScorePage({super.key, required this.onBack});

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  List<ScoreModel> _scores = [];
  List<Student> _students = [];
  List<SubjectModel> _filteredSubjects = [];
  String _searchText = '';
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final scores = await ScoreService.fetchAll();
    final students = await StudentService.fetchAll();
    setState(() {
      _scores = scores;
      _students = students;
    });
  }

  void _searchScore(String keyword) async {
    if (keyword.trim().isEmpty) {
      _loadData();
      return;
    }
    setState(() => _isSearching = true);
    final result = await ScoreService.search(keyword);
    setState(() {
      _scores = result;
      _isSearching = false;
    });
  }

  void _showMessage(String msg, {bool success = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: success ? const Color(0xFF003366) : Colors.red,
      ),
    );
  }

  void _showForm({ScoreModel? score}) {
    final _formKey = GlobalKey<FormState>();
    final _maSvController = TextEditingController();
    final _tenSvController = TextEditingController();
    final _diemController = TextEditingController();
    int? selectedSubjectId;
    int? selectedStudentId;
    String? _formErrorMessage;

    final isUpdate = score != null;

    if (isUpdate) {
      _maSvController.text = score.studentCode;
      _tenSvController.text = score.studentName;
      _diemController.text = score.diem.toString();
      selectedSubjectId = score.subjectId;
      selectedStudentId = score.studentId;

      final sv = _students.firstWhere(
        (s) => s.id == selectedStudentId,
        orElse: () => Student(id: 0, maSv: '', hoTen: '', gioiTinh: '', ngaySinh: '', nganhId: 0),
      );
      ScoreService.fetchSubjectsByMajor(sv.nganhId).then((subjects) {
        setState(() {
          _filteredSubjects = subjects;
        });
      });
    }

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
           title: Text(
  isUpdate ? 'Sửa điểm' : 'Thêm điểm',
  style: const TextStyle(
    color: Color(0xFF003366),
    fontWeight: FontWeight.bold,
  ),
),

            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _maSvController,
                          decoration: const InputDecoration(labelText: 'Mã sinh viên'),
                          readOnly: isUpdate,
                          onChanged: isUpdate
                              ? null
                              : (value) async {
                                  final sv = _students.firstWhere(
                                    (s) => s.maSv.toLowerCase() == value.toLowerCase(),
                                    orElse: () => Student(id: 0, maSv: '', hoTen: '', gioiTinh: '', ngaySinh: '', nganhId: 0),
                                  );
                                  if (sv.id != 0) {
                                    selectedStudentId = sv.id;
                                    _tenSvController.text = sv.hoTen;
                                    final subjectsByMajor = await ScoreService.fetchSubjectsByMajor(sv.nganhId);
                                    setDialogState(() {
                                      _filteredSubjects = subjectsByMajor;
                                      selectedSubjectId = null;
                                    });
                                  } else {
                                    selectedStudentId = null;
                                    _tenSvController.clear();
                                    setDialogState(() {
                                      _filteredSubjects = [];
                                      selectedSubjectId = null;
                                    });
                                  }
                                },
                          validator: (value) => value == null || value.isEmpty ? 'Nhập mã sinh viên' : null,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _tenSvController,
                          decoration: const InputDecoration(labelText: 'Tên sinh viên'),
                          readOnly: true,
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<int>(
                          value: selectedSubjectId,
                          decoration: const InputDecoration(labelText: 'Chọn môn học'),
                          items: _filteredSubjects.map((s) {
                            return DropdownMenuItem(
                              value: s.id,
                              child: Text("${s.maMon} - ${s.tenMon}"),
                            );
                          }).toList(),
                          onChanged: isUpdate ? null : (value) => selectedSubjectId = value,
                          validator: (value) => value == null ? 'Chọn môn học' : null,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _diemController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Điểm'),
                          validator: (value) {
                            final d = double.tryParse(value ?? '');
                            if (d == null || d < 0 || d > 10) return 'Nhập điểm từ 0 - 10';
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  if (_formErrorMessage != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red),
                          const SizedBox(width: 8),
                          Expanded(child: Text(_formErrorMessage!, style: const TextStyle(color: Colors.red))),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Huỷ')),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate() && selectedStudentId != null && selectedSubjectId != null) {
                    final sv = _students.firstWhere((s) => s.id == selectedStudentId);
                    final subject = _filteredSubjects.firstWhere((s) => s.id == selectedSubjectId);
                    final newScore = ScoreModel(
                      id: score?.id ?? 0,
                      studentId: sv.id,
                      studentCode: sv.maSv,
                      studentName: sv.hoTen,
                      subjectId: subject.id,
                      subjectName: subject.tenMon,
                      diem: double.parse(_diemController.text),
                    );
                    final result = isUpdate
                        ? await ScoreService.update(newScore)
                        : await ScoreService.add(newScore);
                    if (mounted) {
                      if (result['status']) {
                        Navigator.pop(context);
                        _showMessage(result['message']);
                        _loadData();
                      } else {
                        setDialogState(() {
                          _formErrorMessage = result['message'] ?? 'Đã xảy ra lỗi';
                        });
                      }
                    }
                  } else {
                    setDialogState(() {
                      _formErrorMessage = 'Vui lòng nhập đầy đủ và đúng thông tin';
                    });
                  }
                },
                child: Text(isUpdate ? 'Cập nhật' : 'Thêm'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scoresToShow = _scores;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF003366),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Quản lý điểm', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: widget.onBack),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Tìm mã sinh viên hoặc tên môn học',
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF003366)),
                  suffixIcon: _searchText.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Color(0xFF003366)),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchText = '');
                            _loadData();
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  setState(() => _searchText = value);
                  _searchScore(value);
                },
              ),
            ),
          ),
          _isSearching
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: scoresToShow.isEmpty
                      ? const Center(child: Text('Không có dữ liệu'))
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            border: TableBorder.all(color: Colors.grey.shade400, width: 1),
                            columns: const [
                              DataColumn(label: Text('Mã SV')),
                              DataColumn(label: Text('Họ tên')),
                              DataColumn(label: Text('Môn học')),
                              DataColumn(label: Text('Điểm')),
                              DataColumn(label: Text('Hành động')),
                            ],
                            rows: scoresToShow.map((s) {
                              return DataRow(cells: [
                                DataCell(Text(s.studentCode)),
                                DataCell(Text(s.studentName)),
                                DataCell(Text(s.subjectName)),
                                DataCell(Text(s.diem.toStringAsFixed(2))),
                                DataCell(Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Color(0xFF003366)),
                                      onPressed: () => _showForm(score: s),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Color(0xFF003366)),
                                      onPressed: () async {
                                        final confirm = await showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                           title: const Text(
                                                'Xóa điểm',
                                                   style: TextStyle(
                                                  color: Color(0xFF003366),
                                                      fontWeight: FontWeight.bold,
                                              ),
                                            ),

                                            content: const Text('Bạn có chắc muốn xoá điểm này?'),
                                            actions: [
                                              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Huỷ')),
                                              TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Xoá')),
                                            ],
                                          ),
                                        );
                                        if (confirm == true) {
                                          final result = await ScoreService.delete(s.id);
                                          if (mounted) {
                                            _showMessage(result['message'], success: result['status']);
                                            _loadData();
                                          }
                                        }
                                      },
                                    ),
                                  ],
                                )),
                              ]);
                            }).toList(),
                          ),
                        ),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(),
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: const Color(0xFF003366),
      ),
    );
  }
}
