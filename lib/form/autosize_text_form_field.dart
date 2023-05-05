import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';

class AutosizeTextFormField extends FormField<String> {
  AutosizeTextFormField({
    super.key, 
    super.onSaved,
    super.validator,
    super.initialValue,
    InputDecoration? decoration,
    required bool enabled,
    TextInputType? keyboardType = TextInputType.text,
    TextAlign? textAlign,
    int? maxLength
  })
  : super(
      builder: (FormFieldState<String> state) {
        return AutoSizeTextField(
          maxLength: maxLength,
          keyboardType: keyboardType,
          textAlign: textAlign ?? TextAlign.start,
          controller: TextEditingController(text: initialValue),
          maxLines: null,
          decoration: decoration ?? InputDecoration(
            border: InputBorder.none,
            isDense: true,
            enabled: enabled,
          ),
        );
      }
    );
}