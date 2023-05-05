// // ignore_for_file: unnecessary_const

// import 'package:core/core.dart';
// import 'package:flutter/material.dart';
// import 'package:qtree/utils/validators.dart';

// // TODO : rewrite
// class UsersListFormField<T extends UserListItem> extends FormField<dynamic> {
//   final Widget title;
//   final Widget hintWidget;
//   final bool required;
//   final String errorText;
//   final String? textField;
//   final String? valueField;
//   final Function? change;
//   final Function? open;
//   final Function? close;
//   final Widget? leading;
//   final Widget? trailing;
//   final String okButtonLabel;
//   final String cancelButtonLabel;
//   final Color? fillColor;
//   final InputBorder? border;
//   final TextStyle? chipLabelStyle;
//   final Color? chipBackGroundColor;
//   final TextStyle dialogTextStyle;
//   final ShapeBorder dialogShapeBorder;
//   final Color? checkBoxCheckColor;
//   final Color? checkBoxActiveColor;
//   final bool isEnabled;
//   final TextInputType? keyboardType;
//   final List<UserShallow>? items;
//   final bool? allowAdd;
//   final String? hint;

//   UsersListFormField({
//     super.key,
//     super.onSaved,
//     super.validator,
//     super.autovalidateMode = AutovalidateMode.disabled,
//     super.initialValue,
//     this.leading,
//     this.title = const Text('Title'),
//     this.hintWidget = const Text('Tap to select one or more'),
//     this.required = false,
//     this.errorText = 'Please select one or more options',
//     this.textField,
//     this.valueField,
//     this.change,
//     this.open,
//     this.close,
//     this.okButtonLabel = 'OK',
//     this.cancelButtonLabel = 'CANCEL',
//     this.fillColor,
//     this.border,
//     this.trailing,
//     this.chipLabelStyle,
//     this.isEnabled = true,
//     this.chipBackGroundColor,
//     this.dialogTextStyle = TextStyles.font13,
//     this.dialogShapeBorder = const RoundedRectangleBorder(
//       borderRadius: BorderRadius.all(Radius.circular(0.0)),
//     ),
//     this.checkBoxActiveColor,
//     this.checkBoxCheckColor, 
//     this.keyboardType, 
//     this.allowAdd, 
//     this.items,
//     this.hint
//   }) 
//   : super(builder: (FormFieldState<dynamic> state) {
//       Widget buildItem(UserListItem value) {
//         Widget baseWidget = Chip(
//           labelStyle: chipLabelStyle,
//           backgroundColor: chipBackGroundColor,
//           label: Text(
//             value.toString(),
//             overflow: TextOverflow.ellipsis,
//           ),
//         );

//         return isEnabled 
//           ? baseWidget 
//           : GestureDetector(
//               onTap: () => ScaffoldMessenger.of(state.context)
//                 ..hideCurrentSnackBar()
//                 ..showSnackBar(SnackBar(content: Text(value.toString()))),
//               child: baseWidget
//           );
//       }

//       return InkWell(
//         onTap: !isEnabled ? null :() async {

//           final selectedItems = 
//             ((state.value ?? List<UserListItem>.empty()) as List<UserListItem>)
//               .map((e) => ItemsListDialogItem(
//                 UserListItem(e.getValue()), e.toString()
//               ))
//             .toList();

//           final predefinedItems = (allowAdd ?? true)
//             ? List<ItemsListDialogItem<UserListItem>>.empty()
//             : (items ?? List<UserShallow>.empty())
//                 .map((e) => ItemsListDialogItem(
//                   UserListItem(e), e.name ?? e.email
//                 ))
//                 .toList();

//           List<UserShallow>? selectedValues = 
//             await showDialog<List<UserShallow>?>(
//               context: state.context,
//               builder: (context) => ItemsListDialog(
//                 title: title,
//                 okButtonLabel: okButtonLabel,
//                 cancelButtonLabel: cancelButtonLabel,
//                 selectedItems: selectedItems,
//                 additionals: const [],
//                 labelStyle: dialogTextStyle,
//                 dialogShapeBorder: dialogShapeBorder,
//                 checkBoxActiveColor: checkBoxActiveColor,
//                 checkBoxCheckColor: checkBoxCheckColor,
//                 keyboardType: TextInputType.emailAddress,
//                 validator: (val) => 
//                   (val?.isNotEmpty ?? false) && isEmptyOrValidEmail(val) 
//                     ? null 
//                     : "",
//                 allowAdd: allowAdd ?? true, 
//                 predefinedItems: predefinedItems,
//                 hint: hint,
//               )
//             );

