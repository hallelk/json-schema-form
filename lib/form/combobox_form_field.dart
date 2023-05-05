import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class ComboboxFormField<T extends Value> extends FormField<T> {

  ComboboxFormField({
    super.key,
    super.onSaved,
    super.validator,
    super.initialValue,
    List<T> items = const [], 
    Future<T> Function(String name)? onAdd, 
    List<T> Function()? itemsFn, 
    List<T>? suggestions,
  })
  : super(
      builder: (FormFieldState<T> state) {
        return _ActualField<T>(
          initialValue: initialValue, 
          items: items, 
          itemsFn: itemsFn, 
          suggestions: suggestions,
          onAdd: onAdd != null 
            ? (name) async { 
                final navigator = Navigator.of(state.context);
                T val = await onAdd(name);
                state.didChange(val);
                navigator.pop(val);
              }
            : null,
          onChanged: (v) { state.didChange(v); });
      }
  );
}

class _ActualField<T extends Value> extends StatefulWidget {
  final T? initialValue;
  final Function onChanged;
  final List<T> items;
  final Future<void> Function(String name)? onAdd;
  final List<T> Function()? itemsFn;
  final List<T>? suggestions;

  const _ActualField({
    super.key, 
    required this.onChanged, required this.items, 
    this.initialValue, this.onAdd, this.itemsFn, this.suggestions});

  @override
  _ActualFieldState createState() => _ActualFieldState();
}

class _ActualFieldState<T extends Value> extends State<_ActualField<T>> {
  late List<T> items;
  late T? value;
  late TextEditingController textController;
  bool showOptions = false;
  String? currentText;
  late final List<Widget> suggestionItems;

  @override
  void initState() {
    super.initState();
    items = widget.itemsFn?.call() ?? widget.items;
    value = widget.initialValue;
    suggestionItems = _buildSuggestionItems();
    currentText = value?.toString();
    textController = TextEditingController(text: currentText);
    textController.addListener(textControllerChanged);
  }

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> optionItems = getListItems();

    return Column(children: [
      TextField(
        textAlign: TextAlign.start,
        style: const TextStyle(fontSize: 15),
        autofocus: true,
        controller: textController,
        decoration: InputDecoration(
          border: InputBorder.none,
          filled: true,
          suffixIcon: optionItems.isEmpty && widget.onAdd != null
            ? IconButton(
                iconSize: 20, 
                onPressed: () async {
                  await widget.onAdd!(textController.text);
                },
                icon: const Icon(Icons.add, color: Colors.black)
              ) 
            : IconButton(
                iconSize: 20, 
                onPressed: cancelPressed, 
                icon: const Icon(Icons.delete, color: Colors.black)
              )
        )
      ),
      Expanded(
        child: SizedBox(
        width: 250, 
        // height: MediaQuery.of(context).size.height * 0.3, 
        child: ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          children: [
            if (textController.text == "") ...suggestionItems, 
            ...optionItems
          ]
        )
      ))
    ]);
  }
  
  List<Widget> _buildSuggestionItems() {
    List<Widget> l = [];

    if ((widget.suggestions ?? []).isNotEmpty) {
      l = widget.suggestions!.map((e) => _buildListItem(e, true)).toList();
      l.add(const Divider(height: 2, color: Colors.black));
    }

    return l;
  }

  Widget _buildListItem(T item, [bool isSuggestion = false]) {
    return InkWell(
      onTap: () => optionChosen(item),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
        child: Row(children: [
          isSuggestion 
            ? const Padding(
                padding: EdgeInsetsDirectional.only(end: 5), 
                child: Icon(Icons.star, color: Colors.amber, size: 15,)
              ) 
            : const SizedBox(),
          Text(item.toString(), style: const TextStyle(fontSize: 17))
        ])
      )
    );
  }

  List<Widget> getListItems() {
    List<T> l = [];

    if ((currentText ?? "").isNotEmpty) {
      l.addAll([
        ...items.where((i) => i.toString().startsWith(currentText!)),
        ...items.where((i) => i.toString().contains(currentText!))
      ]);
    } else {
      l.addAll(items);
    }
    
    l = l.toSet().toList(); // removing duplicates

    return l.map(_buildListItem).toList();
  }

  void textControllerChanged() {
    setState(() {
      currentText = textController.text;
      if (value.toString() != currentText) {
        value = null;
        widget.onChanged(null);
      }
    });
  }

  void cancelPressed() {
    setState(() {
      textController.text = "";
      currentText = null;
      showOptions = false;
      widget.onChanged(null);
      value = items.singleWhereOrNull((element) => element.getValue() == null);
      if (value != null) {
        Navigator.pop(context, value);
      }
    });
  }

  optionChosen(T v) {
    Navigator.pop(context, v);
  }
}

abstract class Value {
  @override
  String toString();
  dynamic getValue();
}