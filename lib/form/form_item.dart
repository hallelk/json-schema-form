import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_schema_form/form/autosize_text_form_field.dart';
// import 'package:latlong2/latlong.dart';
import 'boolean_form_field.dart';
import 'combobox_form_field.dart';
// import 'common_images_form_field.dart';
// import 'images_form_field.dart';
import 'multinumber_form_field.dart';
import 'number_updown_formfield.dart';
// import 'tree_images_form_field.dart';
// import 'userslist_form_field.dart';
// import 'map_polygon_field.dart';
import 'option_buttons_form_field.dart';
import 'multiselect_form_field.dart';

abstract class FormItem extends StatefulWidget {
  final String title;
  final String? subtitle;
  final String mode;
  final String fieldName;
  final dynamic fieldValue;
  final dynamic fieldItem;
  final Function onSavedCallback;
  final bool isFullSize;
  final bool isVisible;
  
  const FormItem({
    super.key, 
    required this.title, required this.mode, required this.fieldName, required this.onSavedCallback,
    this.subtitle, this.fieldValue, this.fieldItem, this.isFullSize = false, this.isVisible = true});
}

abstract class _FormItemState<T extends FormItem> extends State<T>{

  Widget buildItem(FormField field, BuildContext context, {double? itemValueWidthFactor, double? itemHeight}) {
    
    if (widget.isVisible == false) return const SizedBox();

    Size ctxSize = MediaQuery.of(context).size;
    double  titleWidth = widget.isFullSize ? 0 : ctxSize.width * 8 / 33,
            valueWidth = (ctxSize.width * (widget.isFullSize ? 30.5 : 22) / 33)  * (itemValueWidthFactor ?? 1),
            // warningWidth = widget.isFullSize ? 0 : ctxSize.width * 3 / 33,
            horizontalPadding = ctxSize.width * 0.5 / 33,
            verticalMargin = 0,
            itemWidth = (ctxSize.width * 32 / 33);

    return Container(
      height: itemHeight,
      width: itemWidth, 
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      margin: EdgeInsets.symmetric(vertical: verticalMargin),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
        // title
        SizedBox(
          // padding: EdgeInsets.symmetric(vertical: 10),
          width: titleWidth, 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end, 
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(widget.title, style: const TextStyle(fontFamily: "Alef", fontWeight: FontWeight.bold, fontSize: 13, leadingDistribution: TextLeadingDistribution.proportional), textAlign: TextAlign.end, ),
              widget.subtitle != null 
                ? Text(widget.subtitle ?? "", style: const TextStyle(fontFamily: "Alef", fontWeight: FontWeight.bold, fontSize: 11, color: Colors.grey))
                : Container()
            ]
          )
        ),
        // value
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16), 
          alignment: Alignment.topRight, 
          width: valueWidth, 
          child: field
        ),
        // isFull
        // Container(
        //   alignment: Alignment.topRight, 
        //   width: warningWidth, 
        //   child: Center(child: 
        //     widget.mode != FormMode.INSERT && widget.fieldValue == null 
        //       ? Icon(Icons.warning_amber_rounded, color: Colors.red,)
        //       : Container()
        //   )
        // )
      ])])
    );
  }

  InputDecoration inputDecoration() => 
    widget.mode == "FormMode.read"
      ? const InputDecoration(border: InputBorder.none)
      : const InputDecoration(border: OutlineInputBorder(borderSide: BorderSide(width: 1), gapPadding: 0), isDense: true, contentPadding: EdgeInsets.all(4), counterText: "", counterStyle: TextStyle(fontSize: 1));
}

class TextFormItem extends FormItem {
  final bool isMultiline;
  final TextInputType? keyboardType;
  final FormFieldValidator<String?>? validator;
  final Function? onChangedCallback;
  final bool isPassword;
  final String? infoText;
  final List<TextInputFormatter>? formatters;
  final int? maxLength;

  const TextFormItem({
    super.key, 
    required super.title, 
    required super.fieldName, 
    required super.mode, 
    required super.onSavedCallback, 
    super.isVisible = true, 
    super.subtitle, 
    super.fieldValue, 
    super.fieldItem, 
    this.onChangedCallback, 
    this.validator, 
    this.infoText, 
    this.formatters,
    this.isMultiline = true, 
    this.keyboardType, 
    this.isPassword = false, 
    this.maxLength, 
  });

