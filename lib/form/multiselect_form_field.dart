import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class MultiSelectFormField extends FormField<dynamic> {
  final Widget title;
  final Widget hintWidget;
  final bool required;
  final String errorText;
  final List? dataSource;
  final String? textField;
  final String? valueField;
  final Function? change;
  final Function? open;
  final Function? close;
  final Widget? leading;
  final Widget? trailing;
  final String okButtonLabel;
  final String cancelButtonLabel;
  final Color? fillColor;
  final InputBorder? border;
  final TextStyle? chipLabelStyle;
  final Color? chipBackGroundColor;
  final TextStyle dialogTextStyle;
  final ShapeBorder dialogShapeBorder;
  final Color? checkBoxCheckColor;
  final Color? checkBoxActiveColor;
  final bool isEnabled;
  final bool allowOther;
  final TextInputType? keyboardType;

  MultiSelectFormField({
    super.key,
    super.onSaved,
    super.validator,
    super.initialValue,
    super.autovalidateMode = AutovalidateMode.disabled,
    this.title = const Text('Title'),
    this.hintWidget = const Text('Tap to select one or more'),
    this.required = false,
    this.errorText = 'Please select one or more options',
    this.leading,
    this.dataSource,
    this.textField,
    this.valueField,
    this.change,
    this.open,
    this.close,
    this.okButtonLabel = 'OK',
    this.cancelButtonLabel = 'CANCEL',
    this.fillColor,
    this.border,
    this.trailing,
    this.chipLabelStyle,
    this.isEnabled = true,
    this.chipBackGroundColor,
    this.dialogTextStyle = const TextStyle(fontSize: 13),
    this.dialogShapeBorder = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(0.0)),
    ),
    this.checkBoxActiveColor,
    this.checkBoxCheckColor, 
    this.keyboardType,
    required this.allowOther,
  }) 
  : super(
      builder: (FormFieldState<dynamic> state) {
        List<Widget> buildSelectedOptions(List values) {
          
          List<Widget> selectedOptions = [];
          
          for (var value in values) {
            if (value != null && value != "" ) {
              late String text;

              if (value.toString().startsWith("@@")) {
                text = value.toString().replaceAll("@@", "");
              } else {
                var existingItem = dataSource!.singleWhereOrNull(
                  (itm) => itm[valueField] == value
                ); 

                if (existingItem != null) {
                  text = existingItem[textField];
                } else {
                  text = value.toString();
                } // fallback for yariv
              }

              Widget baseWidget = Chip(
                labelStyle: chipLabelStyle,
                backgroundColor: chipBackGroundColor,
                label: Text(
                  text,
                  overflow: TextOverflow.ellipsis,
                ),
              );

              selectedOptions.add(
                isEnabled ? baseWidget : GestureDetector(
                  onTap: () => ScaffoldMessenger.of(state.context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text(text))),
                  child: baseWidget,
                )
              );
            }
          }
          
          return selectedOptions;
        }

        return InkWell(
          onTap: !isEnabled ? null :() async {
            List? initialSelected = state.value;
            var additionals = <String>[];

            if (initialSelected != null) {
              additionals = 
                initialSelected.where((v) => v.toString().startsWith("@@"))
                  .map((e) => e.toString().replaceAll("@@", "")).toList();
              initialSelected.removeWhere((v) => v.toString().startsWith("@@"));
            }

            final items = <MultiSelectDialogItem<dynamic>>[];

            for (var item in dataSource!) {
              items.add(
                MultiSelectDialogItem(item[valueField], item[textField])
              );
            }

            List? selectedValues = await showDialog<List>(
              context: state.context,
              builder: (BuildContext context) {
                return MultiSelectDialog(
                  title: title,
                  okButtonLabel: okButtonLabel,
                  cancelButtonLabel: cancelButtonLabel,
                  items: items,
                  additionals: additionals,
                  initialSelectedValues: initialSelected,
                  labelStyle: dialogTextStyle,
                  dialogShapeBorder: dialogShapeBorder,
                  checkBoxActiveColor: checkBoxActiveColor,
                  checkBoxCheckColor: checkBoxCheckColor,
                  allowOther: allowOther,
                  keyboardType: keyboardType
                );
              },
            );

            if (selectedValues != null) {
              state.didChange(selectedValues);
              state.save();
            }
          },
          child: InputDecorator(
            decoration: InputDecoration(
              filled: true,
              errorText: state.hasError ? state.errorText : null,
              errorMaxLines: 4,
              fillColor: fillColor ?? Theme.of(state.context).canvasColor,
              border: border ?? const UnderlineInputBorder(),
            ),
            isEmpty: state.value == null || state.value == '',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Expanded(
                      //   child: title,
                      // ),
                      required
                        ? const Padding(
                            padding: EdgeInsets.only(top: 5, right: 5),
                            child: Text(
                              ' *',
                              style: TextStyle(color: Color(0xFFDD2F2F), fontSize: 17.0)
                            ),
                          )
                        : Container(),
                    ],
                  ),
                ),
                state.value != null && 
                (state.value as List).where((x) => x != null).isNotEmpty 
                    ? Wrap(
                        spacing: 8.0,
                        runSpacing: 0.0,
                        children: buildSelectedOptions(state.value),
                      )
                    : isEnabled 
                      ? Container(
                          padding: const EdgeInsets.only(top: 4), 
                          child: hintWidget) 
                      : const SizedBox()
              ],
            ),
          ),
        );
      },
    );
}

