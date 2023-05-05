import 'package:flutter/material.dart';

class BooleanFormField extends FormField<bool> {
  BooleanFormField({
    super.key,    
    super.onSaved,
    super.validator,
    super.initialValue,
    bool enabled = true
  })
  : super(
      builder: (FormFieldState<bool> state) {
        return enabled 
          ? Checkbox(
              value: state.value,
              onChanged: state.didChange,
            )
          : Text(initialValue ?? false ? "S.current.commonYes" : "S.current.commonNo");
      }
    );
}