import 'package:flutter/material.dart';
import 'package:note_manangement_system/database/sql_helper.dart';
import 'package:note_manangement_system/model/priority_model.dart';
import 'package:note_manangement_system/model/user_model.dart';
import 'package:note_manangement_system/snackbar/snack_bar.dart';

class PriorityScreen extends StatefulWidget {
  final UserModel user;

  const PriorityScreen({super.key, required this.user});

  @override
  State<PriorityScreen> createState() => _PriorityScreenState();
}

class _PriorityScreenState extends State<PriorityScreen> {
  List<Map<String, dynamic>> _priorities = [];
  final _keyForm = GlobalKey<FormState>();
  bool _isDuplicate = false;
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = true;

  Future<void> _refreshJournals() async {
    final data = await SQLHelper.getPriorities(widget.user.id!);

    setState(() {
      _priorities = data;
      _isLoading = false;
    });
  }

  Future<void> isDuplicate(id) async {
    bool isDuplicate = await SQLHelper.checkDuplicatePriority(
        _nameController.text, (id == null) ? -1 : id, widget.user.id!);
    setState(() {
      _isDuplicate = isDuplicate;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshJournals();
  }

  void _showForm(int? id) async {
    if (id != null) {
      final existingJournal =
          _priorities.firstWhere((element) => element['id'] == id);
      _nameController.text = existingJournal['name'];
    } else {
      _nameController.text = '';
    }

    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => StatefulBuilder(builder: (context, setState) {
        return Container(
          padding: EdgeInsets.only(
              top: 15,
              left: 15,
              right: 15,
              bottom: MediaQuery.of(context).viewInsets.bottom + 90),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Form(
                key: _keyForm,
                child: TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(hintText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '* Please enter name';
                    }
                    if (value.length < 4) {
                      return '* Please enter minimum 4 word';
                    }
                    if (_isDuplicate) {
                      return '* Please enter another name, this name was create';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      isDuplicate(id);
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  onPressed: () {
                    if (_keyForm.currentState!.validate()) {
                      if (id == null) {
                        _addPriority();
                      }
                      if (id != null) {
                        _updatePriority(id);
                      }
                    }
                  },
                  child: Text(id == null ? 'Create New' : 'Update'))
            ],
          ),
        );
      }),
    );
  }

  Future<void> _addPriority() async {
    await SQLHelper.insertPriority(Priority(
      userId: widget.user.id!,
      name: _nameController.text,
    ));

    if (!mounted) return;
    showSnackBar(context, 'Successfully insert ${_nameController.text}');
    Navigator.of(context).pop();
    _refreshJournals();
  }

  Future<void> _updatePriority(int id) async {
    Priority priority =
        Priority(id: id, name: _nameController.text, userId: widget.user.id);
    await SQLHelper.updatePriority(priority);

    if (!mounted) return;
    _nameController.text = '';
    Navigator.pop(context);
    showSnackBar(context, 'Successfully update a category!');
    _refreshJournals();
  }

  Future<void> _deletePriority(priority) async {
    bool isAccept = await SQLHelper.checkPriorityInNote(priority['id']);

    if (isAccept) {
      if (!mounted) return;
      showSnackBar(context,
          "* Can't delete this ${priority['name']} because it already exists in note ");
    } else {
      final AlertDialog dialog = AlertDialog(
        title: const Text('Delete'),
        content: Text('* You want to delete this ${priority['name']}? Yes/No?'),
        actions: [
          ElevatedButton(
              onPressed: () => Navigator.pop(context), child: const Text('No')),
          ElevatedButton(
              onPressed: () async {
                await SQLHelper.deletePriority(priority['id']);
                if (!mounted) return;
                showSnackBar(context, '${priority['name']} deleted');
                _refreshJournals();
                Navigator.pop(context);
              },
              child: const Text('Yes')),
        ],
      );
      showDialog(
          context: context,
          useRootNavigator: false,
          builder: (context) => dialog);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _priorities.length,
              itemBuilder: (context, index) => Card(
                color: Colors.white,
                elevation: 5,
                margin: const EdgeInsets.all(15),
                child: ListTile(
                  title: Text(_priorities[index]['name']),
                  subtitle: Text(_priorities[index]['createdAt']),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => _showForm(_priorities[index]['id']),
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                            onPressed: () =>
                                _deletePriority(_priorities[index]),
                            icon: const Icon(Icons.delete))
                      ],
                    ),
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
    );
  }
}