  TextFormItem.phone({
    super.key, 
    required super.title, 
    required super.fieldName, 
    required super.mode, 
    required super.onSavedCallback, 
    super.isVisible = true, 
    super.subtitle, 
    super.fieldValue, 
    super.fieldItem,  
    this.onChangedCallback, 
    this.validator, 
    this.infoText,
    this.maxLength}) 
  : isMultiline = false,
    keyboardType = TextInputType.phone,
    isPassword = false, 
    formatters = [FilteringTextInputFormatter.allow(RegExp(r'[0-9 \-\.]'))];

  @override
  TextFormItemState createState() => TextFormItemState();
}

class TextFormItemState extends _FormItemState<TextFormItem> {

  bool _isObscurePassword = true;
  String? _value;
  late List<Widget> _suffixIcons;
  late TextEditingController _controllerHelper;
  late TextEditingController _controller;

  void _toggleObscure() {
    setState(() {
      _isObscurePassword = !_isObscurePassword;
    });
  }

  void _showInfo() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(widget.infoText!)));
  }

  @override
  void initState() {
    super.initState();
    _value = widget.fieldValue;
    _controller = TextEditingController(text: _value);
    _controllerHelper = TextEditingController(text: _value);
    _suffixIcons = List<Widget>.from([]);
    
    if (widget.isPassword) {
      _suffixIcons.add(
        InkWell(
          onTap: _toggleObscure,
          child: Padding(padding: const EdgeInsets.symmetric(horizontal : 5),
            child: Icon(_isObscurePassword 
              ? Icons.visibility_rounded 
              : Icons.visibility_off_rounded
            )
          )
        )
      );
    }

    if (widget.infoText != null) {
      _suffixIcons.add(
        InkWell(
          onTap: _showInfo,
          child: const Padding(padding: EdgeInsets.symmetric(horizontal : 5),
            child: Icon(Icons.info_outline)
          )
        )
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _controllerHelper.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return super.buildItem(widget.mode == "FormMode.read" 
      ? AutosizeTextFormField(
          enabled: false,
          initialValue: _controller.value.text,
          maxLength: widget.maxLength,
        ) 
      : TextFormField(
          inputFormatters: widget.formatters,
          obscureText: widget.isPassword && _isObscurePassword,
          enableInteractiveSelection : !widget.isPassword,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: widget.validator,
          maxLines: 1,
          maxLength: widget.maxLength,
          showCursor: !widget.isMultiline,
          readOnly: widget.isMultiline,
          onChanged: widget.onChangedCallback != null ? (s) { widget.onChangedCallback!(s); } : null,
          onTap: widget.mode == "FormMode.read" || !widget.isMultiline ? null : () {
            showDialog<String>(context: context, builder: (context) {
              return AlertDialog(
                title: Text(widget.title),
                actions: [
                  TextButton(
                    onPressed: () => { Navigator.pop(context, _controllerHelper.text) }, 
                    child: const Text("S.current.commonSave")
                  ),
                  TextButton(
                    child: const Text("S.current.commonCancel"),
                    onPressed: () => { Navigator.pop(context) },
                  )
                ],
                content: TextField(
                  autofocus: true,
                  maxLines: 5, 
                  keyboardType: TextInputType.text,
                  controller: _controllerHelper,
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                ), 
              );
            })
            .then((value) => setState(() {
              if (value != null) {
                _controller.text = value;
              }
            }));
          },
          onSaved: (newValue) { 
            widget.onSavedCallback(widget.fieldName, (newValue?.isEmpty ?? true) ? null : newValue);
          },
          decoration: widget.isPassword 
            ? InputDecoration(
                errorStyle: widget.infoText != null ? const TextStyle(fontSize: 0.01) : null,
                border: const OutlineInputBorder(borderSide: BorderSide(width: 1), gapPadding: 0), 
                isDense: true, 
                contentPadding: const EdgeInsets.all(4),
                suffixIconConstraints: const BoxConstraints.tightFor(),
                suffixIcon: Row(mainAxisSize: MainAxisSize.min, children: _suffixIcons)
              )
            : inputDecoration(),
          controller: _controller,
          enabled: widget.mode != "FormMode.read",
          // onChanged: (_) {print("change");},
          keyboardType: widget.keyboardType ?? TextInputType.text,
        ), 
      context,
      itemHeight: 56
    );
  }
}

class NumberFormItem extends FormItem {
  final bool isInteger;
  final Function? onChangedCallback;
  final int? maxLength;

  const NumberFormItem({
    super.key, required super.title, required super.fieldName, required super.mode, required super.onSavedCallback, 
    super.fieldValue, super.fieldItem, super.subtitle,  super.isVisible = true, 
    this.onChangedCallback, this.isInteger = false, this.maxLength = 9,});
    // TODO : watch maxLength. make specific

  @override
  NumberFormItemState createState() => NumberFormItemState();
}

class NumberFormItemState extends _FormItemState<NumberFormItem> {
  late TextEditingController controller;

  void _changed(val) {
    if (widget.onChangedCallback != null) {
      widget.onChangedCallback!(val == "" ? null : num.parse(val));
    }
  }

  @override 
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.fieldValue?.toString());
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  String? numberValidator(String? value) {
    if(value == null || value.isEmpty) {
      return null;
    }

    final n = num.tryParse(value);
    if(n == null) {
      return ' ';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return super.buildItem(
      TextFormField(
        onSaved: (newValue) => widget.onSavedCallback(widget.fieldName, (newValue ?? "") == "" ? null : num.parse(newValue!)),
        decoration: inputDecoration().copyWith(counterText: "", errorStyle: const TextStyle(fontSize: 0.1)),
        enabled: widget.mode != "FormMode.read",
        inputFormatters: widget.isInteger ? [FilteringTextInputFormatter.digitsOnly, FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))] 
                                          : [FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]'))],
        validator: numberValidator,
        onChanged: _changed,
        keyboardType: TextInputType.number,
        maxLength: widget.maxLength,
        controller: controller,
        onTap: () => controller.selection = TextSelection(baseOffset: 0, extentOffset: controller.value.text.length),
      ), 
      context,
      itemHeight: 56
    );
  }
}

