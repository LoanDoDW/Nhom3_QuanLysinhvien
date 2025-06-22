import 'package:flutter/material.dart';
import '../models/major_model.dart';
import '../models/subject_model.dart';
import '../services/major_service.dart';
import '../services/subject_service.dart';

class MajorPage extends StatefulWidget {
  final VoidCallback onBack;
  const MajorPage({super.key, required this.onBack});

  @override
  State<MajorPage> createState() => _MajorPageState();
}

class _MajorPageState extends State<MajorPage> {
  List<MajorModel> _majors = [];
  List<SubjectModel> _allSubjects = [];
  Set<int> _selectedSubjectIds = {};
  final _maNganhController = TextEditingController();
  final _tenNganhController = TextEditingController();
  final _searchController = TextEditingController();
  bool isEditing = false;
  String? editingMa;
  String? _formErrorMessage;

  @override
  void initState() {
    super.initState();
    _loadInitData();
  }

  Future<void> _loadInitData() async {
    await _loadAllSubjects();
    await _loadMajors();
  }

  Future<void> _loadMajors() async {
    _majors = await MajorService.fetchAllMajors();
    setState(() {});
  }

  Future<void> _loadAllSubjects() async {
    _allSubjects = await SubjectService.fetchAll();
    setState(() {});
  }

  Future<void> _searchMajor() async {
    final keyword = _searchController.text.trim();
    if (keyword.isEmpty) {
      _loadMajors();
      return;
    }

    final results = await MajorService.searchMajor(keyword);
    setState(() => _majors = results);
    if (results.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không tìm thấy ngành phù hợp')),
      );
    }
  }

  void _showForm({MajorModel? existing}) {
    if (existing != null) {
      isEditing = true;
      editingMa = existing.maNganh;
      _maNganhController.text = existing.maNganh;
      _tenNganhController.text = existing.tenNganh;
      _selectedSubjectIds = existing.subjectIds.toSet();
    } else {
      isEditing = false;
      editingMa = null;
      _maNganhController.clear();
      _tenNganhController.clear();
      _selectedSubjectIds.clear();
    }

    _formErrorMessage = null;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text(
              isEditing ? 'Cập nhật ngành' : 'Thêm ngành',
              style: const TextStyle(
                color: Color(0xFF003366),
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: _maNganhController,
                      enabled: !isEditing,
                      decoration: const InputDecoration(labelText: 'Mã ngành'),
                    ),
                    TextField(
                      controller: _tenNganhController,
                      decoration: const InputDecoration(labelText: 'Tên ngành'),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Chọn môn học cho ngành:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ..._allSubjects.map((subj) {
                      return CheckboxListTile(
                        value: _selectedSubjectIds.contains(subj.id),
                        title: Text('${subj.maMon} - ${subj.tenMon}'),
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (checked) {
                          setDialogState(() {
                            if (checked == true) {
                              _selectedSubjectIds.add(subj.id);
                            } else {
                              _selectedSubjectIds.remove(subj.id);
                            }
                          });
                        },
                      );
                    }).toList(),
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
                            Expanded(
                              child: Text(
                                _formErrorMessage!,
                                style: const TextStyle(
                                    color: Colors.red, fontWeight: FontWeight.w600),
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
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Huỷ')),
              ElevatedButton(
                onPressed: () async {
                  final ma = _maNganhController.text.trim();
                  final ten = _tenNganhController.text.trim();
                  final subjectIds = _selectedSubjectIds.toList();

                  if (ma.isEmpty || ten.isEmpty || subjectIds.isEmpty) {
                    setDialogState(() {
                      _formErrorMessage = 'Vui lòng nhập đầy đủ thông tin và chọn môn học';
                    });
                    return;
                  }

                  if (!isEditing) {
                    final exists = _majors.any((m) => m.maNganh == ma);
                    if (exists) {
                      setDialogState(() {
                        _formErrorMessage = 'Mã ngành đã tồn tại';
                      });
                      return;
                    }
                  }

                  final success = isEditing
                      ? await MajorService.updateMajor(ma, ten, subjectIds)
                      : await MajorService.addMajor(ma, ten, subjectIds);

                  if (success) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isEditing
                            ? 'Cập nhật thành công'
                            : 'Thêm thành công'),
                        backgroundColor: Color(0xFF003366),
                      ),
                    );
                    _loadMajors();
                  } else {
                    setDialogState(() {
                      _formErrorMessage = 'Thao tác thất bại';
                    });
                  }
                },
                child: Text(isEditing ? 'Cập nhật' : 'Thêm'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _confirmDelete(String ma) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          'Xoá ngành',
          style: TextStyle(
            color: Color(0xFF003366),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text('Bạn có chắc muốn xoá ngành này không?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Huỷ')),
          ElevatedButton(
            onPressed: () async {
              final ok = await MajorService.deleteMajor(ma);
              Navigator.pop(context);
              if (ok) {
                await _loadMajors();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Xoá thành công'), backgroundColor: Color(0xFF003366) ),
                );
              }
            },
            child: const Text('Xoá'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF003366),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Quản lý ngành học',
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
                onSubmitted: (_) => _searchMajor(),
                decoration: InputDecoration(
                  hintText: 'Tìm mã ngành...',
                  prefixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    color: Color(0xFF003366),
                    onPressed: _searchMajor,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    color: Color(0xFF003366),
                    onPressed: () {
                      _searchController.clear();
                      _loadMajors();
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
            child: _majors.isEmpty
                ? const Center(child: Text('Không có ngành học'))
                : ListView.builder(
                    itemCount: _majors.length,
                    itemBuilder: (_, i) {
                      final major = _majors[i];
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          title: Text(
                            major.tenNganh,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          onTap: () {
                            final subjectList = major.subjectIds.map((id) {
                              final subj = _allSubjects.firstWhere(
                                (s) => s.id == id,
                                orElse: () => SubjectModel(id: id, maMon: '???', tenMon: 'Không rõ', soTinChi: 0),
                              );
                              return '${subj.maMon} - ${subj.tenMon}';
                            }).toList();

                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text(
                                  'Thông tin ngành',
                                  style: TextStyle(
                                    color: Color(0xFF003366),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                content: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Mã ngành: ${major.maNganh}'),
                                      const SizedBox(height: 8),
                                      Text('Tên ngành: ${major.tenNganh}'),
                                      const SizedBox(height: 8),
                                      const Text('Danh sách môn học:', style: TextStyle(fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 6),
                                      ...subjectList.map((mon) => Text('• $mon')),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Trở về'),
                                  ),
                                ],
                              ),
                            );
                          },
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Color(0xFF003366)),
                                onPressed: () => _showForm(existing: major),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Color(0xFF003366)),
                                onPressed: () => _confirmDelete(major.maNganh),
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
        tooltip: 'Thêm ngành học mới',
        backgroundColor: Color(0xFF003366),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
