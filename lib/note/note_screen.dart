import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_manangement_system/model/user_model.dart';
import 'package:note_manangement_system/note/my_dropdown_button.dart';
import 'package:note_manangement_system/snackbar/snack_bar.dart';
import 'package:note_manangement_system/validator/note_validator.dart';

import '../database/sql_helper.dart';
import '../model/note_model.dart';

class NoteScreen extends StatefulWidget {
  final UserModel user;

  const NoteScreen({super.key, required this.user});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  List<Map<String, dynamic>> _notes = [];
  bool _isLoading = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _priorities = [];
  List<Map<String, dynamic>> _status = [];
  dynamic dropdownCategoryValue;
  dynamic dropdownPriorityValue;
  dynamic dropdownStatusValue;
  DateTime? _dateTime;
  final _keyForm = GlobalKey<FormState>();

  // final _keyDateField = GlobalKey<FormFieldState>();
  String? _validateNameValue;

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  Future<void> _refreshData() async {
    final data = await SQLHelper.getNotes(widget.user.id!);
    _categories = await SQLHelper.getCategories(widget.user.id!);
    _priorities = await SQLHelper.getPriorities(widget.user.id!);
    _status = await SQLHelper.getStatus(widget.user.id!);

    setState(() {
      _notes = data;
      // _categories = categories;
      // _priorities = priorities;
      // _status = status;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    _refreshData();
  }

  Future<void> _insertNote() async {
    Note note = Note(
        name: _nameController.text,
        userId: widget.user.id,
        categoryId: dropdownCategoryValue,
        priorityId: dropdownPriorityValue,
        statusId: dropdownStatusValue,
        planDate: _dateTime.toString());
    await SQLHelper.insertNote(note);
    if (!mounted) return;
    Navigator.pop(context);
    showSnackBar(context, 'Successfully insert a note!');
    _refreshData();
  }

  Future<void> _deleteNote(note) async {
    String name = note['name'];
    if (!_checkNoteDone(note)) {
      showSnackBar(context, '* Không xoá được $name này vì chưa quá 6 tháng');
    } else {
      showDialog(
          context: context,
          useRootNavigator: false,
          builder: (_) => AlertDialog(
                title: const Text('Delete'),
                content:
                    Text('* Bạn có chắc muốn xoá $name này không? Có/Không?'),
                actions: [
                  ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Không')),
                  ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await SQLHelper.deleteNote(note['id']);
                        if (!mounted) return;
                        showSnackBar(context, 'Successfully delete a note!');
                        _refreshData();
                      },
                      child: const Text('Có')),
                ],
              ));
    }
  }

  bool _checkNoteDone(note) {
    if (note['statusName'].toString().toLowerCase() == 'done' ||
        note['statusName'].toString().toLowerCase() == 'finish') {
      DateTime dateDone = DateTime.parse(note['planDate']);
      DateTime endDate = dateDone.add(const Duration(days: 30 * 6));
      if (DateTime.now().difference(endDate).inDays < 0) {
        return false;
      }
    } else {
      return true;
    }
    return true;
  }

  Future<void> _updateNote(int id) async {
    Note note = Note(
        id: id,
        name: _nameController.text,
        userId: widget.user.id,
        categoryId: dropdownCategoryValue,
        priorityId: dropdownPriorityValue,
        statusId: dropdownStatusValue,
        planDate: _dateTime.toString());

    await SQLHelper.updateNote(note);

    if (!mounted) return;
    Navigator.pop(context);
    showSnackBar(context, 'Successfully update a note!');

    _refreshData();
  }

  void handleClick(int? id) {
    if (_keyForm.currentState!.validate()) {
      if (id == null) {
        _insertNote();
      } else {
        _updateNote(id);
      }
    }
  }

