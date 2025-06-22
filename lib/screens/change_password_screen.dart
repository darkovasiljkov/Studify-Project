import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();

  bool isLoading = false;
  final _auth = FirebaseAuth.instance;

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final user = _auth.currentUser;
      final email = user?.email;

      final cred = EmailAuthProvider.credential(
        email: email!,
        password: currentPasswordController.text.trim(),
      );

      await user!.reauthenticateWithCredential(cred);

      if (newPasswordController.text.trim() != confirmNewPasswordController.text.trim()) {
        throw FirebaseAuthException(code: 'password-mismatch', message: 'New passwords do not match.');
      }

      await user.updatePassword(newPasswordController.text.trim());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password updated successfully')),
      );

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'wrong-password') {
        message = 'Current password is incorrect.';
      } else if (e.code == 'password-mismatch') {
        message = 'New passwords do not match.';
      } else {
        message = e.message ?? 'Password update failed.';
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget _buildPasswordField(
      {required String label, required TextEditingController controller, required String? Function(String?) validator}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: true,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Change Password')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Icon(Icons.lock_outline, size: 80, color: Colors.indigo),
                SizedBox(height: 16),
                Text("Securely update your password", style: TextStyle(fontSize: 18)),
                SizedBox(height: 24),
                _buildPasswordField(
                  label: 'Current Password',
                  controller: currentPasswordController,
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Enter your current password' : null,
                ),
                _buildPasswordField(
                  label: 'New Password',
                  controller: newPasswordController,
                  validator: (value) =>
                  value != null && value.length >= 6 ? null : 'Minimum 6 characters required',
                ),
                _buildPasswordField(
                  label: 'Confirm New Password',
                  controller: confirmNewPasswordController,
                  validator: (value) =>
                  value != newPasswordController.text ? 'Passwords do not match' : null,
                ),
                SizedBox(height: 30),
                isLoading
                    ? CircularProgressIndicator()
                    : SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _changePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Update Password', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
