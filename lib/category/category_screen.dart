import 'package:flutter/material.dart';
import 'package:note_manangement_system/database/sql_helper.dart';
import 'package:note_manangement_system/model/category_model.dart';
import 'package:note_manangement_system/model/user_model.dart';
import 'package:note_manangement_system/snackbar/snack_bar.dart';

class CategoryScreen extends StatefulWidget {
  final UserModel user;

  const CategoryScreen({super.key, required this.user});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Map<String, dynamic>> _categories = [];
  final _keyForm = GlobalKey<FormState>();
  bool _isDuplicate = false;
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = true;

  Future<void> _refreshJournals() async {
    final data = await SQLHelper.getCategories(widget.user.id!);

    setState(() {
      _categories = data;
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
          _categories.firstWhere((element) => element['id'] == id);
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
                    if (value.length < 5) {
                      return '* Please enter minimun 5 word';
                    }
                    if (_isDuplicate) {
                      return '* Please enter another name, this name was create';
                    }
                    return null;
                  },
                  onChanged: (value) async {
                    setState(() async {
                      if (id == null) {
                        _isDuplicate = await SQLHelper.checkDuplicateCategory(
                            _nameController.text, -1, widget.user.id!);
                      } else {
                        _isDuplicate = await SQLHelper.checkDuplicateCategory(
                            _nameController.text, id, widget.user.id!);
                      }
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
                        _addCategory();
                      }
                      if (id != null) {
                        _updateCategory(id);
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

  Future<void> _addCategory() async {
    await SQLHelper.insertCategory(Category(
      userId: widget.user.id!,
      name: _nameController.text,
    ));

    if (!mounted) return;
    showSnackBar(context, 'Successfully insert ${_nameController.text}');
    Navigator.of(context).pop();
    _refreshJournals();
  }

  Future<void> _updateCategory(int id) async {
    Category category =
        Category(id: id, name: _nameController.text, userId: widget.user.id);
    await SQLHelper.updateCategory(category);

    if (!mounted) return;
    _nameController.text = '';
    Navigator.pop(context);
    showSnackBar(context, 'Successfully update a category!');
    _refreshJournals();
  }

  Future<void> _deleteItem(category) async {
    bool isAccept = await SQLHelper.checkCategoryInNote(category['id']);

    if (isAccept) {
      if (!mounted) return;
      showSnackBar(context,
          "* Can't delete this ${category['name']} because it already exists in note");
    } else {
      final AlertDialog dialog = AlertDialog(
        title: const Text('Delete'),
        content: Text('* You want to delete this ${category['name']}? Yes/No?'),
        actions: [
          ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Yes')),
          ElevatedButton(
              onPressed: () async {
                await SQLHelper.deleteCategory(category['id']);
                if (!mounted) return;
                showSnackBar(context, '${category['name']} deleted');
                _refreshJournals();
                Navigator.pop(context);
              },
              child: const Text('No')),
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
              itemCount: _categories.length,
              itemBuilder: (context, index) => Card(
                color: Colors.white,
                elevation: 5,
                margin: const EdgeInsets.all(15),
                child: ListTile(
                  title: Text(_categories[index]['name']),
                  subtitle: Text(_categories[index]['createdAt']),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => _showForm(_categories[index]['id']),
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                            onPressed: () => _deleteItem(_categories[index]),
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
