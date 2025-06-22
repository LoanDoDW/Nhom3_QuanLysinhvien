// class ScoreModel {
//   final int id;
//   final int studentId;
//   final String studentName;
//   final int subjectId;
//   final String subjectName;
//   final double diem;

//   ScoreModel({
//     required this.id,
//     required this.studentId,
//     required this.studentName,
//     required this.subjectId,
//     required this.subjectName,
//     required this.diem,
//   });

//   factory ScoreModel.fromJson(Map<String, dynamic> json) {
//     return ScoreModel(
//       id: int.tryParse(json['id'].toString()) ?? 0,
//       studentId: int.tryParse(json['sinhvien_id'].toString()) ?? 0,
//       studentName: json['ten_sv'] ?? '',
//       subjectId: int.tryParse(json['monhoc_id'].toString()) ?? 0,
//       subjectName: json['ten_mon'] ?? '',
//       diem: double.tryParse(json['diem'].toString()) ?? 0.0,
//     );
//   }

//   Map<String, dynamic> toJson({bool includeId = false}) {
//     final data = {
//       'sinhvien_id': studentId,
//       'monhoc_id': subjectId,
//       'diem': diem,
//     };
//     if (includeId) data['id'] = id;
//     return data;
//   }
// }
class ScoreModel {
  final int id;
  final int studentId;
  final String studentCode;   // Mã sinh viên (ma_sv)
  final String studentName;   // Họ tên sinh viên (ho_ten)
  final int subjectId;
  final String subjectName;
  final double diem;

  ScoreModel({
    required this.id,
    required this.studentId,
    required this.studentCode,
    required this.studentName,
    required this.subjectId,
    required this.subjectName,
    required this.diem,
  });

  factory ScoreModel.fromJson(Map<String, dynamic> json) {
    return ScoreModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      studentId: int.tryParse(json['student_id'].toString()) ?? 0,
      studentCode: json['ma_sv'] ?? '',
      studentName: json['ho_ten'] ?? '',
      subjectId: int.tryParse(json['subject_id'].toString()) ?? 0,
      subjectName: json['ten_mon'] ?? '',
      diem: double.tryParse(json['diem'].toString()) ?? 0.0,
    );
  }

  Map<String, dynamic> toJson({bool includeId = false}) {
    final data = {
      'sinhvien_id': studentId,
      'monhoc_id': subjectId,
      'diem': diem,
    };
    if (includeId) data['id'] = id;
    return data;
  }
}

