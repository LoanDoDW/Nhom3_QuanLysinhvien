import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  static const String _baseUrl = 'http://10.0.2.2/sv_api/user';

  /// Cập nhật thông tin người dùng
static Future<Map<String, dynamic>> updateUserInfo({
    required int id,
    required String username,
    required String contact,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/update.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': id,
          'username': username,
          'contact': contact,
        }),
      );

      final data = jsonDecode(response.body);
      return data;
    } catch (e) {
      return {
        'status': false,
        'error': 'Lỗi kết nối: $e',
      };
    }
  }


  /// Đổi mật khẩu người dùng
  static Future<Map<String, dynamic>> changePassword({
  required int id,
  required String oldPassword,
  required String newPassword,
}) async {
  try {
    final response = await http.post(
      Uri.parse('$_baseUrl/update_password.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': id,
        'old_password': oldPassword,
        'new_password': newPassword,
      }),
    );

    print("🔍 Server trả về: ${response.body}");

    try {
      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'error': 'Phản hồi không hợp lệ từ server: ${response.body}',
      };
    }
  } catch (e) {
    return {
      'success': false,
      'error': 'Lỗi kết nối: $e',
    };
  }
}
}
