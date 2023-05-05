// import 'package:flutter/material.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:qtree/generated/l10n.dart';
// import 'package:qtree/ui/components/map_slim.dart';

// class MapPolygonField extends FormField<List<LatLng>> {
//   final Function change;
//   final bool isEnabled;
//   final Function address;

//   MapPolygonField({
//     super.key,
//     required this.change,
//     this.isEnabled = true,
//     required this.address,
//     super.onSaved,
//     super.initialValue
//   }) 
//   : super(
//       builder: (FormFieldState<dynamic> state) {
//         GlobalKey<MapComponentSlimState> mapComponentSlimStateKey = GlobalKey<MapComponentSlimState>();
//         List<Widget> children = [];

//         if (initialValue?.isNotEmpty ?? false) {
//           children.add(const Icon(Icons.done));
//         }

//         if (address() != "") {
//           children.add(
//             TextButton(
//               child: const Icon(Icons.edit), 
//               onPressed: () async {
//                 showDialog(
//                   context: state.context, 
//                   builder: (context) => 
//                     AlertDialog(
//                       contentPadding: EdgeInsets.zero,
//                       content: SizedBox(
//                         height: 400, 
//                         width: 400, 
//                         child: MapComponentSlim(
//                           key: mapComponentSlimStateKey, 
//                           address: address(), 
//                           polygon: state.value
//                         )
//                       ),
//                       actionsAlignment: MainAxisAlignment.spaceEvenly,
                      
//                       actions: [
//                         TextButton(
//                           child: Text(S.current.commonSave), 
//                           onPressed: () {
//                             state.didChange(mapComponentSlimStateKey.currentState?.polygon);
//                             Navigator.pop(context, true);
//                           }
//                         ),
//                         TextButton(
//                           child: Text(S.current.commonCancel), 
//                           onPressed: () {
//                             Navigator.pop(context, false);
//                           }
//                         ),
//                       ],
//                     )
//                 ).then((value) {
//                   change(state.value);
//                 });
//               }
//             )
//           );
//         } else {
//           children.add(Text(S.of(state.context).surveyAddressValidator));
//         }

//         return ActualField(w: Row(children: children));
//       }
//     );
// }

// class ActualField extends StatelessWidget {
//   final Widget w;

//   const ActualField({super.key, required this.w});

//   @override
//   Widget build(BuildContext context) {
//     return w;
//   }
// }