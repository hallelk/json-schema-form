import 'package:flutter/material.dart';

// TODO : rewrite it all
typedef OptionButtonsBuilder = List<Widget> Function(BuildContext context);

class _OptionButtonContainer extends StatelessWidget {
  const _OptionButtonContainer({
    super.key, 
    this.alignment = AlignmentDirectional.centerStart, 
    required this.child
  });

  final Widget child;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 48), // TODO: avoid specifying size if not necesary
      alignment: alignment,
      child: child,
    );
  }
}

class OptionButton<T> extends _OptionButtonContainer {
  const OptionButton({
    Key? key,
    this.onTap,
    required this.title,
    this.value,
    this.enabled = true,
    AlignmentGeometry alignment = AlignmentDirectional.centerStart,
    required Widget child,
  }) : super(key: key, alignment:alignment, child: child);

  final VoidCallback? onTap;
  final T? value;
  final bool enabled;
  final String title;
}

class OptionButtonsFormField<T> extends FormField<T> {
  
  OptionButtonsFormField({
    super.key,
    super.onSaved,
    super.validator,
    super.autovalidateMode = AutovalidateMode.disabled,
    super.initialValue,
    required Map<String, T> items,
    this.onChanged,
    bool enabled = true,
    List<List<int>>? layout,
    double? itemHeight,
    Color? focusColor,
    InputDecoration? decoration,
  }) : assert(items.isEmpty || initialValue == null ||
              items.values.where((T item) {
                return item == initialValue;
              }).length == 1,
                "There should be exactly one item with [OptionButton]'s value: "
                '$initialValue. \n'
                'Either zero or 2 or more [OptionButton]s were detected '
                'with the same value',
              ),
      assert(itemHeight == null || itemHeight >= kMinInteractiveDimension),
      decoration = decoration ?? InputDecoration(focusColor: focusColor),
      super(
        builder: (FormFieldState<T> state) {

          return ActualWidget(
            isError: () => state.hasError,
            enabled: enabled,
            items: items,
            initialValue: initialValue,
            layout: layout ?? [List.generate(items.length, (i) => i)],
            onChanged: state.didChange);
          }
        );       

  final ValueChanged<T?>? onChanged;
  final InputDecoration decoration;

  @override
  FormFieldState<T> createState() => _OptionButtonsFormFieldState<T>();
}

class ActualWidget<T> extends StatefulWidget {
  final Function isError;
  final Map<String, T> items;
  final T? initialValue;
  final List<List<int>> layout;
  final bool enabled;
  final Function onChanged;

  const ActualWidget({
    super.key, 
    required this.items, required this.layout, required this.enabled, required this.onChanged, required this.isError,
    this.initialValue});

  @override
  ActualWidgetState createState() => ActualWidgetState();
}

class ActualWidgetState<T> extends State<ActualWidget> {
  late T? currentValue;
  late List<List<int>> layout;

  @override 
  void initState() {
    super.initState();
    currentValue = widget.initialValue;
    layout = widget.layout;
  }
  
  @override
  Widget build(BuildContext context) {
    return widget.enabled 
    ? Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(layout.length, (i) { 
          List<int> layoutRow = layout[i]; 

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,  
            children: List.generate(layoutRow.length, (j) {
              MapEntry item = widget.items.entries.elementAt(layoutRow[j]);

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      side: widget.isError() 
                        ? const BorderSide(color: Colors.red) // TODO: find exact color
                        : null,
                      backgroundColor: (item.value == currentValue) 
                        ? const Color(0xff64b464)
                        : null,
                    ),
                    child: Text(
                      item.key,
                      textAlign: TextAlign.center,
                      style: (item.value == currentValue) 
                        ? const TextStyle(color: Colors.white, fontWeight: FontWeight.bold )
                        : const TextStyle(color: Colors.black, fontWeight: FontWeight.normal )
                    ),
                    onPressed: () => _optionPressed(item.value), 
                  )
                )
              );
            })
          );
        })
      ) 
    : Text(getStringValue());
  }

  String getStringValue() => 
    currentValue != null 
      ? widget.items.entries.singleWhere((element) => element.value == currentValue).key
      : ""; 

  void _optionPressed(T value) {
    setState(() { currentValue = value == currentValue ? null : value; });
    widget.onChanged(currentValue);
  }
}

class _OptionButtonsFormFieldState<T> extends FormFieldState<T> {
  @override
  OptionButtonsFormField<T> get widget => super.widget as OptionButtonsFormField<T>;

  @override
  void didChange(T? value) {
    super.didChange(value);
    assert(widget.onChanged != null);
    widget.onChanged!(value);
  }

  @override
  void didUpdateWidget(OptionButtonsFormField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialValue != widget.initialValue) {
      setValue(widget.initialValue);
    }
  }
}
