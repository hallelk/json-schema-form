import 'package:flutter/material.dart';

class MultiTextFormField<T> extends FormField<List<T>> {
  final Function change;

  MultiTextFormField({
    super.key,
    super.onSaved,
    super.validator,
    super.initialValue,
    required this.change,
    bool enabled = true
  })
  : super(
      builder: (FormFieldState<List<T>> state) {
        return ActualField(
          initialValue: state.value,
          onChanged: change,
          enabled: enabled
        );
      });
}

class ActualField<T> extends StatefulWidget {
  final List<T>? initialValue;
  final bool enabled;
  final Function onChanged;

  const ActualField({super.key, required this.initialValue, required this.enabled, required this.onChanged});

  @override 
  ActualFieldState<T> createState() => ActualFieldState();
}

class ActualFieldState<T> extends State<ActualField<T>> {
  
  late List<T?> value;
  late List<TextField> textFields;
  final TextInputType keyboardType = (T is num) ? TextInputType.number : TextInputType.text;

  @override 
  void initState() {
    super.initState();
    value = widget.initialValue ?? List<T>.empty();
    _buildTextFields();
  }

  void _addTextField([T? v]) {
    value.add(v);
    TextEditingController textEditingController = TextEditingController(text: v?.toString());
    TextField textField = TextField(
      controller: textEditingController,
      keyboardType: keyboardType,
      // onChanged: value[],
    );

    textFields.add(textField);
    value.add(v);
    widget.onChanged(value);
  }

  void _buildTextFields() {
    if (value.isEmpty) {
      _addTextField();
    } else {
      for (var v in value) { 
        _addTextField(v);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return Text(widget.initialValue?.join(", ") ?? "");

    return Column(children: [
      ...textFields.asMap().entries.map(
        (e) => _Item(
          textField: e.value, 
          index: e.key, 
          removeCallback: _removeItem
        )
      ).toList(),
      IconButton(onPressed: _addTextField, icon: const Icon(Icons.add))
    ]);
  }

  _removeItem(int index) {
    setState(() {
      value.removeAt(index);  
    });
  }
}

class _Item extends StatelessWidget {
  final TextField textField;
  final int index;
  final void Function(int) removeCallback;
  
  const _Item({
    required this.textField, 
    required this.index, 
    required this.removeCallback
  });
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        textField,
        Visibility(visible: index > 0, child: 
          IconButton(
            icon: const Icon(Icons.remove), 
            onPressed: () => removeCallback(index),
          )
        )
      ],
    );
  }
}