class NumberUpDownFormItem extends FormItem {
  final Function? onChangedCallback;
  final int? minValue;
  final int? maxValue;
  final int? step;

  const NumberUpDownFormItem({
    super.key, 
    required super.title, required super.fieldName, required super.mode, required super.onSavedCallback,
    super.subtitle, super.fieldValue, super.fieldItem, super.isVisible = true,
    this.minValue, this.maxValue, this.step, this.onChangedCallback
  });

  @override
  NumberUpDownFormItemState createState() => NumberUpDownFormItemState();
}

class NumberUpDownFormItemState extends _FormItemState<NumberUpDownFormItem> {
  
  dynamic _value;

  @override
  void initState() {
    super.initState();
    _value = widget.fieldValue;
  }

  void updateState(dynamic val) {
    setState(() => _value = val);
    if (widget.onChangedCallback != null) {
      widget.onChangedCallback!(val);
    }
  }

  @override
  Widget build(BuildContext context) {
    return super.buildItem(
      NumberUpDownFormField(
        onSaved: (newValue) => widget.onSavedCallback(widget.fieldName, newValue),
        itemDecoration: inputDecoration(),
        isEnabled: widget.mode != "FormMode.read", 
        initialValue: _value,
        onChanged: updateState,
        minValue: widget.minValue,
        maxValue: widget.maxValue,
        step: widget.step
      ), 
      context,
      itemHeight: 56,
      itemValueWidthFactor: 0.6
    );
  }
}

class MultiNumberFormItem extends FormItem {
  final int? itemsCount;
  final int? maxValues;

  const MultiNumberFormItem({Key? key, required title, subtitle, required fieldName, fieldValue, fieldItem, required mode, required onSavedCallback, bool isVisible = true, this.itemsCount, this.maxValues})
   : super(key: key, onSavedCallback: onSavedCallback, title: title, subtitle: subtitle, mode: mode, fieldName: fieldName, fieldValue: fieldValue, fieldItem: fieldItem, isVisible: isVisible);

  @override
  MultiNumberFormItemState createState() => MultiNumberFormItemState();
}

class MultiNumberFormItemState extends _FormItemState<MultiNumberFormItem> {
  
  dynamic _values;
  late int? itemsCount;