//           if (selectedValues != null) {
//             state.didChange(selectedValues.map((e) => UserListItem(e)).toList());
//             state.save();
//           }
//         },
//         child: InputDecorator(
//           decoration: InputDecoration(
//             filled: true,
//             errorText: state.hasError ? state.errorText : null,
//             errorMaxLines: 4,
//             fillColor: fillColor ?? Theme.of(state.context).canvasColor,
//             border: border ?? const UnderlineInputBorder(),
//           ),
//           isEmpty: state.value == null || state.value == '',
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     required
//                       ? const Padding(
//                           padding: EdgeInsets.only(top: 5, right: 5),
//                           child: const Text(
//                             ' *',
//                             style: TextStyles.multiselectRequiredIndicator
//                           ),
//                         )
//                       : Container(),
//                   ],
//                 ),
//               ),
//               state.value != null && 
//               (state.value as List).where((x) => x != null).isNotEmpty 
//                 ? Wrap(
//                     spacing: 8.0,
//                     runSpacing: 0.0,
//                     children: (state.value as List<UserListItem>).map(buildItem).toList(),
//                   )
//                 : isEnabled 
//                   ? Container(
//                       padding: const EdgeInsets.only(top: 4), 
//                       child: hintWidget
//                     ) 
//                   : const SizedBox()
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }

// class ItemsListDialogItem<V> {
//   const ItemsListDialogItem(this.value, this.label);

//   final V value;
//   final String? label;
// }

// class ItemsListDialog extends StatefulWidget {
//   final List<ItemsListDialogItem<UserListItem>>? selectedItems;
//   final List<ItemsListDialogItem<UserListItem>> predefinedItems;
//   final List<ItemsListDialogItem> additionals;
//   final Widget? title;
//   final String? okButtonLabel;
//   final String? cancelButtonLabel;
//   final TextStyle labelStyle;
//   final ShapeBorder? dialogShapeBorder;
//   final Color? checkBoxCheckColor;
//   final Color? checkBoxActiveColor;
//   final TextInputType? keyboardType;
//   final bool allowAdd;
//   final String? hint;
//   final String? Function(String?)? validator;

//   const ItemsListDialog({
//     super.key,
//     this.keyboardType,
//     this.additionals = const [],
//     this.selectedItems,
//     this.title,
//     this.okButtonLabel,
//     this.cancelButtonLabel,
//     this.labelStyle = TextStyles.noStyle,
//     this.dialogShapeBorder,
//     this.checkBoxActiveColor,
//     this.checkBoxCheckColor,
//     this.hint, 
//     this.validator,
//     required this.allowAdd, 
//     required this.predefinedItems
//   });

//   @override
//   ItemsListDialogState createState() => ItemsListDialogState();
// }

// class ItemsListDialogState extends State<ItemsListDialog> {
//   late List<UserShallow> _selectedValues;
//   late List<String> _additionals;
//   late TextEditingController _controller;
  
//   final FocusNode _focus = FocusNode();
//   GlobalKey textFieldKey = GlobalKey<State<TextFormField>>();

//   bool isAdding = false;

//   @override
//   void initState() {
//     super.initState();
//     _selectedValues = widget.selectedItems?.map((e) => e.value.item).toList() ?? [];
//     _additionals = List.from(widget.additionals);
//     _controller = TextEditingController();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _controller.dispose();
//   }

//   void _onItemCheckedChange(UserShallow itemValue, bool? checked) {
//     setState(() {
//       if (checked!) {
//         _selectedValues.add(itemValue);
//       } else {
//         _selectedValues.remove(itemValue);
//       }
//     });
//   }

//   void _onAdditionalCheckedChange(String text, bool? checked) {
//     setState(() {
//       if (checked!) {
//         _additionals.add(text);
//       } else {
//         _additionals.remove(text);
//       }
//     });
//   }

//   void _onCancelTap() {
//     Navigator.pop(context, null);
//   }

