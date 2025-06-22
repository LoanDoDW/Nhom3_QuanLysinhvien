import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/subject_model.dart';

class SubjectService {
  static const String baseUrl = 'http://10.0.2.2/sv_api/subject';

  // LẤY DANH SÁCH MÔN HỌC
  static Future<List<SubjectModel>> fetchAll() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/list.php'));
      if (response.statusCode == 200) {
        final jsonRes = json.decode(response.body);
        if (jsonRes['status'] == true) {
          final List data = jsonRes['data'];
          return data.map((e) => SubjectModel.fromJson(e)).toList();
        } else {
          print('❌ Server error: ${jsonRes['message']}');
        }
      } else {
        print('❌ HTTP status: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ fetchAll Exception: $e');
    }
    return [];
  }

  // THÊM MÔN HỌC
 static Future<Map<String, dynamic>> addSubjectWithMessage(String maMon, String tenMon, int soTinChi) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/create.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'ma_mon': maMon,
        'ten_mon': tenMon,
        'so_tin_chi': soTinChi,
      }),
    );

    print('📥 Raw Response Body: "${response.body}"'); // debug rõ ràng

    final jsonRes = json.decode(response.body);
    return {
      'success': jsonRes['status'] == true,
      'message': jsonRes['message'] ?? 'Lỗi không xác định',
    };
  } catch (e) {
    print('❌ addSubjectWithMessage Exception: $e');
    return {
      'success': false,
      'message': 'Lỗi kết nối hoặc phân tích dữ liệu từ server',
    };
  }
}





  // CẬP NHẬT MÔN HỌC
  static Future<Map<String, dynamic>> updateSubject(String maMon, String tenMon, int soTinChi) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/update.php'),
      body: jsonEncode({
        'ma_mon': maMon,
        'ten_mon': tenMon,
        'so_tin_chi': soTinChi,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    final jsonRes = json.decode(response.body);
    print('✅ UPDATE RESPONSE: $jsonRes');
    return {
      'success': jsonRes['status'] == true,
      'message': jsonRes['message'] ?? 'Lỗi không xác định',
    };
  } catch (e) {
    print('❌ updateSubject Exception: $e');
    return {
      'success': false,
      'message': 'Lỗi kết nối máy chủ',
    };
  }
}


  // XOÁ MÔN HỌC
  static Future<bool> deleteSubject(String maMon) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/delete.php'),
        body: jsonEncode({'ma_mon': maMon}),
        headers: {'Content-Type': 'application/json'},
      );
      final jsonRes = json.decode(response.body);
      print('✅ DELETE RESPONSE: $jsonRes');
      return jsonRes['status'] == true;
    } catch (e) {
      print('❌ deleteSubject Exception: $e');
      return false;
    }
  }

  // TÌM KIẾM MÔN HỌC
  static Future<List<SubjectModel>> searchSubjectByMaMon(String keyword) async {
  final response = await http.post(
    Uri.parse('$baseUrl/search.php'),
    body: jsonEncode({'ma_mon': keyword}), // ← Đúng với PHP backend
    headers: {'Content-Type': 'application/json'},
  );

  print('🔍 Kết quả từ API search: ${response.body}');

  if (response.statusCode == 200) {
    final jsonRes = json.decode(response.body);
    if (jsonRes['status'] == true) {
      final List data = jsonRes['data'];
      return data.map((e) => SubjectModel.fromJson(e)).toList();
    }
  }

  return [];
}

  // LẤY DANH SÁCH SINH VIÊN THEO MÔN HỌC
static Future<List<Map<String, String>>> fetchStudentsBySubject(String maMon) async {
  final response = await http.post(
    Uri.parse('http://10.0.2.2/sv_api/subject/student_subject.php'), // <-- đúng đường dẫn
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'ma_mon': maMon}),
  );

  final jsonRes = json.decode(response.body);
  if (jsonRes['status'] == true) {
    final List data = jsonRes['data'];
    return data.map<Map<String, String>>((e) {
      return {
        'ma_sv': e['ma_sv'] ?? '',
        'ten_sv': e['ho_ten'] ?? '',
      };
    }).toList();
  }

  return [];
}

static Future<List<SubjectModel>> fetchByMajorId(int majorId) async {
  try {
    final res = await http.post(
      Uri.parse('http://10.0.2.2/sv_api/subject/subject_major.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'nganh_id': majorId}),
    );

    final body = json.decode(res.body);
    if (body['status'] == true) {
      final List data = body['data'];
      return data.map((e) => SubjectModel.fromJson(e)).toList();
    } else {
      print('Lỗi từ server: ${body['message']}');
    }
  } catch (e) {
    print('Lỗi fetchByMajorId: $e');
  }
  return [];
}


}
