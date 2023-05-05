// ignore_for_file: prefer_const_constructors, sort_child_properties_last, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note_manangement_system/database/sql_helper.dart';
import 'package:note_manangement_system/login/sign_in_page.dart';
import 'package:note_manangement_system/snackbar/snack_bar.dart';
import 'package:note_manangement_system/utils/function_utils.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignUpHome(),
    );
  }
}

class SignUpHome extends StatefulWidget {
  const SignUpHome({super.key});

  @override
  State<SignUpHome> createState() => _SignUpHomeState();
}

class _SignUpHomeState extends State<SignUpHome> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureText = true; //password
  bool _obscureTextConfirm = true; //confirm password

  void _togglePassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _toggleConfirm() {
    setState(() {
      _obscureTextConfirm = !_obscureTextConfirm;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,
                ),
                const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 35,
                    letterSpacing: 0.8,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Image.asset(
                  'assets/images/logo_small.png',
                  height: 150,
                ),
                SizedBox(
                  height: 20,
                ),
                const Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                    margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40)),
                                  borderSide: BorderSide.none),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40)),
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              prefixIcon: Icon(Icons.email),
                              hintText: 'Enter your Email',
                              fillColor: Colors.grey[200],
                              filled: true,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '* Vui lòng nhập địa chỉ email';
                              }

                              if (value.trim().length < 6) {
                                return "* Vui lòng nhập tối thiểu 6 ký tự";
                              }

                              if (value.trim().length > 256) {
                                return "* Vui lòng nhập tối đa 256 ký tự";
                              }

                              if (value.contains('..') ||
                                  value.startsWith('.') ||
                                  value.endsWith('.') ||
                                  value.endsWith('@') ||
                                  value.contains('-@') ||
                                  value.contains('@-') ||
                                  value.contains('..') ||
                                  RegExp(r'^[0-9]+$').hasMatch(value)) {
                                return '* Địa chỉ email không đúng';
                              }

                              final List<String> parts = value.split('@');
                              if (parts.length != 2 ||
                                  parts[0].isEmpty ||
                                  parts[1].isEmpty) {
                                return '* Địa chỉ email không đúng';
                              }

                              if (RegExp(r'[^\w\s@.-]').hasMatch(value)) {
                                return '* Địa chỉ email không đúng';
                              }

                              return null;
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _passwordController,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r"\s")),
                            ],
                            obscureText: _obscureText,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40)),
                                  borderSide: BorderSide.none),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40)),
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              prefixIcon: Icon(Icons.lock),
                              suffixIcon: GestureDetector(
                                onTap: _togglePassword,
                                child: Icon(
                                  _obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color:
                                      _obscureText ? Colors.grey : Colors.blue,
                                ),
                              ),
                              hintText: 'Enter your password',
                              fillColor: Colors.grey[200],
                              filled: true,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '* Vui lòng nhập mật khẩu';
                              }

                              if (value.trim().length < 6 ||
                                  value.trim().length > 32) {
                                return '* Mật khẩu phải có độ dài từ 6 đến 32 ký tự';
                              }

                              RegExp upperCase = RegExp(r'[A-Z]');
                              if (!upperCase.hasMatch(value)) {
                                return '* Vui lòng nhập ít nhât 1 chữ in hoa';
                              }

                              RegExp digit = RegExp(r'[0-9]');
                              if (!digit.hasMatch(value)) {
                                return '* Vui lòng nhập ít nhât 1 số';
                              }
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: _obscureTextConfirm,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40)),
                                  borderSide: BorderSide.none),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40)),
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              prefixIcon: Icon(Icons.lock),
                              hintText: 'Confirm password',
                              suffixIcon: GestureDetector(
                                onTap: _toggleConfirm,
                                child: Icon(
                                  _obscureTextConfirm
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: _obscureTextConfirm
                                      ? Colors.grey
                                      : Colors.blue,
                                ),
                              ),
                              fillColor: Colors.grey[200],
                              filled: true,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '* Vui lòng nhập lại mật khẩu';
                              }

                              if (value != _passwordController.text) {
                                return '*Mật khẩu chưa khớp';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    )),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (await SQLHelper.addAccount(
                            _emailController.text.trim(),
                            hashPassword(
                                _confirmPasswordController.text.trim()))) {
                          if (!mounted) return;
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignInPage()),
                              (route) => false);
                        } else {
                          if (!mounted) return;
                          showSnackBar(context, '* Địa chỉ email này đã tồn tại');
                        }
                      }

                      _passwordController.text = '';
                      _confirmPasswordController.text = '';
                    },
                    child: Text(
                      'SignUp',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 15)),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'You have account?',
                        style: TextStyle(fontSize: 16),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (_) => SignInPage()),
                                (route) => false);
                          },
                          child: const Text(
                            'SignIn',
                            style: TextStyle(fontSize: 16),
                          )),
                    ],
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
