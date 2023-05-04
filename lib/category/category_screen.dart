import 'package:flutter/material.dart';
import '../database/sql_helper.dart';
import '../model/journal_model.dart';
import 'package:note_manangement_system/Model/user_model.dart';
import 'package:note_manangement_system/shared_widget/app_drawer.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key, required this.user});
  final UserModel user;

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Map<String, dynamic>> _journals = [];

  bool _isloading = true;

  Future<void> _refreshJournals() async {
    final data = await SQLHelper.getItems();

    setState(() {
      _journals = data;
      _isloading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshJournals();
  }

  final TextEditingController _nameController = TextEditingController();

  void _showForm(int? id) async {
    if (id != null) {
      final existingJournal =
          _journals.firstWhere((element) => element['id'] == id);
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
              decoration: const InputDecoration(hintText: 'Name'),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () async {
                  if (id == null) {
                    await _addItem();
                  }
                  if (id != null) {
                    await _updateItem(id);
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

  Future<void> _addItem() async {
    await SQLHelper.createItem(JournalModel(
      name: _nameController.text,
    ));

    _refreshJournals();
  }

  Future<void> _updateItem(int id) async {
    await SQLHelper.updateItem(JournalModel(
      id: id,
      name: _nameController.text,
    ));

    _refreshJournals();
  }

  Future<void> _deleteItem(int id) async {
    await SQLHelper.deleteItem(id);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleterd a journal!'),
    ));

    _refreshJournals();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Category'),
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
                  itemCount: _journals.length,
                  itemBuilder: (context, index) => Card(
                    color: Colors.orange[200],
                    margin: const EdgeInsets.all(15),
                    child: ListTile(
                      title: Text(_journals[index]['name']),
                      subtitle: Text(_journals[index]['createdAt']),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () =>
                                  _showForm(_journals[index]['id']),
                              icon: const Icon(Icons.edit),
                            ),
                            IconButton(
                                onPressed: () =>
                                    _deleteItem(_journals[index]['id']),
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
