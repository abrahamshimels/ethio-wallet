import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../controller/auth_controller.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final AuthController _authController = AuthController();
  bool _isLoading = false;
  bool _emailVerified = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _checkEmailVerified();

    // Optional: Poll every 5 seconds to auto-detect verification
    _timer = Timer.periodic(const Duration(seconds: 5), (_) async {
      await _checkEmailVerified();
    });
  }

  Future<void> _checkEmailVerified() async {
    await _authController.currentUser?.reload();
    final user = _authController.currentUser;

    if (user != null && user.emailVerified) {
      if (!mounted) return;
      _timer?.cancel();
      context.go('/home'); // Navigate to dashboard once verified
    } else {
      setState(() => _emailVerified = false);
    }
  }

  Future<void> _resendVerificationEmail() async {
    setState(() => _isLoading = true);
    try {
      final sent = await _authController.sendEmailVerification();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            sent
                ? 'Verification email sent! Check your inbox.'
                : 'Failed to send verification email.',
          ),
          backgroundColor: sent ? Colors.green : Colors.red,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _logout() async {
    await _authController.logout();
    if (!mounted) return;
    context.go('/sign-in');
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.email_outlined, size: 100, color: Colors.orange),
            const SizedBox(height: 24),
            const Text(
              'A verification email has been sent to your email address.\n'
              'Please check your inbox and click the verification link to continue.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const CircularProgressIndicator()
                : Column(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _resendVerificationEmail,
                        icon: const Icon(Icons.send),
                        label: const Text('Resend Email'),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: _checkEmailVerified,
                        icon: const Icon(Icons.refresh),
                        label: const Text('I have verified'),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: _logout,
                        child: const Text('Log out'),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
