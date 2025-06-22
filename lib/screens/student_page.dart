// import 'package:flutter/material.dart';
// import '../models/student_model.dart';
// import '../models/major_model.dart';
// import '../services/student_service.dart';
// import '../services/major_service.dart';

// class StudentPage extends StatefulWidget {
//   final VoidCallback onBack;
//   const StudentPage({super.key, required this.onBack});

//   @override
//   State<StudentPage> createState() => _StudentPageState();
// }

// class _StudentPageState extends State<StudentPage> {
//   List<Student> _students = [];
//   List<MajorModel> _majors = [];

//   final _maSvController = TextEditingController();
//   final _hoTenController = TextEditingController();
//   final _ngaySinhController = TextEditingController();
//   final _searchController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();

//   int? _selectedMajorId;
//   String? _gioiTinh;
//   bool isEditing = false;
//   int? editingId;

//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }

//   Future<void> _loadData() async {
//     final students = await StudentService.fetchAll();
//     final majors = await MajorService.fetchAllMajors();
//     setState(() {
//       _students = students;
//       _majors = majors;
//     });
//   }

//   void _showDetails(Student student) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text('Thông tin chi tiết'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Mã SV: ${student.maSv}'),
//             Text('Họ tên: ${student.hoTen}'),
//             Text('Giới tính: ${student.gioiTinh}'),
//             Text('Ngày sinh: ${student.ngaySinh}'),
//             Text('Ngành học: ${student.tenNganh}'),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Đóng'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showForm({Student? existing}) {
//     if (existing != null) {
//       _maSvController.text = existing.maSv;
//       _hoTenController.text = existing.hoTen;
//       _gioiTinh = existing.gioiTinh;
//       _ngaySinhController.text = existing.ngaySinh;
//       _selectedMajorId = existing.nganhId;
//       editingId = existing.id;
//       isEditing = true;
//     } else {
//       _maSvController.clear();
//       _hoTenController.clear();
//       _ngaySinhController.clear();
//       _gioiTinh = null;
//       _selectedMajorId = null;
//       editingId = null;
//       isEditing = false;
//     }

//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text(isEditing ? 'Cập nhật sinh viên' : 'Thêm sinh viên'),
//         content: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 TextFormField(
//                   controller: _maSvController,
//                   enabled: !isEditing,
//                   decoration: const InputDecoration(labelText: 'Mã SV'),
//                   validator: (value) => (value == null || value.trim().isEmpty)
//                       ? 'Vui lòng nhập mã sinh viên'
//                       : null,
//                 ),
//                 TextFormField(
//                   controller: _hoTenController,
//                   decoration: const InputDecoration(labelText: 'Họ tên'),
//                   validator: (value) => (value == null || value.trim().isEmpty)
//                       ? 'Vui lòng nhập họ tên'
//                       : null,
//                 ),
//                 DropdownButtonFormField<String>(
//                   value: _gioiTinh,
//                   decoration: const InputDecoration(labelText: 'Giới tính'),
//                   items: ['Nam', 'Nữ'].map((gender) {
//                     return DropdownMenuItem(value: gender, child: Text(gender));
//                   }).toList(),
//                   onChanged: (value) => setState(() => _gioiTinh = value),
//                   validator: (value) =>
//                       value == null ? 'Chọn giới tính' : null,
//                 ),
//                 TextFormField(
//                   controller: _ngaySinhController,
//                   readOnly: true,
//                   decoration: const InputDecoration(labelText: 'Ngày sinh'),
//                   onTap: () async {
//                     final pickedDate = await showDatePicker(
//                       context: context,
//                       initialDate: DateTime(2000),
//                       firstDate: DateTime(1950),
//                       lastDate: DateTime.now(),
//                     );
//                     if (pickedDate != null) {
//                       _ngaySinhController.text =
//                           pickedDate.toIso8601String().substring(0, 10);
//                     }
//                   },
//                   validator: (value) => (value == null || value.trim().isEmpty)
//                       ? 'Chọn ngày sinh'
//                       : null,
//                 ),
//                 DropdownButtonFormField<int>(
//                   value: _majors.any((m) => m.id == _selectedMajorId)
//                       ? _selectedMajorId
//                       : null,
//                   decoration: const InputDecoration(labelText: 'Ngành học'),
//                   items: _majors.map((m) {
//                     return DropdownMenuItem(value: m.id, child: Text(m.tenNganh));
//                   }).toList(),
//                   onChanged: (value) => setState(() => _selectedMajorId = value),
//                   validator: (value) =>
//                       value == null ? 'Chọn ngành học' : null,
//                 ),
//               ],
//             ),
//           ),
//         ),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context), child: const Text('Thoát')),
//           ElevatedButton(
//             onPressed: () async {
//               if (_formKey.currentState!.validate()) {
//                 final student = Student(
//                   id: editingId ?? 0,
//                   maSv: _maSvController.text.trim(),
//                   hoTen: _hoTenController.text.trim(),
//                   gioiTinh: _gioiTinh ?? '',
//                   ngaySinh: _ngaySinhController.text.trim(),
//                   nganhId: _selectedMajorId!,
//                 );

