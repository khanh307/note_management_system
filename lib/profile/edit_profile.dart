// ignore_for_file: prefer_const_literals_to_create_immutables, sort_child_properties_last
import 'package:flutter/material.dart';
import 'package:note_manangement_system/model/user_model.dart';
import 'package:note_manangement_system/utils/function_utils.dart';
import 'package:flutter/services.dart';

class EditProfile extends StatefulWidget {
  final UserModel user;

  const EditProfile({super.key, required this.user});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKeyEdit = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();

  bool _isLoading = true;

  Future<void> _reFreshUsers() async {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.user.firstname != null && widget.user.firstname!.isEmpty) {
        _firstnameController.text = widget.user.firstname!;
    }

    if (widget.user.lastname != null && widget.user.lastname!.isEmpty) {
      _firstnameController.text = widget.user.lastname!;
    }
    _emailController.text = widget.user.email!;
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
                  key: _formKeyEdit,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _firstnameController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z\s]')),
                        ],
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40)),
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          prefixIcon: Icon(Icons.person),
                          hintText: 'Enter your fristname',
                          fillColor: Colors.white10,
                          filled: true,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "* Vui lòng nhập họ và tên lót";
                          }

                          if (value.trim().length < 2 ||
                              value.trim().length > 32) {
                            return "* Họ và tên lót phải có độ dài từ 2 đến 32 ký tự";
                          }

                          if (value.endsWith(' ')) {
                            return "* Vui lòng không kết thúc bằng dấu cách";
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _lastnameController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z\s]')),
                        ],
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40)),
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          prefixIcon: Icon(Icons.person),
                          hintText: 'Enter your lastname',
                          fillColor: Colors.white10,
                          filled: true,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "* Vui lòng nhập tên";
                          }

                          if (value.length < 2 || value.length > 32) {
                            return "* Tên phải có độ dài từ 2 đến 32 ký tự";
                          }

                          if (value.endsWith(' ')) {
                            return "* Vui lòng không kết thúc bằng dấu cách";
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40)),
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          prefixIcon: Icon(Icons.email),
                          hintText: 'Enter your email',
                          fillColor: Colors.white10,
                          filled: true,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '* Vui lòng nhập địa chỉ email';
                          }

                          if (!isValidEmail(value)) {
                            return '* Địa chỉ email hoặc mật khẩu không đúng';
                          }
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
                  if (_formKeyEdit.currentState!.validate()) {}
                },
                child: const Text(
                  'Save',
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
  }
}