//   void _onSubmitTap() {
//     Navigator.pop(
//       context, 
//       _selectedValues..addAll(_additionals.map((a) => UserShallow(email: a)))
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: widget.title,
//       shape: widget.dialogShapeBorder,
//       contentPadding: const EdgeInsets.only(top: 12.0),
//       content: SingleChildScrollView(
//         child: Column(children: [
//           ListTileTheme(
//             contentPadding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
//             minVerticalPadding: 0,
//             child: ListBody(
//               children: widget.allowAdd 
//               ? [
//                   ...widget.selectedItems!.map(_buildItem).toList(), 
//                   ..._additionals.map(_buildAdditional).toList()
//                 ] 
//               : [ ...widget.predefinedItems.map(_buildItem).toList()]
//             ),
//           ),          
//           // text field
//           Visibility(
//             visible: widget.allowAdd && isAdding, 
//             child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0), 
//               child: Row(children: [
//                 Expanded(child: 
//                   TextFormField(
//                     key: textFieldKey,
//                     validator: widget.validator,
//                     autovalidateMode: AutovalidateMode.onUserInteraction,
//                     focusNode: _focus, 
//                     controller: _controller, 
//                     keyboardType: widget.keyboardType,
//                     decoration: InputDecoration(
//                       hintText: widget.hint, 
//                       errorStyle: TextStyles.hideError
//                     ),
//                   )
//                 ), 
//                 IconButton(
//                   onPressed: _additionalApprovePressed, 
//                   icon: const Icon(Icons.save)
//                 )
//               ])
//             )
//           ),
//           Visibility(visible: widget.allowAdd && !isAdding, child: IconButton(onPressed: _addAdditionalPressed, icon: const Icon(Icons.add, color: Colors.black)))
//         ]),
//       ),
//       actions: <Widget>[
//         TextButton(
//           onPressed: _onCancelTap,
//           child: Text(widget.cancelButtonLabel!),
//         ),
//         TextButton(
//           onPressed: _onSubmitTap,
//           child: Text(widget.okButtonLabel!),
//         )
//       ],
//     );
//   }

//   Widget _buildItem(ItemsListDialogItem<UserListItem> item) {
//     final checked = _selectedValues.contains(item.value.item);
//     return SizedBox(
//       height: 40,
//       child: CheckboxListTile(
//         value: checked,
//         checkColor: widget.checkBoxCheckColor,
//         activeColor: widget.checkBoxActiveColor,
//         title: Text(item.label!, style: widget.labelStyle),
//         controlAffinity: ListTileControlAffinity.leading,
//         onChanged: (checked) => _onItemCheckedChange(item.value.item, checked),
//       )
//     );
//   }

//   Widget _buildAdditional(String text) {
//     final checked = _additionals.contains(text);
//     return CheckboxListTile(
//       value: checked,
//       checkColor: widget.checkBoxCheckColor,
//       activeColor: widget.checkBoxActiveColor,
//       title: Text(text, style: widget.labelStyle),
//       controlAffinity: ListTileControlAffinity.leading,
//       onChanged: (checked) => _onAdditionalCheckedChange(text, checked),
//     );
//   }

//   void _additionalApprovePressed() {
//     if (widget.validator == null || widget.validator!(_controller.text) == null) {
//       setState(() {
//         if (_additionals.contains(_controller.text) || 
//             _selectedValues.any((e) => e.email == _controller.text)
//         ) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(S.current.userAlreadyDefinedMessage)) // TODO: get from outside
//           );
//         } else {
//           _additionals.add(_controller.text);
//           _controller.clear();
//           isAdding = false;
//         }
//       });
//     }
//   }

//   void _addAdditionalPressed() {
//     setState(() {
//       isAdding = true;
//       _focus.requestFocus();
//     });
//   }
// }

// abstract class ItemsListValue {
//   @override
//   String toString();
//   dynamic getValue();
//   ItemsListValue.create();
//   ItemsListValue();
// }

// class UserListItem extends ItemsListValue {
//   final UserShallow item;
//   final String? name;
//   final String? id;

//   UserListItem(this.item) : name = item.name, id = item.id;
//   UserListItem.create(this.name) : id = null, item = UserShallow(email: name);
  
//   @override
//   String toString() => name ?? item.email ?? "";
  
//   @override
//   getValue() => item;
// }