//                 final result = isEditing
//                     ? await StudentService.update(student)
//                     : await StudentService.add(student);

//                 if (result['success']) {
//                   Navigator.pop(context);
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text(result['message']), backgroundColor: Color(0xFF003366)),
//                   );
//                   _loadData();
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text(result['message']), backgroundColor: Colors.redAccent),
//                   );
//                 }
//               }
//             },
//             child: Text(isEditing ? 'Cập nhật' : 'Thêm'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _confirmDelete(String maSv) async {
//     final confirmed = await showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text('Xoá sinh viên'),
//         content: const Text('Bạn có chắc chắn xoá sinh viên này?'),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Huỷ')),
//           ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Xoá')),
//         ],
//       ),
//     );
//     if (confirmed == true) {
//       final result = await StudentService.delete(maSv);
//       if (result['success']) {
//         _loadData();
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(result['message']), backgroundColor:Color(0xFF003366)),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(result['message']), backgroundColor: Colors.redAccent),
//         );
//       }
//     }
//   }

//   void _searchStudent() async {
//     final keyword = _searchController.text.trim();
//     if (keyword.isEmpty) {
//       _loadData();
//     } else {
//       final result = await StudentService.search(keyword);
//       setState(() => _students = result);
//       if (result.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Không tìm thấy sinh viên phù hợp')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//      appBar: AppBar(
//   backgroundColor: Color(0xFF003366), // Nền xanh
//   iconTheme: const IconThemeData(color: Colors.white), // Icon trắng
//   title: const Text(
//     'Quản lý sinh viên',
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
//                 onSubmitted: (_) => _searchStudent(),
//                 decoration: InputDecoration(
//                   hintText: 'Tìm mã sinh viên...',
//                   prefixIcon: IconButton(
//                     icon: const Icon(Icons.search),
//                     color: Color(0xFF003366),
//                     onPressed: _searchStudent,
//                   ),
//                   suffixIcon: IconButton(
//                     icon: const Icon(Icons.clear),
//                     color: Color(0xFF003366),
//                     onPressed: () {
//                       _searchController.clear();
//                       _loadData();
//                     },
//                   ),
//                   filled: true,
//                   fillColor: Colors.white,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: _students.isEmpty
//                 ? const Center(child: Text('Không có dữ liệu'))
//                 : ListView.builder(
//                     itemCount: _students.length,
//                     itemBuilder: (context, index) {
//                       final s = _students[index];
//                       return Card(
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//                         elevation: 4,
//                         margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                         child: ListTile(
//                           contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                           title: Text(s.hoTen, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                           subtitle: Text('MSSV: ${s.maSv}\nNgành: ${s.tenNganh}'),
//                           isThreeLine: true,
//                           trailing: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               IconButton(
//                                 icon: const Icon(Icons.info, color: Color(0xFF003366)),
//                                 tooltip: 'Xem chi tiết',
//                                 onPressed: () => _showDetails(s),
//                               ),
//                               IconButton(
//                                 icon: const Icon(Icons.edit, color: Color(0xFF003366)),
//                                 tooltip: 'Sửa',
//                                 onPressed: () => _showForm(existing: s),
//                               ),
//                               IconButton(
//                                 icon: const Icon(Icons.delete, color: Color(0xFF003366)),
//                                 tooltip: 'Xoá',
//                                 onPressed: () => _confirmDelete(s.maSv),
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
//         tooltip: 'Thêm sinh viên mới',
//         backgroundColor: Color(0xFF003366),
//         child: const Icon(Icons.add, color: Colors.white,),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../models/student_model.dart';
import '../models/major_model.dart';
import '../services/student_service.dart';
import '../services/major_service.dart';

