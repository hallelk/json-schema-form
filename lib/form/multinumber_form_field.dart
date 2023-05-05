import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MultiNumberFormField extends FormField<List<int?>> {
  final Function? change;
  final bool isEnabled;
  // final int? itemsCount;
  final List<int?>? values;
  final InputDecoration itemDecoration;
  final int? maxValues;
  final int minValues;

  MultiNumberFormField({
    super.key,
    super.onSaved,
    required this.itemDecoration,
    // this.itemsCount, 
    this.change,
    this.isEnabled = true,
    this.values, 
    this.maxValues,
    this.minValues = 1
  }) : super(
        // initialValue: List.generate(itemsCount ?? values?.length ?? 0, (index) => values?.asMap()[index]),
        initialValue: List.generate(values?.length ?? minValues, (index) => values?.asMap()[index]),
        builder: (FormFieldState<List<int?>> state) {
          int valueCount = state.value?.length ?? minValues;

          void doChangeValue(int index, int? value) {
            state.didChange(state.value!..[index] = value);
          }
          
          if (!isEnabled) {
            return Text(values?.where((v) => v != null).join(", ") ?? "");
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 14), 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // children: List.generate(itemsCount ?? state.value?.length ?? 0, (index) => 
              children: List.generate(valueCount, (index) => 
                Column(children: [
                  ActualNumberListItem(
                    width: 100,
                    initialValue: state.value![index],
                    onChangedCallback: (val) => { doChangeValue(index, val) },
                    onRemovedCallback: index < minValues ? null : () => { 
                      state.didChange(state.value!..removeAt(index)) 
                    },
                    fieldDecoration: itemDecoration,
                  ),
                  // SizedBox(width: index == (itemsCount ?? state.value?.length ?? 0) - 1 ? 0 : 5)
                  SizedBox(height: index == valueCount - 1 ? 0 : 9)
                ],)
              )..addAll(
                // itemsCount != null ? [] :
                valueCount >= (maxValues ?? valueCount + 1) ? [] : 
                [
                  SizedBox(width:100, height: 39,
                    child: Center(child: IconButton(
                      icon: const Icon(Icons.add, color:Colors.blue), 
                      // style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size(30, 30), tapTargetSize: MaterialTapTargetSize.shrinkWrap), 
                      onPressed: () => state.didChange(state.value!..add(null))
                    ),
                  ))
                ]
              )
            )
          );
        }
    );
}

class ActualNumberListItem extends StatefulWidget {
  final int? initialValue;
  final Function onChangedCallback;
  final void Function()? onRemovedCallback;
  final double width;
  final InputDecoration fieldDecoration;

  const ActualNumberListItem({
    super.key, 
    this.initialValue, 
    required this.onChangedCallback, 
    this.onRemovedCallback, 
    required this.width, 
    required this.fieldDecoration
  });
  
  @override
  ActualNumberListItemState createState() => ActualNumberListItemState();
}

class ActualNumberListItemState extends State<ActualNumberListItem> {

  late TextEditingController controller;

  @override 
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialValue?.toString());
    controller.addListener(() => { 
      widget.onChangedCallback(num.tryParse(controller.text)) 
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      SizedBox(
        width: widget.width,
        child: TextField(
          onTap: () => controller.selection = TextSelection(baseOffset: 0, extentOffset: controller.value.text.length),
          controller: controller,
          decoration: widget.fieldDecoration,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly, 
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
          ] 
        ),
      ),
      widget.onRemovedCallback != null 
        ? IconButton(
            onPressed: widget.onRemovedCallback, 
            icon: const Icon(Icons.delete, size: 15), 
            padding: const EdgeInsets.symmetric(horizontal: 5), 
            iconSize: 15,
            constraints: const BoxConstraints(maxHeight: 15),
          )
        : const SizedBox()
    ]);
  }
}