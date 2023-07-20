import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm(this.submitAuthForm, {Key? key}) : super(key: key);

  final void Function(
    String email,
    String phone,
    String name,
    String dob,
    String gender,
    String password,
    bool isLogin,
  ) submitAuthForm;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

enum Gender { male, female }

class _AuthFormState extends State<AuthForm> {
  Gender _gender = Gender.male;
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userPhone = '';
  var _userName = '';
  var _userDOB = '';
  var _userPassword = '';

  void _submitForm() {
    var isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    widget.submitAuthForm(
      _userEmail,
      _userPhone,
      _userName,
      _userDOB,
      _gender == Gender.male ? 'Male' : 'Female',
      _userPassword,
      _isLogin,
    );
  }

  TextEditingController intialdateval = TextEditingController();
  Future _selectDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2030));
    setState(() => intialdateval.text = picked.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20.0),
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
                TextFormField(
                  key: const ValueKey('email'),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    icon: Icon(Icons.email),
                  ),
                  onSaved: (value) {
                    _userEmail = value ?? '';
                  },
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
                if (!_isLogin)
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Phone',
                      icon: Icon(Icons.phone),
                    ),
                    onSaved: (value) {
                      _userPhone = value ?? '';
                    },
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
                if (!_isLogin)
                  TextFormField(
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      icon: Icon(Icons.person),
                    ),
                    onSaved: (value) {
                      _userName = value ?? '';
                    },
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
                if (!_isLogin)
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    autocorrect: false,
                    controller: intialdateval,
                    onTap: () {
                      _selectDate();
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Date of Birth',
                      icon: Icon(Icons.cake),
                    ),
                    onSaved: (value) {
                      _userDOB = value ?? '';
                    },
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
                if (!_isLogin)
                  Row(
                    children: [
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
                TextFormField(
                  // keyboardType: TextInputType.visiblePassword,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    icon: Icon(Icons.key),
                  ),
                  obscureText: true,
                  onSaved: (value) {
                    _userPassword = value ?? '';
                  },
                  validator: (value) {
                    if (value == null) {
                      return null;
                    }
                    if (value.isEmpty) {
                      return 'Password is required!';
                    }
                    if (value.length < 3) {
                      return 'Password is too short!';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(_isLogin ? 'Login' : 'Signup'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                    });
                  },
                  child: Text(_isLogin
                      ? 'Create new account?'
                      : 'I already have an account'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
