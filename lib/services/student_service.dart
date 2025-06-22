import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/student_model.dart';

class StudentService {
  static const String baseUrl = 'http://10.0.2.2/sv_api/student';

  static Future<List<Student>> fetchAll() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/list.php'));
      print("FetchAll Response: ${response.body}");
      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        if (body['status'] == true || body['success'] == true) {
          final List data = body['data'];
          return data.map((e) => Student.fromJson(e)).toList();
        }
      }
    } catch (e) {
      print("Lỗi fetchAll: $e");
    }
    return [];
  }

  static Future<Map<String, dynamic>> add(Student sv) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/create.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(sv.toJson()),
    );

    print("💡 Add Response: ${response.body}");

    // Check status code trước
    if (response.statusCode == 200) {
      final body = json.decode(response.body);

      return {
        'success': body['status'] == true || body['success'] == true,
        'message': body['message'] ?? 'Không rõ thông báo',
      };
    } else {
      // Server trả lỗi HTTP
      return {
        'success': false,
        'message': 'Lỗi server: ${response.statusCode}',
      };
    }
  } catch (e) {
    // Chỉ lỗi nếu mạng chết hoặc JSON lỗi hẳn
    print("Lỗi kết nối hoặc phân tích JSON: $e");
    return {
      'success': false,
      'message': 'Lỗi khi kết nối hoặc xử lý dữ liệu từ server',
    };
  }
}


  static Future<Map<String, dynamic>> update(Student sv) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/update.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(sv.toJson()),
      );

      print("Update Response: ${response.body}");
      final body = json.decode(response.body);
      return {
        'success': body['success'] == true || body['status'] == true,
        'message': body['message'] ?? 'Lỗi khi cập nhật sinh viên',
      };
    } catch (e) {
      print("Lỗi khi cập nhật sinh viên: $e");
      return {
        'success': false,
        'message': 'Lỗi khi kết nối hoặc xử lý dữ liệu từ server',
      };
    }
  }

  static Future<Map<String, dynamic>> delete(String maSv) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/delete.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'ma_sv': maSv}),
      );

      print("Delete Response: ${response.body}");
      final body = json.decode(response.body);
      return {
        'success': body['success'] == true || body['status'] == true,
        'message': body['message'] ?? 'Lỗi khi xoá sinh viên',
      };
    } catch (e) {
      print("Lỗi khi xoá sinh viên: $e");
      return {
        'success': false,
        'message': 'Lỗi khi kết nối hoặc xử lý dữ liệu từ server',
      };
    }
  }

  static Future<List<Student>> search(String maSv) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/search.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'ma_sv': maSv}), // ✅ sửa lại đúng key
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      if (body['success'] == true) {
        final List data = body['data'];
        return data.map((e) => Student.fromJson(e)).toList();
      }
    }
  } catch (e) {
    print("Lỗi khi tìm kiếm sinh viên: $e");
  }
  return [];
}

}