  @override
  void initState() {
    super.initState();
    _values = widget.fieldValue;
    itemsCount = widget.itemsCount;
  }

  @override
  Widget build(BuildContext context) {
    return super.buildItem(
      MultiNumberFormField(
        onSaved: (newValue) => widget.onSavedCallback(widget.fieldName, (newValue ?? []).toList()),
        itemDecoration: inputDecoration(),
        isEnabled: widget.mode != "FormMode.read", 
        maxValues: widget.maxValues,
        values: _values,
      ), 
      context,
    );
  }
}

class FormValidationItem extends FormItem {
  final FormFieldValidator validator;

  FormValidationItem({Key? key, required this.validator, fieldValue, fieldItem, required mode, bool isVisible = true})
   : super(key: key, onSavedCallback: () => {}, title: "", mode: mode, fieldName: "", isVisible: isVisible);

  @override
  FormValidationItemState createState() => FormValidationItemState();
}

class FormValidationItemState extends _FormItemState<FormValidationItem> {
  
  @override
  Widget build(BuildContext context) {
    return super.buildItem(
      FormField(
        initialValue: "",
        validator: (x) => widget.validator(x),
        builder: (_) => SizedBox(
          height: 20, 
          child: Text(
            widget.validator("") ?? "", 
            style: const TextStyle(color: Colors.red),
          ),
        ), 
      ), 
      context,
    );
  }
}

class DateFormItem extends FormItem {
  final bool isDateTime;
  const DateFormItem({Key? key, required title, subtitle, required fieldName, fieldValue, fieldItem, required mode, required onSavedCallback, bool isVisible = true, this.isDateTime = false})
   : super(key: key, onSavedCallback: onSavedCallback, title: title, subtitle: subtitle, mode: mode, fieldName: fieldName, fieldValue: fieldValue, fieldItem: fieldItem, isVisible: isVisible);

  @override
  DateFormItemState createState() => DateFormItemState();
}

class DateFormItemState extends _FormItemState<DateFormItem> {

  @override
  Widget build(BuildContext context) {
    return super.buildItem(
      DateTimeFormField(
        onSaved: (newValue) {
          widget.onSavedCallback(widget.fieldName, newValue);
        },
        decoration: inputDecoration(),
        enabled: widget.mode != "FormMode.read",
        mode: widget.isDateTime ? DateTimeFieldPickerMode.dateAndTime : DateTimeFieldPickerMode.date,
        initialValue: widget.fieldValue ?? DateTime.now(),
      ), 
      context,
      itemHeight: 56
    );
  }
}

class BooleanFormItem extends FormItem {
  const BooleanFormItem({
    super.key, 
    required super.onSavedCallback, 
    required super.title, 
    required super.fieldName, 
    required super.mode, 
    super.subtitle, 
    super.fieldValue, 
    super.fieldItem, 
    super.isVisible = true
  });

  @override
  BooleanFormItemState createState() => BooleanFormItemState();
}

class BooleanFormItemState extends _FormItemState<BooleanFormItem> {
  
  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height: 48, 
      child: super.buildItem(
        BooleanFormField(
          onSaved: (newValue) => widget.onSavedCallback(widget.fieldName, newValue),
          initialValue: widget.fieldValue,
          enabled: widget.mode != "FormMode.read",
        ), 
        context,
        itemHeight: 56
      )
    );
  }
}

class ComboboxFormItem<T extends Value> extends FormItem {
  final List<T> items;
  final String? hint;
  final Future<T> Function(String name)? onAdd;
  final List<T> Function()? itemsFn;
  final List<T>? suggestions;

  const ComboboxFormItem({
    super.key, 
    required super.title, 
    required super.fieldName, 
    required super.onSavedCallback, 
    required super.mode, 
    super.fieldValue, 
    super.fieldItem, 
    super.subtitle, 
    super.isVisible = true,
    required this.items, 
    this.hint, 
    this.onAdd, this.itemsFn, 
    this.suggestions
  });
   
  @override
  ComboboxFormItemState createState() => ComboboxFormItemState();
}

class ComboboxFormItemState<T extends Value> extends _FormItemState<ComboboxFormItem<T>> {
  