class MultiSelectDialogItem<V> {
  const MultiSelectDialogItem(this.value, this.label);

  final V value;
  final String? label;
}

class MultiSelectDialog<V> extends StatefulWidget {
  final List<MultiSelectDialogItem<V>>? items;
  final List<V>? initialSelectedValues;
  final Widget? title;
  final String? okButtonLabel;
  final String? cancelButtonLabel;
  final TextStyle labelStyle;
  final ShapeBorder? dialogShapeBorder;
  final Color? checkBoxCheckColor;
  final Color? checkBoxActiveColor;
  final List<String> additionals;
  final TextInputType? keyboardType;
  final bool allowOther;

  const MultiSelectDialog({
    super.key,
    this.items,
    this.keyboardType,
    this.additionals = const [],
    this.initialSelectedValues,
    this.title,
    this.okButtonLabel,
    this.cancelButtonLabel,
    this.labelStyle = const TextStyle(),
    this.dialogShapeBorder,
    this.checkBoxActiveColor,
    this.checkBoxCheckColor, 
    required this.allowOther}
  );

  @override
  State<StatefulWidget> createState() => _MultiSelectDialogState<V>();
}

class _MultiSelectDialogState<V> extends State<MultiSelectDialog<V>> {
  final _selectedValues = <V>[];
  late List<String> _additionals;
  bool isAdding = false;
  late TextEditingController _controller;
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.initialSelectedValues != null) {
      _selectedValues.addAll(widget.initialSelectedValues!);
    }
    _additionals = List.from(widget.additionals);
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _onItemCheckedChange(V itemValue, bool? checked) {
    setState(() {
      if (checked!) {
        _selectedValues.add(itemValue);
      } else {
        _selectedValues.remove(itemValue);
      }
    });
  }

  void _onAdditionalCheckedChange(String text, bool? checked) {
    setState(() {
      if (checked!) {
        _additionals.add(text);
      } else {
        _additionals.remove(text  );
      }
    });
  }

  void _onCancelTap() {
    List<V> additionals = List<V>.from(widget.additionals.map((a) => "@@$a@@" as V));
    List<V> a = (widget.initialSelectedValues ?? List<V>.empty());
    List<V> all = additionals..addAll(a);
    Navigator.pop(context, all);
  }

  void _onSubmitTap() {
    Navigator.pop(context, _selectedValues..addAll(_additionals.map((a) => "@@$a@@" as V)));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.title,
      shape: widget.dialogShapeBorder,
      contentPadding: const EdgeInsets.only(top: 12.0),
      content: SingleChildScrollView(
        child: Column(children: [
          ListTileTheme(
            contentPadding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
            minVerticalPadding: 0,
            child: ListBody(
              children: [
                ...widget.items!.map(_buildItem).toList(),
                ..._additionals.map(_buildAdditional).toList(),
              ]
            ),
          ),          
          Visibility(visible: isAdding && widget.allowOther, child: Padding(padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0), child: Row(children: [Expanded(child: TextFormField(focusNode: _focus, controller: _controller, keyboardType: widget.keyboardType,)), IconButton(onPressed: _additionalApprovePressed, icon: const Icon(Icons.save))]))),
          Visibility(visible: !isAdding  && widget.allowOther, child: IconButton(onPressed: _addAdditionalPressed, icon: const Icon(Icons.add, color: Colors.black)))
        ]),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: _onCancelTap,
          child: Text(widget.cancelButtonLabel!),
        ),
        TextButton(
          onPressed: _onSubmitTap,
          child: Text(widget.okButtonLabel!),
        )
      ],
    );
  }

  Widget _buildItem(MultiSelectDialogItem<V> item) {
    final checked = _selectedValues.contains(item.value);
    return SizedBox(
      height: 40,
      child: CheckboxListTile(
        value: checked,
        checkColor: widget.checkBoxCheckColor,
        activeColor: widget.checkBoxActiveColor,
        title: Text(item.label!, style: widget.labelStyle),
        controlAffinity: ListTileControlAffinity.leading,
        onChanged: (checked) => _onItemCheckedChange(item.value, checked),
      )
    );
  }

  Widget _buildAdditional(String text) {
    final checked = _additionals.contains(text);
    return CheckboxListTile(
      value: checked,
      checkColor: widget.checkBoxCheckColor,
      activeColor: widget.checkBoxActiveColor,
      title: Text(text, style: widget.labelStyle),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (checked) => _onAdditionalCheckedChange(text, checked),
    );
  }

  void _additionalApprovePressed() {
    setState(() {
      _additionals.add(_controller.text);
      isAdding = false;
    });
  }

  void _addAdditionalPressed() {
    setState(() {
      isAdding = true;
      _focus.requestFocus();
    });
  }
}