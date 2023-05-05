// ignore_for_file: prefer_const_literals_to_create_immutables, sort_child_properties_last, use_build_context_synchronously, prefer_final_fields, prefer_const_constructors, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:note_manangement_system/database/sql_helper.dart';
import 'package:note_manangement_system/model/user_model.dart';
import 'package:note_manangement_system/snackbar/snack_bar.dart';
import 'package:flutter/services.dart';
import 'package:note_manangement_system/validator/validator_edit.dart';

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

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _firstnameController.text = widget.user.firstname ?? '';
    _lastnameController.text = widget.user.lastname ?? '';
    _emailController.text = widget.user.email ?? '';
    if (widget.user != null && widget.user.id != null) {
      _loadUserData(widget.user.id!);
    }
  }

  Future<void> _loadUserData(int id) async {
    setState(() {
      _isLoading = true;
    });

    final user = await SQLHelper.loadDataUser(id);

    if (user != null) {
      setState(() {
        _firstnameController.text = user.firstname ?? '';
        _lastnameController.text = user.lastname ?? '';
        _emailController.text = user.email ?? '';
        _isLoading = false;
      });
    }
  }

  void _updateProfile() async {
    String firstname = _firstnameController.text;
    String lastname = _lastnameController.text;
    String email = _emailController.text;

    try {
      await SQLHelper.updateUser(widget.user.id!, firstname, lastname, email);
      showSnackBar(context, 'Successfully changed information');
    } catch (error) {
      showSnackBar(context, 'Change information failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40)),
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                prefixIcon: Icon(Icons.person),
                                hintText: 'Enter your fristname',
                                fillColor: Colors.white10,
                                filled: true,
                              ),
                              validator: ValidatorEdit.validateFirstname,
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40)),
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                prefixIcon: Icon(Icons.person),
                                hintText: 'Enter your lastname',
                                fillColor: Colors.white10,
                                filled: true,
                              ),
                              validator: ValidatorEdit.validateLastname,
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40)),
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                prefixIcon: Icon(Icons.email),
                                hintText: 'Enter your email',
                                fillColor: Colors.white10,
                                filled: true,
                              ),
                              validator: ValidatorEdit.validateEmailEdit,
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
                        if (_formKeyEdit.currentState!.validate()) {
                          _updateProfile();
                        }
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
