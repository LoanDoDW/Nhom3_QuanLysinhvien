import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/score_model.dart';
import '../models/subject_model.dart';

class ScoreService {
  static const String baseUrl = 'http://10.0.2.2/sv_api/scores';

  // Lấy danh sách điểm
  static Future<List<ScoreModel>> fetchAll() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/list.php'));
      if (res.statusCode == 200) {
        final body = json.decode(res.body);
        if (body['status'] == true) {
          final List data = body['data'];
          return data.map((e) => ScoreModel.fromJson(e)).toList();
        }
      }
    } catch (e) {
      print('❌ Lỗi fetchAll: $e');
    }
    return [];
  }

  // Thêm điểm
 static Future<Map<String, dynamic>> add(ScoreModel score) async {
  try {
    final res = await http.post(
      Uri.parse('$baseUrl/create.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'sinhvien_id': score.studentId,
        'monhoc_id': score.subjectId,
        'diem': score.diem,
      }),
    );

    final body = json.decode(res.body);
    return {
      'status': body['status'] == true,
      'message': body['message'] ?? 'Lỗi thêm điểm',
    };
  } catch (e) {
    return {'status': false, 'message': 'Lỗi kết nối'};
  }
}


  // Cập nhật điểm
 static Future<Map<String, dynamic>> update(ScoreModel score) async {
  try {
    final res = await http.post(
      Uri.parse('$baseUrl/update.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': score.id, 'diem': score.diem}), // Gửi đúng 2 trường
    );

    print("BODY: ${res.body}"); // In ra response để kiểm tra

    final body = json.decode(res.body);

    return {
      'status': body['status'] == true,
      'message': body['message'] ?? 'Lỗi cập nhật điểm',
    };
  } catch (e) {
    print("CATCH ERROR: $e");
    return {'status': false, 'message': 'Lỗi kết nối'};
  }
}



  // Xoá điểm
  static Future<Map<String, dynamic>> delete(int id) async {
  try {
    final res = await http.post(
      Uri.parse('$baseUrl/delete.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': id}),
    );

    final body = json.decode(res.body);
    return {
      'status': body['status'] == true,
      'message': body['message'] ?? 'Lỗi xoá điểm',
    };
  } catch (e) {
    return {'status': false, 'message': 'Lỗi kết nối: $e'};
  }
}

// 🔍 Tìm kiếm điểm theo mã sinh viên hoặc tên môn học
static Future<List<ScoreModel>> search(String keyword) async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/search.php?keyword=${Uri.encodeComponent(keyword)}'),
    );
    final body = json.decode(response.body);
    if (body['status'] == true) {
      return (body['data'] as List)
          .map((json) => ScoreModel.fromJson(json))
          .toList();
    }
    return [];
  } catch (e) {
    print('Lỗi khi tìm kiếm: $e');
    return [];
  }
}



  // ✅ Lấy danh sách môn học theo ngành (dựa theo bảng major_subject)
  static Future<List<SubjectModel>> fetchSubjectsByMajor(int nganhId) async {
    try {
      final res = await http.post(
        Uri.parse('http://10.0.2.2/sv_api/subject/subject_major.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'nganh_id': nganhId}),
      );
      final jsonRes = json.decode(res.body);
      if (jsonRes['status'] == true) {
        final List data = jsonRes['data'];
        return data.map((e) => SubjectModel.fromJson(e)).toList();
      }
    } catch (e) {
      print('❌ fetchSubjectsByMajor lỗi: $e');
    }
    return [];
  }
}
