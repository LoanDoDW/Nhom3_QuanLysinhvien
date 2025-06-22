// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../models/class_model.dart'; // ✅ Thêm dòng này

// class ClassService {
//   static const String baseUrl = 'http://10.0.2.2/sv_api/class';

//   static Future<List<ClassModel>> fetchAllClasses() async {
//     final response = await http.get(Uri.parse('$baseUrl/list.php'));
//     print('>>> Fetch response: ${response.body}');
//     if (response.statusCode == 200) {
//       final body = json.decode(response.body);
//       if (body['status'] == true) {
//         return (body['data'] as List)
//             .map((e) => ClassModel.fromJson(e))
//             .toList();
//       }
//     }
//     return [];
//   }

//   static Future<bool> addClass(String maLop, String tenLop) async {
//     print('>>> Gửi API thêm lớp: $maLop - $tenLop');
//     final response = await http.post(
//       Uri.parse('$baseUrl/create.php'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'ma_lop': maLop, 'ten_lop': tenLop}),
//     );
//     print('>>> Phản hồi từ server: ${response.body}');
//     final data = json.decode(response.body);
//     return data['status'] == true;
//   }

//   static Future<bool> updateClass(String maLop, String tenLop) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/update.php'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'ma_lop': maLop, 'ten_lop': tenLop}),
//     );
//     print('>>> Update response: ${response.body}');
//     final data = json.decode(response.body);
//     return data['status'] == true;
//   }

//   static Future<bool> deleteClass(String maLop) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/delete.php'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'ma_lop': maLop}),
//     );
//     print('>>> Delete response: ${response.body}');
//     final data = json.decode(response.body);
//     return data['status'] == true;
//   }

//   static Future<List<ClassModel>> searchClassByMaLop(String maLop) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/search.php'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'ma_lop': maLop}),
//     );
//     print('>>> Search response: ${response.body}');
//     if (response.statusCode == 200) {
//       final body = json.decode(response.body);
//       if (body['status'] == true) {
//         return (body['data'] as List)
//             .map((e) => ClassModel.fromJson(e))
//             .toList();
//       }
//     }
//     return [];
//   }
// }