  late T? _value;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _value = widget.fieldValue;
    _controller = TextEditingController(text: _value?.toString());
  }

  void _showComboboxDialog() {
    showDialog<T>(context: context, builder: (context) {
      return AlertDialog(
        title: Text(widget.title),
        content: SizedBox(
          width: 400,
          height: 900, 
          child: ComboboxFormField<T>(
            items: widget.items,
            itemsFn: widget.itemsFn,
            onSaved: (newValue) => 
              widget.onSavedCallback(widget.fieldName, newValue?.getValue()),
            initialValue: widget.fieldValue,
            onAdd: widget.onAdd,
            suggestions: widget.suggestions
          ),
        )
      );
    })
    .then((value) => 
      setState(() {
        _value = value;

        if (value != null) {
          _controller.text = value.toString();
        }
      })
      );
  }

  @override
  Widget build(BuildContext context) {
    return super.buildItem(
      TextFormField(
        maxLines: 1,
        showCursor: false,
        readOnly: true,
        onTap: widget.mode == "FormMode.read" ? null : _showComboboxDialog,
        onSaved: (_) => widget.onSavedCallback(widget.fieldName, _value?.getValue()),
        decoration: inputDecoration(),
        enabled: widget.mode != "FormMode.read",
        onChanged: (_) {},
        controller: _controller,
      ),
      context,
      itemHeight: 56
    );
  }
}

class DropDownFormItem<T extends DropDownValue> extends FormItem {
  const DropDownFormItem({this.hint, required this.items, this.allowUpdate = false,
                        Key? key, required title, subtitle, required fieldName, fieldValue, fieldItem, required mode, required onSavedCallback, bool isVisible = true, this.onChanged})
                        : super(key: key, onSavedCallback: onSavedCallback, mode: mode, title: title, subtitle: subtitle, fieldName: fieldName, fieldValue: fieldValue, fieldItem: fieldItem, isVisible: isVisible);
  final List<T> items;
  final String? hint;
  final bool allowUpdate;
  final void Function(dynamic)? onChanged;

  @override
  DropDownFormItemState createState() => DropDownFormItemState();
}

class DropDownFormItemState<T extends DropDownValue> extends _FormItemState<DropDownFormItem<T>> {
  
  FormField _readOnly() {
    int valIdx = widget.items.indexWhere((e) => e.getValue() == widget.fieldValue);

    return TextFormField(
      decoration: inputDecoration(),
      initialValue: valIdx >= 0 ? widget.items[valIdx].toString() : "",
      enabled: false
    );
  }

