import 'package:flutter/material.dart';

import 'form/form_item.dart';

class NewFieldDialog extends StatefulWidget {
  const NewFieldDialog(this.val, {super.key});

  final String val;

  @override
  NewFieldDialogState createState() => NewFieldDialogState();
}

class NewFieldDialogState extends State<NewFieldDialog> {
  String value = "";

  @override
  void initState() {
    super.initState();
    value = widget.val;
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: TextFormItem(
        fieldName: '', 
        mode: '', 
        onSavedCallback: () => null, 
        title: 'Field Name',
        isMultiline: false,

        onChangedCallback: (v) => setState(() { value = v; }),

      ),
      actions: [
        ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel')),
        ElevatedButton(
            onPressed: () => Navigator.pop(context, value),
            child: Text('confirm')),
      ],
    );
  }
}