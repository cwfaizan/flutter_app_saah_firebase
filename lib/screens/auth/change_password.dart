import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool _isObscure = true;
  bool _isObscureConfirm = true;
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _changePassword() async {
    bool isValid = _form.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    await FirebaseAuth.instance.currentUser
        ?.updatePassword(_passwordController.text.trim())
        .then((_) {
      _passwordController.clear();
      _confirmPasswordController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully changed password'),
        ),
      );
    }).catchError(
      (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Password can't be changed" + error.toString()),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 8.0),
              TextFormField(
                obscureText: _isObscure,
                controller: _passwordController,
                // keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.key),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null) {
                    return null;
                  }
                  if (value.isEmpty) {
                    return 'Password is required!';
                  }
                  if (!RegExp(r'^((?=.*\d)(?=.*[A-Z])(?=.*\W).{8,8})$')
                      .hasMatch(value)) {
                    return 'Password must be 8 characters including 1 uppercase letter, 1 special character, alphanumeric characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                obscureText: _isObscureConfirm,
                controller: _confirmPasswordController,
                // keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: const Icon(Icons.key),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscureConfirm
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscureConfirm = !_isObscureConfirm;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null) {
                    return null;
                  }
                  if (value.isEmpty) {
                    return 'Password is required!';
                  }
                  if (!RegExp(r'^((?=.*\d)(?=.*[A-Z])(?=.*\W).{8,8})$')
                      .hasMatch(value)) {
                    return 'Password must be 8 characters including 1 uppercase letter, 1 special character, alphanumeric characters';
                  }
                  if (value != _passwordController.text) {
                    return 'Confirm Password didnt match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: _changePassword,
                child: const Text('Change'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