  FormField _insertUpdate() {
     List<DropdownMenuItem> items = widget.items.map((e) => 
        DropdownMenuItem(value: e.getValue(), child: Text(e.toString()))
      ).toList();

    return DropdownButtonFormField(
      menuMaxHeight: 250,
      onSaved: (newValue) => widget.onSavedCallback(widget.fieldName, newValue == "" ? null : newValue),
      isExpanded: true,
      decoration: inputDecoration().copyWith(
        errorStyle: const TextStyle(fontSize: 0.01)
      ),
      value: widget.fieldValue,
      items: items,
      hint: Text(widget.hint ?? ""), 
      onChanged: widget.onChanged,
      validator: (v) => v == null ? "" : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    FormField field;

    switch (widget.mode) {
      case "FormMode.insert": field = _insertUpdate(); break;
      case "FormMode.update": field = widget.allowUpdate ? _insertUpdate() : _readOnly(); break;
      case "FormMode.read": 
      default: 
        field = _readOnly(); break;
    }

    return  super.buildItem(field, context, itemHeight: 56);
  }
}

/*
class TreeImagesFormItem extends FormItem {
  final int maxAllowed;
  final IconData? icon;
  final bool? isFile;

  const TreeImagesFormItem({Key? key, this.maxAllowed = 3, this.isFile, required title, this.icon, subtitle, required fieldName, fieldValue, fieldItem, required mode, required onSavedCallback, bool isVisible = true})
   : super(key: key, onSavedCallback: onSavedCallback,mode: mode, title: title, subtitle: subtitle, fieldName: fieldName, fieldValue: fieldValue, fieldItem: fieldItem, isFullSize: true, isVisible: isVisible);
  
  @override
  TreeImagesFormItemState createState() => TreeImagesFormItemState();
}

class TreeImagesFormItemState extends _FormItemState<TreeImagesFormItem> {
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return super.buildItem(
      TreeImagesFormField(
        onSaved: (newValue) {
          widget.onSavedCallback(widget.fieldName, newValue);
        },
        value: widget.fieldValue, 
        isEnabled: widget.mode != "FormMode.read",
        validator: (value) {
          return (value?.any((i) => i.imagePath == null) ?? false) ? "": null;
        },
        maxAllowed: widget.maxAllowed,
        icon: widget.icon,
        mode: widget.isFile == null ? null : (widget.isFile! ? PickerMode.gallery : PickerMode.camera) ,
      ), 
      context
    );
  }
}
*/

/*
class ImagesFormItem extends FormItem {
  final int maxAllowed;
  final IconData? icon;
  final bool? isFile;

  const ImagesFormItem({Key? key, this.maxAllowed = 3, this.isFile, required title, this.icon, subtitle, required fieldName, fieldValue, fieldItem, required mode, required onSavedCallback, bool isVisible = true})
   : super(key: key, onSavedCallback: onSavedCallback,mode: mode, title: title, subtitle: subtitle, fieldName: fieldName, fieldValue: fieldValue, fieldItem: fieldItem, isFullSize: true, isVisible: isVisible);
  
  @override
  ImagesFormItemState createState() => ImagesFormItemState();
}

class ImagesFormItemState extends _FormItemState<ImagesFormItem> {
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return super.buildItem(
      ImagesFormField(
        onSaved: (newValue) {
          widget.onSavedCallback(widget.fieldName, newValue);
        },
        value: widget.fieldValue, 
        isEnabled: widget.mode != "FormMode.read",
        validator: (value) {
          return (value?.any((i) => i.location == '') ?? false) ? "": null;
        },
        maxAllowed: widget.maxAllowed,
        icon: widget.icon,
        mode: widget.isFile == null ? null : (widget.isFile! ? PickerMode.gallery : PickerMode.camera) ,
      ), 
      context
    );
  }
}
*/

/*
class MapPolygonFormItem extends FormItem {
  final Function address;

  const MapPolygonFormItem({Key? key, required this.address, required title, subtitle, required fieldName, fieldValue, fieldItem, required mode, required onSavedCallback, bool isVisible = true})
   : super(key: key, onSavedCallback: onSavedCallback,mode: mode, title: title, subtitle: subtitle, fieldName: fieldName, fieldValue: fieldValue, fieldItem: fieldItem, isVisible: isVisible);
  
  @override
  MapPolygonFormItemState createState() => MapPolygonFormItemState();
}

class MapPolygonFormItemState extends _FormItemState<MapPolygonFormItem> {
  late List<LatLng>? _value;

  @override
  void initState() {
    super.initState();
    _value = widget.fieldValue;
  }

  @override
  Widget build(BuildContext context) {
    return super.buildItem(
      MapPolygonField(
        onSaved: (newValue) {
          widget.onSavedCallback(widget.fieldName, newValue);
        },
        address: widget.address,
        initialValue: _value,
        isEnabled: widget.mode != "FormMode.read",
        change: (_) => setState(() => _value = _),
      ), 
      context,
      itemHeight: 56
    );
  }
}
*/

class OptionButtonsFormItem extends FormItem {
  const OptionButtonsFormItem({this.layout, required this.items, this.onChangedCallback,
                        Key? key, required title, subtitle, required fieldName, fieldValue, fieldItem, required mode, required onSavedCallback, bool isVisible = true, this.validator})
                         : super(key: key, onSavedCallback: onSavedCallback,title: title, subtitle: subtitle, mode: mode, fieldName: fieldName, fieldValue: fieldValue, fieldItem: fieldItem, isVisible: isVisible);
  final Map<String, dynamic> items;
  final List<List<int>>? layout;
  final Function? onChangedCallback;
  final FormFieldValidator<dynamic>? validator;

  @override
  OptionButtonsFormItemState createState() => OptionButtonsFormItemState();
}

class OptionButtonsFormItemState extends _FormItemState<OptionButtonsFormItem> {

  dynamic _value;

  @override
  void initState() {
    super.initState();
    _value = widget.fieldValue;
  }

