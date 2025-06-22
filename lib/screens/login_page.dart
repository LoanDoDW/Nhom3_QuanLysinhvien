import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isHidden = true;
  bool isLoading = false;

  String? usernameError;
  String? passwordError;

  void handleLogin() async {
    setState(() {
      usernameError = null;
      passwordError = null;
    });

    final username = usernameController.text.trim();
    final password = passwordController.text;

    bool hasError = false;

    if (username.isEmpty) {
      usernameError = "Vui lòng nhập tên đăng nhập";
      hasError = true;
    }

    if (password.isEmpty) {
      passwordError = "Vui lòng nhập mật khẩu";
      hasError = true;
    }

    if (hasError) {
      setState(() {});
      return;
    }

    setState(() {
      isLoading = true;
    });

    final response = await AuthService.login(username, password);

    setState(() {
      isLoading = false;
    });

    if (response['success']) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Đăng nhập thành công")));
      // TODO: Chuyển sang trang chính
      Navigator.pushReplacementNamed(
    context,
    "/main",
    arguments: response['user'],
  );
    } else {
      // Gán lỗi đúng chỗ dựa vào response['error']
      setState(() {
        if (response['error'] == 'username') {
          usernameError = response['message'];
        } else if (response['error'] == 'password') {
          passwordError = response['message'];
        } else {
          // fallback lỗi chung
          passwordError = response['message'] ?? "Đăng nhập thất bại";
        }
      });
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // const Text(
              //   "ĐĂNG NHẬP",
              //   style: TextStyle(
              //     fontSize: 28,
              //     fontWeight: FontWeight.bold,
              //     color:  Color(0xFF003366),
              //   ),
              // ),
              Image.asset(
                   'assets/img/logo.png', // Đảm bảo file này đã được khai báo trong pubspec.yaml
                   height: 150,
             ),
              const SizedBox(height: 10),
              const Text(
                "EduHPC",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003366),
                ),
              ),
              const SizedBox(height: 30),

              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  hintText: "Tên đăng nhập",
                  prefixIcon: const Icon(Icons.person),
                  errorText: usernameError,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: passwordController,
                obscureText: isHidden,
                decoration: InputDecoration(
                  hintText: "Nhập mật khẩu",
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isHidden ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        isHidden = !isHidden;
                      });
                    },
                  ),
                  errorText: passwordError,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Quên mật khẩu?",
                    style: TextStyle(color:  Color(0xFF003366)),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:  Color(0xFF003366),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child:
                      isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            "Đăng nhập",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Chưa có tài khoản? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/register");
                    },
                    child: const Text(
                      "Đăng kí",
                      style: TextStyle(
                        color: Color(0xFF003366),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
