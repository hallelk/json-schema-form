// import 'package:core/core.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:qtree/generated/l10n.dart';
// import 'package:qtree/ui/common/form/common_images_form_field.dart';
// import 'package:qtree/ui/common/utils.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:qtree/ui/styles/colors.dart';
// // import 'package:qtree/utils/isolates.dart';

// // TODO : rebuilds on every form click 
// class TreeImagesFormField extends FormField<List<TreeImage>> {
//   final bool isEnabled;
//   final int maxAllowed;
//   final IconData? icon;
//   final PickerMode? mode;

//   TreeImagesFormField({
//     super.key, 
//     super.onSaved,
//     required super.validator,
//     required this.maxAllowed, 
//     this.isEnabled = true,
//     List<TreeImage>? value,
//     this.icon,
//     this.mode = PickerMode.camera,
//   }) : super(
//         autovalidateMode: AutovalidateMode.disabled,
//         initialValue: List<TreeImage>.from(value ?? [], growable: true),
//         builder: (FormFieldState<List<TreeImage>?> state) {
//           return _ActualField(
//             key: key,
//             enabled: isEnabled, 
//             onChanged: (v) => state.didChange(v), 
//             initialValue: List<TreeImage>.from(value ?? [], growable: true), 
//             maxAllowed: maxAllowed, 
//             icon: icon,
//             mode: mode);
//         }
//   );
// }

// class _ActualField extends StatefulWidget {
//   final List<TreeImage>? initialValue;
//   final bool enabled;
//   final Function onChanged;
//   final int maxAllowed;
//   final IconData? icon;
//   final PickerMode? mode;

//   const _ActualField({super.key, this.initialValue, required this.enabled, required this.onChanged, this.mode, required this.maxAllowed, this.icon});

//   @override
//   _ActualFieldState createState() => _ActualFieldState();
// }

// class _ActualFieldState extends State<_ActualField> {
  
//   late ImagePicker _picker;
//   final maxResolution = 1000000.0;
//   bool isChooseMethod = false;
//   late List<TreeImage> value;

//   @override 
//   void initState() {
//     super.initState();
//     value = widget.initialValue ?? List<TreeImage>.empty(growable: true);
//   }
          
//   void _doDeletePicture(TreeImage img) async {
//     bool? isSure = await Utils.getAreYouSureAlert(context);

//     if (isSure ?? false) {
//       widget.onChanged(value..remove(img));
//     }
//   }

//   void handleAddingImage(ImageSource source) async {
//     if (value.length == widget.maxAllowed) { 
//       await Utils.getMessageAlert(context, S.of(context).message_cannot_add_more_images);
//       return null;
//     } else {
//       SystemChrome.setPreferredOrientations([
//         DeviceOrientation.portraitUp,
//         DeviceOrientation.landscapeLeft,
//         DeviceOrientation.landscapeRight,
//       ]);

//       XFile? pic = await _picker.pickImage(source: source, imageQuality: 80, maxHeight: 1000, maxWidth: 1000);

//       SystemChrome.setPreferredOrientations([
//         DeviceOrientation.portraitUp,
//       ]);

//       if (pic != null) {
//         widget.onChanged(value..add(TreeImage.empty().copyWith(imagePath: pic.path)));
//         // String? base64pic = await IsolatesUtility.runAsync<String, String? Function(XFile, double)>(reencodeAsBase64, [pic, maxResolution]);
        
//         // if (mounted) {
//         //   widget.onChanged(value..removeLast());
        
//         //   if (base64pic != null) {
//         //     widget.onChanged(
//         //       value..add(TreeImage(imagePath: base64pic))
//         //     );
//         //   }
//         // }
//       }
//     }
//   }

//   void handleAddPictureClicked({isLongPress = false}) async {
//     if (widget.mode == null || isLongPress) {
//       setState(() => isChooseMethod = true);
//     } else if (widget.mode == PickerMode.camera) {
//       handleAddingImage(ImageSource.camera);
//     } else if (widget.mode == PickerMode.gallery) {
//       handleAddingImage(ImageSource.gallery);
//     }
//   }

//   List<Widget> getChooseMethodContent() {
//     return [
//       InkWell(
//         onTap: () => setState(() => isChooseMethod = false),
//         child: Center(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               InkWell(
//                 onTap: () {
//                   handleAddingImage(ImageSource.gallery);
//                   setState(() => isChooseMethod = false);
//                 },
//                 child: const SizedBox(
//                   height:80, 
//                   child: Icon(Icons.image, color: QColors.main_green_1, size: 80))
//               ),
//               InkWell(
//                 onTap: () {
//                   handleAddingImage(ImageSource.camera);
//                   setState(() => isChooseMethod = false);
//                 },
//                 child: const SizedBox(
//                   height:80, 
//                   child: Icon(Icons.photo_camera_rounded, color: QColors.main_green_1, size: 80)
//                 )
//               )
//             ]
//           )
//         )
//       )
//     ];
//   }

//   List<Widget> getValueContent() {
//     final list = value.reversed.toList();

//     return [Container(      
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
//       child: Stack(children: [
//         CarouselSlider(
//           options: CarouselOptions(
//             enableInfiniteScroll: false, 
//           ),
//           items: list.map((img) => CarouselImage(
//             imageLocation: img.imagePath ?? '', 
//             isEnabled: widget.enabled, 
//             onDeleteCallback: () => _doDeletePicture(img)
//           )).toList(), 
//         ),
//         widget.enabled && list.length < widget.maxAllowed  // Take Picture
//           ? PositionedDirectional(
//               bottom: 4,
//               start: 8,
//               end: 8,
//               child: InkWell(
//                 onLongPress: () => handleAddPictureClicked(isLongPress: true),
//                 onTap: handleAddPictureClicked,
//                 child: const Icon(Icons.add_photo_alternate, color:QColors.main_green_1))
//             )
//           : Container(),
//         ]
//       )
//     )];
//   }

  
// List<Widget> getEmptyContent() =>
//     [
//       Container(
//         decoration: const BoxDecoration(
//           color: QColors.imagesBackground,
//           borderRadius: BorderRadius.all(Radius.circular(10))
//         ),
//         child: Center(
//           child: FaIcon(
//             widget.icon ?? FontAwesomeIcons.image, 
//             color: QColors.imagesEmpty, 
//             size: 100
//           )
//         ),
//       ),
//       widget.enabled && widget.maxAllowed > value.length
//         ? PositionedDirectional(
//             bottom: 16,
//             start: 16,
//             child: InkWell(
//               onLongPress: () => handleAddPictureClicked(isLongPress: true),
//               onTap: handleAddPictureClicked,
//               child: const Icon(
//                 Icons.add_photo_alternate, 
//                 color:QColors.main_green_1
//               )
//             )
//           )
//         : Container()
//     ];

//   @override
//   Widget build(BuildContext context) {
//     if (widget.enabled) {
//       _picker = ImagePicker();
//     }

//     return Container(
//       height: 200,
//       decoration: const BoxDecoration(
//         borderRadius: BorderRadius.all(Radius.circular(10)),
//         color: QColors.imagesBackground,
//       ),
//       child: Stack(children: 
//         isChooseMethod 
//           ? getChooseMethodContent()
//           : (value.isEmpty
//               ? getEmptyContent()
//               : getValueContent())
//       )
//     );
//   }
// }