
import 'package:flutter/material.dart';

class MyDropdownButton extends StatefulWidget {
  final String? hint;
  final List<Map<String, dynamic>> dropdownItems;
  final dynamic dropdownvalue;
  final Function onChange;
  final Function validator;


  const MyDropdownButton({super.key, this.hint, required this.dropdownItems, this.dropdownvalue,
      required this.onChange, required this.validator});

  @override
  State<MyDropdownButton> createState() => _MyDropdownButtonState();
}

class _MyDropdownButtonState extends State<MyDropdownButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(4.0)
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
            dropdownColor: Colors.grey[300],
            elevation: 5,
            isExpanded: true,
            hint: Text(widget.hint!),
            borderRadius: BorderRadius.circular(5),
            value: widget.dropdownvalue,
            items: widget.dropdownItems
                .map<DropdownMenuItem<dynamic>>((category) {
              return DropdownMenuItem<dynamic>(
                value: category['id'],
                child: Text(category['name']),
              );
            }).toList(),
            onChanged: (value) {
              widget.onChange(value);
            }),
      ),
    );
  }
}