  @override
  Widget build(BuildContext context) {
    return super.buildItem(
      OptionButtonsFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: widget.validator,
        onSaved: (newValue) { widget.onSavedCallback(widget.fieldName, newValue == "" ? null : newValue); },
        decoration: inputDecoration(),
        enabled: widget.mode != "FormMode.read",
        initialValue: _value,
        items: widget.items,
        onChanged: widget.onChangedCallback != null 
          ? (_) {
              setState(() => _value = _);
              widget.onChangedCallback!(_);
            }
          : (_) => setState(() => _value = _),
        layout: widget.layout,
      ), 
      context,
      itemHeight: 56
    );
  }
}

class MultiSelectFormItem extends FormItem {
  const MultiSelectFormItem({ required this.items, this.keyboardType, Key? key, required title, subtitle, required fieldName, fieldValue, fieldItem, required mode, required onSavedCallback, this.allowOther = true, bool isVisible = true }) 
    : super(key: key, onSavedCallback: onSavedCallback,title: title, subtitle: subtitle, mode: mode, fieldName: fieldName, fieldValue: fieldValue, fieldItem: fieldItem, isVisible: isVisible);
  
  final TextInputType? keyboardType;
  final Map<String, dynamic> items;
  final bool allowOther;
  
  @override
  MultiSelectFormItemState createState() => MultiSelectFormItemState();
}

class MultiSelectFormItemState extends _FormItemState<MultiSelectFormItem> {

  late List<String>? _value;
  late List<dynamic> _items;

  @override
  void initState() {
    super.initState();
    _value = widget.fieldValue == null || widget.fieldValue == "" ? [] : (widget.fieldValue as String).split("|");
    _value = (_value?.isEmpty ?? true) ? null : _value;
    _items = widget.items.entries.map((e) => { "display": e.value, "value": e.key }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return super.buildItem(
      MultiSelectFormField(
        onSaved: (newValue) { 
          widget.onSavedCallback(widget.fieldName, newValue == null || newValue == "" || (newValue is List && newValue.isEmpty)  ? null : (newValue as List).join("|")); 
        },
        // decoration: inputDecoration(),
        required: false,
        isEnabled: widget.mode != "FormMode.read",
        initialValue: _value,
        dataSource: _items,
        textField: 'display',
        valueField: 'value',
        okButtonLabel: "S.current.commonSave",
        cancelButtonLabel: "S.current.commonCancel",
        change: (_) => setState(() => _value = _),
        title: Text(widget.title),
        hintWidget: const Icon(Icons.add, color: Colors.black,),
        trailing: const SizedBox(),
        border: InputBorder.none,
        allowOther: widget.allowOther,
        keyboardType: widget.keyboardType
      ), 
      context
    );
  }
}

/*
class UsersListFormItem<T extends ItemsListValue> extends FormItem {
  final List<UserShallow>? items;
  final bool? allowAdd;
  final String? fieldHint;

  const UsersListFormItem({ 
    super.key, 
    required super.title, required super.fieldName, required super.mode, required super.onSavedCallback,
    super.fieldValue, super.fieldItem, super.subtitle, super.isVisible = true, 
    this.items, this.allowAdd = true, this.fieldHint});
  
  @override
  UserListFormItemState createState() => UserListFormItemState();
}

class UserListFormItemState<T extends ItemsListValue> extends _FormItemState<UsersListFormItem<T>> {

  late List<UserListItem>? _value;

  @override
  void initState() {
    super.initState();
    _value = widget.fieldValue;
  }

  @override
  Widget build(BuildContext context) {
    return super.buildItem(
      UsersListFormField(
        onSaved: (newValue) { widget.onSavedCallback(widget.fieldName, newValue); },
        // decoration: inputDecoration(),
        required: false,
        isEnabled: widget.mode != "FormMode.read",
        initialValue: _value,
        textField: 'display',
        valueField: 'value',
        okButtonLabel: S.current.commonSave,
        cancelButtonLabel: S.current.commonCancel,
        change: (_) => setState(() => _value = _),
        title: Text(widget.title),
        hintWidget: const Icon(Icons.add, color: Colors.black,),
        trailing: const SizedBox(),
        border: InputBorder.none,
        allowAdd: widget.allowAdd,
        items: widget.items,
        hint: widget.fieldHint
      ), 
      context
    );
  }
}
*/

abstract class DropDownValue {
  @override
  String toString();
  dynamic getValue();
}