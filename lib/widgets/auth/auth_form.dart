import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:saah/screens/tab_screen.dart';
import 'package:saah/utils/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthForm extends StatefulWidget {
  const AuthForm(this.submitAuthForm, {Key? key}) : super(key: key);

  final void Function(
    TextEditingController emailController,
    TextEditingController phoneController,
    TextEditingController nameController,
    TextEditingController dobController,
    TextEditingController passwordController,
    String gender,
    bool isLogin,
  ) submitAuthForm;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

enum Gender { male, female }

class _AuthFormState extends State<AuthForm> {
  Gender _gender = Gender.male;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _passwordController = TextEditingController();
  var _isLogin = true;
  bool _isObscure = true;

  void _submitForm() {
    var isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    widget.submitAuthForm(
      _emailController,
      _phoneController,
      _nameController,
      _dobController,
      _passwordController,
      _gender == Gender.male ? 'Male' : 'Female',
      _isLogin,
    );
  }

  Future _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
    );
    setState(
      () => _dobController.text = DateFormat("yyyy-MM-dd").format(picked!),
    );
  }

  Widget googleButton() {
    final deviceSize = MediaQuery.of(context).size;
    return InkWell(
      child: Container(
          width: deviceSize.width / 2,
          height: deviceSize.height / 18,
          margin: const EdgeInsets.only(top: 25),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).primaryColor),
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                _isLogin ? 'Sign-in with' : 'Sign-up with',
                style: const TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                height: 30.0,
                width: 30.0,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/google_logo.png'),
                    fit: BoxFit.cover,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ))),
      onTap: () async {
        googleLogin();
      },
    );
  }

  googleLogin() async {
    GoogleSignIn _googleSignIn = GoogleSignIn();
    try {
      var reslut = await _googleSignIn.signIn();
      if (reslut == null) {
        return;
      }

      final userData = await reslut.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: userData.accessToken, idToken: userData.idToken);
      await FirebaseAuth.instance.signInWithCredential(credential);
      // print("Result $reslut");
      // print(reslut.displayName);
      // print(reslut.email);
      // print(reslut.photoUrl);
      SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setString('auth_user_name', reslut.displayName!);
      sp.setString('auth_user_email', reslut.email);
      sp.setBool('google_login', true);
      sp.setBool('auth_user_is_admin', false);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const TabScreen(),
        ),
      );
    } catch (error) {
      print(error);
    }
  }

  // Future<void> logout() async {
  //   await GoogleSignIn().disconnect();
  //   FirebaseAuth.instance.signOut();
  // }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _isLogin ? 'Sign In' : 'Sign Up',
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email),
                ),
                // onSaved: (value) {
                //   _userEmail = value ?? '';
                // },
                validator: (value) {
                  if (value == null) {
                    return null;
                  }
                  if (value.isEmpty) {
                    return 'Email is required!';
                  }
                  if (!value.contains('@') || value.length < 6) {
                    return 'Invalid Email';
                  }
                  return null;
                },
              ),
              if (!_isLogin) const SizedBox(height: 8.0),
              if (!_isLogin)
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: '+966#########',
                    prefixIcon: Icon(Icons.phone),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return null;
                    }
                    if (value.isEmpty) {
                      return 'Phone no is required!';
                    }
                    return null;
                  },
                ),
              if (!_isLogin) const SizedBox(height: 8.0),
              if (!_isLogin)
                TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return null;
                    }
                    if (value.isEmpty) {
                      return 'Name is required!';
                    }
                    return null;
                  },
                ),
              if (!_isLogin) const SizedBox(height: 8.0),
              if (!_isLogin)
                TextFormField(
                  controller: _dobController,
                  keyboardType: TextInputType.phone,
                  autocorrect: false,
                  onTap: () {
                    _selectDate();
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Date of Birth',
                    prefixIcon: Icon(Icons.cake),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return null;
                    }
                    if (value.isEmpty) {
                      return 'DOB is required!';
                    }
                    return null;
                  },
                ),
              if (!_isLogin) const SizedBox(height: 8.0),
              if (!_isLogin)
                Row(
                  children: [
                    const Text('Gender'),
                    Expanded(
                      child: ListTile(
                        title: const Text('Male'),
                        leading: Radio<Gender>(
                          value: Gender.male,
                          groupValue: _gender,
                          onChanged: (value) {
                            setState(() {
                              _gender = value!;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: const Text('Female'),
                        leading: Radio<Gender>(
                          value: Gender.female,
                          groupValue: _gender,
                          onChanged: (value) {
                            setState(() {
                              _gender = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
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
                  if (!RegExp(
                          r'(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@#$!%*?&])[A-Za-z\d@#$!%*?&]{8,8}')
                      .hasMatch(value.trim())) {
                    if (_isLogin) return 'Wrong Password!';
                    return 'Password must be 8 characters including 1 uppercase letter, 1 special character, alphanumeric characters';
                  }
                  return null;
                },
              ),
              if (_isLogin) const SizedBox(height: 20),
              if (_isLogin)
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.forgetPasswordScreen);
                  },
                  child: const Text('Forget Password'),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(_isLogin ? 'Sign-In' : 'Signup'),
              ),
              // ElevatedButton.icon(
              //   onPressed: _submitForm,
              //   label: const Text('Sign-in with Google'),
              //   icon: Icon(Icons.key),
              // ),
              googleButton(),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isLogin = !_isLogin;
                  });
                },
                child: Text(_isLogin ? 'New user? Sign-up' : 'Sign-In?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