class StudentPage extends StatefulWidget {
  final VoidCallback onBack;
  const StudentPage({super.key, required this.onBack});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  List<Student> _students = [];
  List<MajorModel> _majors = [];

  final _maSvController = TextEditingController();
  final _hoTenController = TextEditingController();
  final _ngaySinhController = TextEditingController();
  final _searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  int? _selectedMajorId;
  String? _gioiTinh;
  bool isEditing = false;
  int? editingId;
  String? _formErrorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final students = await StudentService.fetchAll();
    final majors = await MajorService.fetchAllMajors();
    setState(() {
      _students = students;
      _majors = majors;
    });
  }

  void _showDetails(Student student) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
  'Thông tin chi tiết',
  style: TextStyle(
    color: Color(0xFF003366),
    fontWeight: FontWeight.bold,
  ),
),

        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mã SV: ${student.maSv}'),
            Text('Họ tên: ${student.hoTen}'),
            Text('Giới tính: ${student.gioiTinh}'),
            Text('Ngày sinh: ${student.ngaySinh}'),
            Text('Ngành học: ${student.tenNganh}'),
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

  void _showForm({Student? existing}) {
    if (existing != null) {
      _maSvController.text = existing.maSv;
      _hoTenController.text = existing.hoTen;
      _gioiTinh = existing.gioiTinh;
      _ngaySinhController.text = existing.ngaySinh;
      _selectedMajorId = existing.nganhId;
      editingId = existing.id;
      isEditing = true;
    } else {
      _maSvController.clear();
      _hoTenController.clear();
      _ngaySinhController.clear();
      _gioiTinh = null;
      _selectedMajorId = null;
      editingId = null;
      isEditing = false;
    }

    _formErrorMessage = null;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
         title: Text(
  isEditing ? 'Cập nhật sinh viên' : 'Thêm sinh viên',
  style: const TextStyle(
    color: Color(0xFF003366), // xanh đậm giống appBar
    fontWeight: FontWeight.bold,
  ),
),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: _maSvController,
                    enabled: !isEditing,
                    decoration: const InputDecoration(labelText: 'Mã SV'),
                    validator: (value) => (value == null || value.trim().isEmpty)
                        ? 'Vui lòng nhập mã sinh viên'
                        : null,
                  ),
                  TextFormField(
                    controller: _hoTenController,
                    decoration: const InputDecoration(labelText: 'Họ tên'),
                    validator: (value) => (value == null || value.trim().isEmpty)
                        ? 'Vui lòng nhập họ tên'
                        : null,
                  ),
                  DropdownButtonFormField<String>(
                    value: _gioiTinh,
                    decoration: const InputDecoration(labelText: 'Giới tính'),
                    items: ['Nam', 'Nữ'].map((gender) {
                      return DropdownMenuItem(value: gender, child: Text(gender));
                    }).toList(),
                    onChanged: (value) => setStateDialog(() => _gioiTinh = value),
                    validator: (value) => value == null ? 'Chọn giới tính' : null,
                  ),
                  TextFormField(
                    controller: _ngaySinhController,
                    readOnly: true,
                    decoration: const InputDecoration(labelText: 'Ngày sinh'),
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime(2000),
                        firstDate: DateTime(1950),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        _ngaySinhController.text = pickedDate.toIso8601String().substring(0, 10);
                      }
                    },
                    validator: (value) => (value == null || value.trim().isEmpty)
                        ? 'Chọn ngày sinh'
                        : null,
                  ),
                  DropdownButtonFormField<int>(
                    value: _majors.any((m) => m.id == _selectedMajorId) ? _selectedMajorId : null,
                    decoration: const InputDecoration(labelText: 'Ngành học'),
                    items: _majors.map((m) {
                      return DropdownMenuItem(value: m.id, child: Text(m.tenNganh));
                    }).toList(),
                    onChanged: (value) => setStateDialog(() => _selectedMajorId = value),
                    validator: (value) => value == null ? 'Chọn ngành học' : null,
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
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Thoát')),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final student = Student(
                    id: editingId ?? 0,
                    maSv: _maSvController.text.trim(),
                    hoTen: _hoTenController.text.trim(),
                    gioiTinh: _gioiTinh ?? '',
                    ngaySinh: _ngaySinhController.text.trim(),
                    nganhId: _selectedMajorId!,
                  );

                  final result = isEditing
                      ? await StudentService.update(student)
                      : await StudentService.add(student);

                  if (result['success']) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(result['message']), backgroundColor: Color(0xFF003366)),
                    );
                    _loadData();
                  } else {
                    setStateDialog(() {
                      _formErrorMessage = result['message'];
                    });
                  }
                }
              },
              child: Text(isEditing ? 'Cập nhật' : 'Thêm'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(String maSv) async {
    final confirmed = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
       title: const Text(
  'Xoá sinh viên',
  style: TextStyle(
    color: Color(0xFF003366),
    fontWeight: FontWeight.bold,
  ),
),

        content: const Text('Bạn có chắc chắn xoá sinh viên này?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Huỷ')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Xoá')),
        ],
      ),
    );
    if (confirmed == true) {
      final result = await StudentService.delete(maSv);
      if (result['success']) {
        _loadData();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message']), backgroundColor:Color(0xFF003366)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message']), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  void _searchStudent() async {
    final keyword = _searchController.text.trim();
    if (keyword.isEmpty) {
      _loadData();
    } else {
      final result = await StudentService.search(keyword);
      setState(() => _students = result);
      if (result.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không tìm thấy sinh viên phù hợp')),
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
          'Quản lý sinh viên',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
        actions: [],
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
                onSubmitted: (_) => _searchStudent(),
                decoration: InputDecoration(
                  hintText: 'Tìm mã sinh viên...',
                  prefixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    color: Color(0xFF003366),
                    onPressed: _searchStudent,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    color: Color(0xFF003366),
                    onPressed: () {
                      _searchController.clear();
                      _loadData();
                    },
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: _students.isEmpty
                ? const Center(child: Text('Không có dữ liệu'))
                : ListView.builder(
                    itemCount: _students.length,
                    itemBuilder: (context, index) {
                      final s = _students[index];
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          title: Text(s.hoTen, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          subtitle: Text('MSSV: ${s.maSv}\nNgành: ${s.tenNganh}'),
                          isThreeLine: true,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.info, color: Color(0xFF003366)),
                                tooltip: 'Xem chi tiết',
                                onPressed: () => _showDetails(s),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit, color: Color(0xFF003366)),
                                tooltip: 'Sửa',
                                onPressed: () => _showForm(existing: s),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Color(0xFF003366)),
                                tooltip: 'Xoá',
                                onPressed: () => _confirmDelete(s.maSv),
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
        tooltip: 'Thêm sinh viên mới',
        backgroundColor: Color(0xFF003366),
        child: const Icon(Icons.add, color: Colors.white,),
      ),
    );
  }
}
