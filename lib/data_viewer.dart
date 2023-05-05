import 'dart:ui';

import 'package:dart_mongo_lite/dart_mongo_lite.dart';
import 'package:flutter/material.dart';
import 'package:json_schema_form/form/form_item.dart';

class DataViewer extends StatefulWidget {
  final List schema;
  const DataViewer(this.schema, {super.key});

  @override
  DataViewerState createState() => DataViewerState();
}

class DataViewerState extends State<DataViewer> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    Database db = Database('resources/db');
    List surveys = db['surveys'].find();

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: 
          surveys.map(
            (survey) => Column(
              mainAxisAlignment: MainAxisAlignment.start, 
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text(survey['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20))]),
                ...db['data'].find(filter: {"survey": survey['name']}).toList().map((e) => 
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 50), 
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center, 
                      children: [
                        Text(e.toString())
                      ]
                    )
                  )).toList()
              ]
            )
          ).toList()
    );
  }

  List<Widget> generateFields(List schema) {
    return schema.map(generateField).toList();
  }

  Widget generateField(e) {
    switch (e["type"]) {
      case "text":
        // TODO : add required
        return TextFormItem(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          }, 
          fieldName: e['id'], 
          mode: 'FormMode.update', 
          onSavedCallback: (a) => null, 
          title: e['title'],
          subtitle: e['subtitle'],
          isMultiline: e['multiline'] ?? false,
          isPassword: e['password'] ?? false,
          maxLength: e['maxLength'],
        );    
      case "phone": return TextFormItem.phone(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          }, 
          fieldName: e['id'], 
          mode: 'FormMode.update', 
          onSavedCallback: (a) => null, 
          title: e['title'],
          subtitle: e['subtitle']
        );    
      
      default: return Container(); 
    }
  }
}