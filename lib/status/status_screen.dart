import 'package:flutter/material.dart';
import 'package:note_manangement_system/Model/user_model.dart';
import 'package:note_manangement_system/model/status_model.dart';
import 'package:note_manangement_system/shared_widget/app_drawer.dart';
import '../database/sql_helper.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key, required this.user});
  final UserModel user;

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  List<Map<String, dynamic>> _status = [];

  bool _isloading = true;
  bool _isdone = false;

  Future<void> _refresh() async {
    final data = await SQLHelper.getItems2();

    setState(() {
      _status = data;
      _isloading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  final TextEditingController _nameController = TextEditingController();

  void _showForm(int? id) async {
    if (id != null) {
      final existingJournal =
          _status.firstWhere((element) => element['id'] == id);
      _nameController.text = existingJournal['name'];
    }

    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: EdgeInsets.only(
            top: 15,
            left: 15,
            right: 15,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(hintText: 'Status'),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () async {
                  if (id == null) {
                    await _addItem2();
                  }
                  if (id != null) {
                    await _updateItem2(id);
                  }
                  _nameController.text = '';
                  if (!mounted) return;
                  Navigator.of(context).pop();
                },
                child: Text(id == null ? 'Create New' : 'Update'))
          ],
        ),
      ),
    );
  }

  Future<void> _addItem2() async {
    await SQLHelper.createItem2(StatusModel(
      name: _nameController.text,
    ));

    _refresh();
  }

  Future<void> _updateItem2(int id) async {
    await SQLHelper.updateItem2(StatusModel(
      id: id,
      name: _nameController.text,
    ));

    _refresh();
  }

  Future<void> _deleteItem2(int id) async {
    await SQLHelper.deleteItem2(id);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleterd a status!'),
    ));

    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Status'),
          ),
          // body: _widget,
          drawer: AppDrawer(
            user: widget.user,
          ),
          body: _isloading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: _status.length,
                  itemBuilder: (context, index) => Card(
                    color: Colors.green[500],
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
                                onPressed: () =>
                                    _deleteItem2(_status[index]['id']),
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
        ));
  }
}
