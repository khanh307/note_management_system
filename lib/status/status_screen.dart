import 'package:flutter/material.dart';
import 'package:note_manangement_system/database/sql_helper.dart';
import 'package:note_manangement_system/model/priority_model.dart';
import 'package:note_manangement_system/model/status_model.dart';
import 'package:note_manangement_system/model/user_model.dart';

class StatusScreen extends StatefulWidget {
  final UserModel user;

  const StatusScreen({super.key, required this.user});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  List<Map<String, dynamic>> _status = [];
  final _keyForm = GlobalKey<FormState>();
  bool _isDuplicate = false;
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = true;

  Future<void> _refreshJournals() async {
    final data = await SQLHelper.getStatus(widget.user.id!);

    setState(() {
      _status = data;
      _isLoading = false;
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
          _status.firstWhere((element) => element['id'] == id);
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
                      return '* Please enter minimun 4 word';
                    }
                    if (value != 'Done' &&
                        value != 'Pending' &&
                        value != 'Progressing') {
                      return '* Please enter Done, Progressing, Pending';
                    }
                    if (_isDuplicate) {
                      return '* Please enter another name, this name was create';
                    }
                    return null;
                  },
                  onChanged: (value) async {
                    setState(() async {
                      _isDuplicate = await SQLHelper.checkDuplicateStatus(
                          _nameController.text,
                          (id == null) ? -1 : id,
                          widget.user.id!);
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
                        _addStatus();
                      }
                      if (id != null) {
                        _updateStatus(id);
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

  Future<void> _addStatus() async {
    await SQLHelper.insertStatus(Status(
      userId: widget.user.id!,
      name: _nameController.text,
    ));

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Successfully insert ${_nameController.text}'),
    ));
    Navigator.of(context).pop();
    _refreshJournals();
  }

  Future<void> _updateStatus(int id) async {
    Status status =
        Status(id: id, name: _nameController.text, userId: widget.user.id);
    await SQLHelper.updateStatus(status);

    if (!mounted) return;
    _nameController.text = '';
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully update a category!')));
    _refreshJournals();
  }

  Future<void> _deleteStatus(status) async {
    bool isAccept = await SQLHelper.checkStatusInNote(status['id']);

    if (isAccept) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            "* Can't delete this ${status['name']} because it already exists in note"),
      ));
    } else {
      final AlertDialog dialog = AlertDialog(
        title: const Text('Delete'),
        content: Text('* You want to delete this ${status['name']}? Yes/No?'),
        actions: [
          ElevatedButton(
              onPressed: () => Navigator.pop(context), child: const Text('No')),
          ElevatedButton(
              onPressed: () async {
                await SQLHelper.deleteStatus(status['id']);
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${status['name']} deleted')));
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
              itemCount: _status.length,
              itemBuilder: (context, index) => Card(
                color: Colors.green,
                elevation: 5,
                margin: const EdgeInsets.all(15),
                child: ListTile(
                  title: Text(_status[index]['name']),
                  subtitle: Text(_status[index]['createdAt']),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => _showForm(_status[index]['id']),
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                            onPressed: () => _deleteStatus(_status[index]),
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
