
import 'package:flutter/material.dart';

class MyDropdownButton extends StatefulWidget {
  final String? hint;
  final List<Map<String, dynamic>> dropdownItems;
  final dynamic dropdownValue;
  final Function onChange;
  final Function validator;


  const MyDropdownButton({super.key, this.hint, required this.dropdownItems, this.dropdownValue,
      required this.onChange, required this.validator});

  @override
  State<MyDropdownButton> createState() => _MyDropdownButtonState();
}

class _MyDropdownButtonState extends State<MyDropdownButton> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      decoration: const InputDecoration(
        border: OutlineInputBorder(
        )
      ),
        dropdownColor: Colors.grey[300],
        elevation: 5,
        isExpanded: true,
        hint: Text(widget.hint!),
        borderRadius: BorderRadius.circular(5),
        value: widget.dropdownValue,
        items: widget.dropdownItems
            .map<DropdownMenuItem<dynamic>>((category) {
          return DropdownMenuItem<dynamic>(
            value: category['id'],
            child: Text(category['name']),
          );
        }).toList(),
        validator: (value) =>
          widget.validator(value),
        onChanged: (value) {
          widget.onChange(value);
        });
  }
}
