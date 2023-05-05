import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberUpDownFormField extends FormField<num> {
  final Function? onChanged;
  final bool isEnabled;
  final InputDecoration itemDecoration;
  final num? maxValue;
  final num? minValue;
  final num? step;

  NumberUpDownFormField({
    super.key,
    super.onSaved,
    super.initialValue,
    required this.itemDecoration,
    this.onChanged,
    this.isEnabled = true,
    this.maxValue,
    this.minValue = 0,
    this.step = 1,
  }) 
  : super(builder: (FormFieldState<num> state) {

      TextEditingController controller = 
        TextEditingController(text: state.value?.toString() ?? "");
      
      void doChangeValue(num value) {
        state.didChange(value);
        if (onChanged != null) {
          onChanged(value);
        }
      }

      return Row(
        children: [
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero, 
              minimumSize: const Size(30, 30), 
              tapTargetSize: MaterialTapTargetSize.shrinkWrap
            ),
            onPressed: (state.value! > minValue!) 
              ? () => doChangeValue(state.value! - step!) 
              : null,
            child: const Text("-")
          ),
          SizedBox(
            width: 40,
            child: TextField(
              enabled: false,
              readOnly: true,
              controller: controller,
              decoration: itemDecoration,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly, 
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
              ] 
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero, 
              minimumSize: const Size(30, 30), 
              tapTargetSize: MaterialTapTargetSize.shrinkWrap
            ),
            onPressed: state.value! < (maxValue ?? state.value! + 1) 
              ? () => doChangeValue(state.value! + step!) 
              : null,
            child: const Text("+")),
        ]
      );
    }
  );
}