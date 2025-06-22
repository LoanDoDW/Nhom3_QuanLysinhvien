import 'package:flutter/material.dart';
import '../services/user_service.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  final Map<String, dynamic> user;

  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Map<String, dynamic> userInfo;

  @override
  void initState() {
    super.initState();
    userInfo = Map<String, dynamic>.from(widget.user);
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Đăng xuất",
          style: TextStyle(
            color: Color(0xFF003366),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text("Bạn có chắc chắn muốn đăng xuất?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Huỷ"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
            child: const Text("Đăng xuất"),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final usernameController = TextEditingController(text: userInfo['username']);
    final contactController = TextEditingController(text: userInfo['contact']);
    final formKey = GlobalKey<FormState>();
    String? errorText;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text(
              "Thay đổi thông tin",
              style: TextStyle(
                color: Color(0xFF003366),
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: usernameController,
                    decoration: const InputDecoration(labelText: 'Tên đăng nhập mới'),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Vui lòng nhập tên đăng nhập' : null,
                  ),
                  TextFormField(
                    controller: contactController,
                    decoration: const InputDecoration(labelText: 'Email / Liên hệ mới'),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Vui lòng nhập liên hệ' : null,
                  ),
                  if (errorText != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        errorText!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Hủy"),
              ),
              TextButton(
                onPressed: () async {
                  if (!formKey.currentState!.validate()) return;

                  String newUsername = usernameController.text.trim();
                  String newContact = contactController.text.trim();
                  final result = await UserService.updateUserInfo(
                    id: int.parse(userInfo['id'].toString()),
                    username: newUsername,
                    contact: newContact,
                  );

                  if (result['status'] == true) {
                    setState(() {
                      userInfo['username'] = newUsername;
                      userInfo['contact'] = newContact;
                    });

                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Cập nhật thông tin thành công'),
                          backgroundColor: Color(0xFF003366),
                        ),
                      );
                    }
                  } else {
                    String msg = result['error'] ?? 'Lỗi không xác định';
                    if (msg.contains('Duplicate entry')) {
                      msg = 'Tên đăng nhập đã tồn tại';
                    }
                    setDialogState(() {
                      errorText = msg;
                    });
                  }
                },
                child: const Text("Lưu"),
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.account_circle, color: Colors.white),
        title: const Text(
          'Tài khoản',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF003366),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Đăng xuất',
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: const Color(0xFF003366),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "👤 Tên đăng nhập: ${userInfo['username']}",
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  "📧 Email / Liên hệ: ${userInfo['contact']}",
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () => _showEditDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF003366),
                  ),
                  icon: const Icon(Icons.edit),
                  label: const Text("Thay đổi thông tin"),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Tin tức',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildNewsCard(
                  image: 'assets/img/new1.jpg',
                  title: 'Công nghệ thông tin',
                  description:
                      'Đào tạo kỹ sư phần mềm, AI, lập trình web và ứng dụng di động. '
                      'Cơ hội làm việc tại các công ty công nghệ lớn trong và ngoài nước.',
                ),
                const SizedBox(height: 16),
                _buildNewsCard(
                  image: 'assets/img/new2.jpg',
                  title: 'Công nghệ bán dẫn',
                  description:
                      'Ngành học tiên phong trong lĩnh vực chip, vi mạch và thiết bị điện tử. '
                      'Cơ hội nghề nghiệp tại Samsung, Intel, và các tập đoàn lớn.',
                ),
                const SizedBox(height: 16),
                _buildNewsCard(
                  image: 'assets/img/new3.jpg',
                  title: 'Thiết kế đồ họa',
                  description:
                      'Trang bị kỹ năng thiết kế 2D, 3D, làm phim hoạt hình, thiết kế thương hiệu. '
                      'Học đi đôi với thực hành, định hướng sáng tạo.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCard({
    required String image,
    required String title,
    required String description,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 150,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(image, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(description),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
