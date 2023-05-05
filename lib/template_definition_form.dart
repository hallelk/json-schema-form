import 'package:dart_mongo_lite/dart_mongo_lite.dart';
import 'package:flutter/material.dart';
import 'package:json_schema_form/form/form_item.dart';
import 'package:json_schema_form/new_field_dialog.dart';

class TemplateDefinitionForm extends StatefulWidget {
  final List schema;
  const TemplateDefinitionForm(this.schema, {super.key});

  @override
  TemplateDefinitionFormState createState() => TemplateDefinitionFormState();
}

class TemplateDefinitionFormState extends State<TemplateDefinitionForm> {
  final _formKey = GlobalKey<FormState>();

  List fields = [];
  String templateName = "";

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormItem(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            }, 
            title: "template name", 
            fieldName: 'templateName', 
            mode: 'FormMode.insert', 
            onSavedCallback: (a) => {print ("saves")},
            onChangedCallback: (v) => setState(() { print ("change"); templateName = v;}),
            isMultiline: false,
          ),
          ListView(
            shrinkWrap: true,
            children: fields.map(generateFieldCard).toList(),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () { 
                showDialog(
                  context: context, 
                  builder: (context) => 
                    const NewFieldDialog("")).then((value) => setState(() { fields.add({ "name": value, "type": "text"}); } )); 
              }, 
              child: const Icon(Icons.add),
            )
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );
                  
                  try {
                    saveTemplate(templateName, fields);  
                  } catch (e) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                  
                }
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }

  Widget generateFieldCard(e) {
    return Center(
      child: Container(width: 200, height: 50, 
        child: Card(
          child: Row(children: [ Icon(Icons.abc), Text(e["name"])]))));
  }

  void saveTemplate(templateName, fields) {
    Database db = Database('resources/db');
    var templates = db['templates'];
    var t = templates.findOne(filter : {"name" : templateName});

    if (t != null) {
      throw "already exists";
    }

    templates.insert({
      "name": templateName,
      "fields": fields
    });
  }
}