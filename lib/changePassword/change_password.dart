// ignore_for_file: sort_child_properties_last, no_logic_in_create_state, use_key_in_widget_constructors, use_build_context_synchronously, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note_manangement_system/database/sql_helper.dart';
import 'package:note_manangement_system/model/user_model.dart';
import 'package:note_manangement_system/snackbar/snack_bar.dart';
import 'package:note_manangement_system/utils/function_utils.dart';
import 'package:note_manangement_system/validator/validate_change.dart';

class ChangePassword extends StatefulWidget {
  final UserModel user;

  const ChangePassword({required this.user});

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

  bool _obscureText = true;
  bool _obscureTextConfirm = true;
  bool _obscureTextNew = true;

  void _togglePassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _toggleNewPassword() {
    setState(() {
      _obscureTextNew = !_obscureTextNew;
    });
  }

  void _toggleConFirmPassword() {
    setState(() {
      _obscureTextConfirm = !_obscureTextConfirm;
    });
  }

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
                        obscureText: _obscureText,
                        decoration: InputDecoration(
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
                          suffixIcon: GestureDetector(
                            onTap: _togglePassword,
                            child: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: _obscureText ? Colors.grey : Colors.blue,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '* Please enter your password';
                          }
                          return null;
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
                        obscureText: _obscureTextNew,
                        decoration: InputDecoration(
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
                          suffixIcon: GestureDetector(
                            onTap: _toggleNewPassword,
                            child: Icon(
                              _obscureTextNew
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color:
                                  _obscureTextNew ? Colors.grey : Colors.blue,
                            ),
                          ),
                        ),
                        validator: ValidateChange.validatePassword,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r"\s")),
                        ],
                        controller: _confirmPassword,
                        obscureText: _obscureTextConfirm,
                        decoration: InputDecoration(
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
                          suffixIcon: GestureDetector(
                            onTap: _toggleConFirmPassword,
                            child: Icon(
                              _obscureTextConfirm
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: _obscureTextConfirm
                                  ? Colors.grey
                                  : Colors.blue,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '* Please enter your password';
                          }

                          if (value != _newPassword.text) {
                            return '* Password does not match';
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
                    if (widget.user.password ==
                        hashPassword(_currentPassword.text.trim())) {
                      await SQLHelper.changePassword(widget.user.email!,
                          hashPassword(_confirmPassword.text.trim()));
                      showSnackBar(context, 'Change password successfully');
                    } else {
                      if (!mounted) return;
                      showSnackBar(context, 'Password change failed');
                    }
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
