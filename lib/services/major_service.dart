import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/major_model.dart';

class MajorService {
  static const String baseUrl = 'http://10.0.2.2/sv_api/major';

  // Lấy danh sách ngành
  static Future<List<MajorModel>> fetchAllMajors() async {
    final res = await http.get(Uri.parse('$baseUrl/list.php'));
    if (res.statusCode == 200) {
      final jsonRes = json.decode(res.body);
      if (jsonRes['status'] == true) {
        final List data = jsonRes['data'];
        return data.map((e) => MajorModel.fromJson(e)).toList();
      }
    }
    return [];
  }

  // Thêm ngành
  static Future<bool> addMajor(String maNganh, String tenNganh, List<int> subjectIds) async {
    final res = await http.post(
      Uri.parse('$baseUrl/create.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'ma_nganh': maNganh,
        'ten_nganh': tenNganh,
        'subject_ids': subjectIds,
      }),
    );
    final jsonRes = json.decode(res.body);
    return jsonRes['status'] == true;
  }

  // Cập nhật ngành
  static Future<bool> updateMajor(String maNganh, String tenNganh, List<int> subjectIds) async {
    final res = await http.post(
      Uri.parse('$baseUrl/update.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'ma_nganh': maNganh,
        'ten_nganh': tenNganh,
        'subject_ids': subjectIds,
      }),
    );
    final jsonRes = json.decode(res.body);
    return jsonRes['status'] == true;
  }

  // Xoá ngành
 static Future<bool> deleteMajor(String maNganh) async {
  final res = await http.post(
    Uri.parse('$baseUrl/delete.php'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'ma_nganh': maNganh}),
  );

  final jsonRes = json.decode(res.body);
  print('Xoá ngành $maNganh → Phản hồi: $jsonRes'); // 👈 debug tại đây

  return jsonRes['status'] == true;
}


  // Tìm ngành theo mã ngành
  static Future<List<MajorModel>> searchMajor(String keyword) async {
  try {
    final res = await http.post(
      Uri.parse('$baseUrl/search.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'keyword': keyword}),
    );

    if (res.statusCode == 200) {
      final jsonRes = json.decode(res.body);
      if (jsonRes['status'] == true) {
        final List data = jsonRes['data'];
        return data.map((e) => MajorModel.fromJson(e)).toList();
      }
    }
  } catch (e) {
    print('Lỗi tìm kiếm ngành: $e');
  }
  return [];
}

}
