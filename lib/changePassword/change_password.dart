// ignore_for_file: sort_child_properties_last, no_logic_in_create_state, use_key_in_widget_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note_manangement_system/database/sql_helper.dart';
import 'package:note_manangement_system/model/user_model.dart';
import 'package:note_manangement_system/utils/function_utils.dart';
class ChangePassword extends StatefulWidget {
  
  final UserModel user;

  const ChangePassword({required this.user, Key? key}) : super(key: key);


  @override
  State<ChangePassword> createState() => _ChangePasswordState(user: user);
}

class _ChangePasswordState extends State<ChangePassword> {

  UserModel user;
  _ChangePasswordState({required this.user});

  final _formChange = GlobalKey<FormState>();
  final _currentPassword = TextEditingController();
  final _newPassword = TextEditingController();
  final _confirmPassword = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _currentPassword.dispose();
    _newPassword.dispose();
    _confirmPassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Form(
                  key: _formChange,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _currentPassword,
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40)),
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          prefixIcon: Icon(Icons.lock),
                          hintText: 'Enter your current password',
                          fillColor: Colors.white10,
                          filled: true,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '* Vui lòng nhập lại mật khẩu';
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r"\s")),
                        ],
                        controller: _newPassword,
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40)),
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          prefixIcon: Icon(Icons.lock),
                          hintText: 'Enter your new password',
                          fillColor: Colors.white10,
                          filled: true,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '* Vui long nhập mật khẩu';
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
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r"\s")),
                        ],
                        controller: _confirmPassword,
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40)),
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          prefixIcon: Icon(Icons.lock),
                          hintText: 'Confirm password',
                          fillColor: Colors.white10,
                          filled: true,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '* Vui lòng nhập lại mật khẩu';
                          }

                          if (value != _newPassword.text) {
                            return '*Mật khẩu chưa khớp';
                          }
                          return null;
                        },
                      )
                    ],
                  )),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (_formChange.currentState!.validate()) {
                    if (user.password ==
                        hashPassword(_currentPassword.text.trim())) {
                      await SQLHelper.changePassword(
                        user.email!, _confirmPassword.text.trim());
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Success')));
                    }
                  } else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text('Failed')));
                  }
                },
                child: const Text(
                  'Change password',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15)),
              ),
            ),
          ],
        ),
      ),
    );
    ;
  }
}