  void _showForm(int? id) async {
    if (id != null) {
      final existingNote = _notes.firstWhere((element) => element['id'] == id);
      _nameController.text = existingNote['name'];
      _dateTime = DateTime.parse(existingNote['planDate'].toString());
      _dateController.text = _formatDate(_dateTime!);
      dropdownStatusValue = existingNote['statusId'];
      dropdownPriorityValue = existingNote['priorityId'];
      dropdownCategoryValue = existingNote['categoryId'];
    } else {
      _nameController.text = '';
      _dateController.text = '';
      _dateTime = null;
      dropdownStatusValue = null;
      dropdownPriorityValue = null;
      dropdownCategoryValue = null;
    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => StatefulBuilder(builder: (context, setState) {
              return SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                      top: 15,
                      left: 15,
                      right: 15,
                      bottom: MediaQuery.of(context).viewInsets.bottom + 90),
                  child: Form(
                    key: _keyForm,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Enter note name'),
                          validator: (value) {
                            return _validateNameValue;
                          },
                          onChanged: (value) async {
                            String? result = await NoteValidator.nameValidate(
                                _nameController.text, id, widget.user.id!);
                            setState(() {
                              _validateNameValue = result;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        MyDropdownButton(
                            hint: 'Select category',
                            dropdownValue: dropdownCategoryValue,
                            dropdownItems: _categories,
                            onChange: (value) {
                              setState(() {
                                dropdownCategoryValue = value;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return NoteValidator.categoryValidate(value);
                              }
                              return null;
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                        MyDropdownButton(
                            hint: 'Select status',
                            dropdownValue: dropdownStatusValue,
                            dropdownItems: _status,
                            onChange: (value) {
                              setState(() {
                                dropdownStatusValue = value;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return NoteValidator.statusValidate(value);
                              }
                              return null;
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                        MyDropdownButton(
                            hint: 'Select priority',
                            dropdownValue: dropdownPriorityValue,
                            dropdownItems: _priorities,
                            onChange: (value) {
                              setState(() {
                                dropdownPriorityValue = value;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return NoteValidator.priorityValidate(value);
                              }
                              return null;
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          validator: (value) =>
                              NoteValidator.planDateValidate(value),
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Select plan date'),
                          readOnly: true,
                          controller: _dateController,
                          onTap: () {
                            showDatePicker(
                              context: context,
                              initialDate: (_dateTime != null)
                                  ? _dateTime!
                                  : DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(3000),
                            ).then((value) {
                              setState(() {
                                _dateTime = value!;
                                _dateController.text = _formatDate(value);
                              });
                            });
                          },
                          // child: Container(
                          //   padding: const EdgeInsets.only(left: 10, right: 10),
                          //   height: 50,
                          //   decoration: BoxDecoration(
                          //     border: Border.all(color: Colors.grey, width: 1),
                          //     borderRadius: BorderRadius.circular(4.0),
                          //   ),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //     crossAxisAlignment: CrossAxisAlignment.center,
                          //     children: [
                          //       Text((_dateTime != null)
                          //           ? _formatDate(_dateTime!)
                          //           : 'Select plan date'),
                          //       const Icon(Icons.calendar_month),
                          //     ],
                          //   ),
                          // ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              handleClick(id);
                            },
                            child: Text(id == null ? 'Add' : 'Update'))
                      ],
                    ),
                  ),
                ),
              );
            }));
  }

  @override
  Widget build(BuildContext context) {
    Widget itemCard(IconData icon, note, title) => Padding(
          padding: const EdgeInsets.all(3.0),
          child: Row(
            children: [
              Icon(icon),
              Text('$title: '),
              Text(note),
            ],
          ),
        );

    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (context, index) => Card(
                    color: Colors.white,
                    elevation: 5,
                    margin: const EdgeInsets.all(8),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _notes[index]['name'],
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        _showForm(_notes[index]['id']);
                                      },
                                      icon: const Icon(Icons.edit)),
                                  IconButton(
                                      onPressed: () {
                                        _deleteNote(_notes[index]);
                                      },
                                      icon: const Icon(Icons.delete)),
                                ],
                              ),
                            ],
                          ),
                          itemCard(Icons.category,
                              _notes[index]['categoryName'], 'Category'),
                          itemCard(Icons.priority_high,
                              _notes[index]['priorityName'], 'Priority'),
                          itemCard(Icons.priority_high,
                              _notes[index]['statusName'], 'Status'),
                          itemCard(
                              Icons.date_range,
                              _formatDate(
                                  DateTime.parse(_notes[index]['planDate'])),
                              'Plan date'),
                          itemCard(Icons.calendar_month_sharp,
                              _notes[index]['createdAt'], 'Created at'),
                        ],
                      ),
                    ),
                  )),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
    );
  }
}
