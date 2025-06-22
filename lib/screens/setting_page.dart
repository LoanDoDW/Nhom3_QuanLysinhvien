import 'package:flutter/material.dart';
import '../services/user_service.dart';

class SettingPage extends StatefulWidget {
  final int userId;
  const SettingPage({super.key, required this.userId});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'Tiếng Việt';
  bool _isDarkMode = false;

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (_) => SimpleDialog(
        title: const Text('Chọn ngôn ngữ'),
        children: [
          SimpleDialogOption(
            onPressed: () {
              setState(() => _selectedLanguage = 'Tiếng Việt');
              Navigator.pop(context);
            },
            child: const Text('Tiếng Việt'),
          ),
          SimpleDialogOption(
            onPressed: () {
              setState(() => _selectedLanguage = 'English');
              Navigator.pop(context);
            },
            child: const Text('English'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    final oldController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    bool showOld = false;
    bool showNew = false;
    bool showConfirm = false;
    String? errorText;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text(
            "Đổi mật khẩu",
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
                  controller: oldController,
                  obscureText: !showOld,
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu hiện tại',
                    suffixIcon: IconButton(
                      icon: Icon(showOld ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setDialogState(() => showOld = !showOld),
                    ),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Nhập mật khẩu hiện tại' : null,
                ),
                TextFormField(
                  controller: newController,
                  obscureText: !showNew,
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu mới',
                    suffixIcon: IconButton(
                      icon: Icon(showNew ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setDialogState(() => showNew = !showNew),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Nhập mật khẩu mới';
                    if (value.length < 6) return 'Ít nhất 6 ký tự';
                    return null;
                  },
                ),
                TextFormField(
                  controller: confirmController,
                  obscureText: !showConfirm,
                  decoration: InputDecoration(
                    labelText: 'Xác nhận mật khẩu mới',
                    suffixIcon: IconButton(
                      icon: Icon(showConfirm ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setDialogState(() => showConfirm = !showConfirm),
                    ),
                  ),
                  validator: (value) {
                    if (value != newController.text) return 'Mật khẩu không khớp';
                    return null;
                  },
                ),
                if (errorText != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(errorText!, style: const TextStyle(color: Colors.red)),
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

                final oldPass = oldController.text.trim();
                final newPass = newController.text.trim();

                final response = await UserService.changePassword(
                  id: widget.userId,
                  oldPassword: oldPass,
                  newPassword: newPass,
                );

                if (response['success'] == true) {
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(' Đổi mật khẩu thành công'),
                        backgroundColor: Color(0xFF003366),
                      ),
                    );
                  }
                } else {
                  setDialogState(() {
                    errorText = response['error'] ?? 'Đổi mật khẩu thất bại';
                  });
                }
              },
              child: const Text("Lưu"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.1),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt'),
        backgroundColor: const Color(0xFF003366),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _buildSettingItem(
            icon: Icons.notifications,
            iconColor: Colors.deepPurple,
            title: 'Thông báo',
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: (val) => setState(() => _notificationsEnabled = val),
              activeColor: const Color(0xFF003366),
            ),
          ),
          _buildSettingItem(
            icon: Icons.language,
            iconColor: Colors.green,
            title: 'Ngôn ngữ',
            subtitle: _selectedLanguage,
            onTap: _showLanguageDialog,
          ),
          _buildSettingItem(
            icon: Icons.dark_mode,
            iconColor: Colors.orange,
            title: 'Giao diện tối',
            trailing: Switch(
              value: _isDarkMode,
              onChanged: (val) => setState(() => _isDarkMode = val),
              activeColor: const Color(0xFF003366),
            ),
          ),
          _buildSettingItem(
            icon: Icons.lock,
            iconColor: Colors.redAccent,
            title: 'Đổi mật khẩu',
            onTap: _showChangePasswordDialog,
          ),
          _buildSettingItem(
            icon: Icons.info_outline,
            iconColor: Colors.blue,
            title: 'Giới thiệu ứng dụng',
            subtitle: 'Phiên bản 1.0.0',
            onTap: () => showAboutDialog(
              context: context,
              applicationName: 'Quản lý sinh viên',
              applicationVersion: '1.0.0',
              applicationLegalese: '© 2025 Trường CĐ Công nghệ Bách khoa Hà Nội',
            ),
          ),
        ],
      ),
    );
  }
}
