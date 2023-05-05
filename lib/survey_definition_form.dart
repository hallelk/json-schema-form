import 'package:dart_mongo_lite/dart_mongo_lite.dart';
import 'package:flutter/material.dart';
import 'package:json_schema_form/form/form_item.dart';

class SurveyDefinitionForm extends StatefulWidget {
  const SurveyDefinitionForm({super.key});

  @override
  SurveyDefinitionFormState createState() => SurveyDefinitionFormState();
}

class SurveyDefinitionFormState extends State<SurveyDefinitionForm> {
  final _formKey = GlobalKey<FormState>();

  String templateName = "";
  String surveyName = "";

  @override
  Widget build(BuildContext context) {
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
            title: "survey name", 
            fieldName: 'surveyName', 
            mode: 'FormMode.insert', 
            onSavedCallback: (a) => {print ("saves")},
            onChangedCallback: (v) => setState(() { print ("change"); surveyName = v;}),
            isMultiline: false,
          ),
          DropDownFormItem(
            items: getTemplateItems(), 
            onChanged: (x) { print(x); setState(() => templateName = x); },
            title: 'template', 
            fieldName: 'template', 
            mode: 'FormMode.insert', 
            onSavedCallback: (a) => {print ("saves")}
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
                    saveSurvey(surveyName, templateName);  
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

  List<TemplateItem> getTemplateItems() {
    Database db = Database('resources/db');
    var templates = db['templates'];

    return templates.find().map((t) => TemplateItem(t)).toList();
  }

  void saveSurvey(surveysName, templateName) {
    Database db = Database('resources/db');
    var surveys = db['surveys'];
    var t = surveys.findOne(filter : {"name" : surveysName});

    if (t != null) {
      throw "already exists";
    }

    surveys.insert({
      "name": surveyName,
      "template": templateName
    });
  }
}

class TemplateItem extends DropDownValue {
  final String name;
  final String? value;

  TemplateItem(Map template) : name = template['name'] ?? "", value = template['name'];
  TemplateItem.empty() : name = "", value = null;
  static TemplateItem? from(Map? t) => t != null ? TemplateItem(t) : null; 
  
  @override
  String toString() => name ;
  
  @override
  getValue() => value;
}