// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import '../models/app_data.dart';
import 'dashboard_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _showPass = false;
  String? _errorMsg;

  void _login() {
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      setState(() => _errorMsg = 'Email dan password wajib diisi!');
      return;
    }

    final user = AppData.daftarUser.where(
      (u) => u.email == email && u.password == pass,
    ).toList();

    if (user.isEmpty) {
      setState(() => _errorMsg = 'Email atau password salah!');
      return;
    }

    AppData.namaUser = user.first.nama;
    AppData.emailUser = email;
    AppData.isLoggedIn = true;
    AppData.initDefaultData();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              // Logo & Title
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A6BFF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.account_balance_wallet,
                          color: Colors.white, size: 44),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'SiMu',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A6BFF),
                      ),
                    ),
                    const Text(
                      'Sistem Keuangan Mahasiswa',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              const Text('Masuk ke Akun',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Kelola keuanganmu lebih mudah 💙',
                  style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 28),

              // Error
              if (_errorMsg != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline,
                          color: Colors.red, size: 18),
                      const SizedBox(width: 8),
                      Text(_errorMsg!,
                          style: const TextStyle(color: Colors.red)),
                    ],
                  ),
                ),

              // Email
              _buildLabel('Email'),
              _buildTextField(
                controller: _emailCtrl,
                hint: 'contoh@email.com',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                onChanged: (_) => setState(() => _errorMsg = null),
              ),
              const SizedBox(height: 16),

              // Password
              _buildLabel('Password'),
              TextField(
                controller: _passCtrl,
                obscureText: !_showPass,
                onChanged: (_) => setState(() => _errorMsg = null),
                decoration: InputDecoration(
                  hintText: '••••••',
                  prefixIcon:
                      const Icon(Icons.lock_outline, color: Color(0xFF1A6BFF)),
                  suffixIcon: IconButton(
                    icon: Icon(
                        _showPass ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey),
                    onPressed: () => setState(() => _showPass = !_showPass),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: Color(0xFF1A6BFF), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Tombol Login
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A6BFF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 2,
                  ),
                  child: const Text('Masuk',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 20),

              // Register
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Belum punya akun? ',
                        style: TextStyle(color: Colors.grey)),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const RegisterScreen()),
                      ),
                      child: const Text(
                        'Daftar Sekarang',
                        style: TextStyle(
                          color: Color(0xFF1A6BFF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Info demo
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A6BFF).withOpacity(0.07),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('🔑 Akun Demo:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12)),
                    SizedBox(height: 4),
                    Text('Email: demo@simu.com',
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                    Text('Password: 123456',
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF1A6BFF)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: Color(0xFF1A6BFF), width: 2),
        ),
      ),
    );
  }
}