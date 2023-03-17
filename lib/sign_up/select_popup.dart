import 'package:flutter/material.dart';

class SelectPopup extends StatefulWidget {
  final String title;
  final int length;
  final List<Map<String, String>> codes;

  const SelectPopup(
      {Key? key,
      required this.title,
      required this.length,
      required this.codes})
      : super(key: key);

  @override
  SelectPopupState createState() => SelectPopupState();
}

class SelectPopupState extends State<SelectPopup> {
  List<int> _selectedCodes = [];

  void _toggleCode(int index) {
    setState(() {
      if (_selectedCodes.contains(index)) {
        _selectedCodes.remove(index);
      } else {
        if (_selectedCodes.length < widget.length) {
          _selectedCodes.add(index);
        } else {
          // You can show a message here or disable the selection
          print('You can only select up to three codes');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.codes.length,
          itemBuilder: (context, index) {
            final label = widget.codes[index]['label'];
            final isSelected = _selectedCodes.contains(index);
            return ListTile(
              title: Text(label!),
              trailing: isSelected ? const Icon(Icons.check, color: Color(0xFFFDD835)) : null,
              onTap: () {
                _toggleCode(index);
              },
            );
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop(_selectedCodes);
          },
        ),
      ],
    );
  }
}
