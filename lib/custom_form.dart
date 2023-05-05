import 'package:dart_mongo_lite/dart_mongo_lite.dart';
import 'package:flutter/material.dart';
import 'package:json_schema_form/form/form_item.dart';

class CustomForm extends StatefulWidget {
  const CustomForm({super.key});

  @override
  CustomFormState createState() => CustomFormState();
}

class CustomFormState extends State<CustomForm> {
  final _formKey = GlobalKey<FormState>();

  String surveyName = '';
  List<dynamic> template = [];
  List<Widget> formItems = [];
  dynamic item = {};

  @override
  Widget build(BuildContext context) {
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropDownFormItem(
          items: getSurveyItems(), 
          onChanged: (x) { 
            print(x);
            setState(() { 
              template = getSurveyTemplate(x); 
              surveyName = x;
              formItems = generateFields(template);
            }); 
          },
          title: 'survey', 
          fieldName: 'survey', 
          mode: 'FormMode.insert', 
          onSavedCallback: () => null
        ),
        Center(child: Container(height: 1, width: 200, color: Colors.black,)),
        Form(
          key: _formKey,
          child: Column(children: [
            ...formItems,
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
                    _formKey.currentState!.save();
                    saveForm(surveyName, item);  
                  } catch (e) {
                    print(e);
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
          ]),
        ),
      ]
    );
  }

  void saveForm(surveyName, item) {
    print('saveForm:');
    print(item);
    Database db = Database('resources/db');
    var data = db['data'];

    data.insert({"survey": surveyName, ...item});
  }

  List<SurveyItem> getSurveyItems() {
    Database db = Database('resources/db');
    var surveys = db['surveys'];
    
    return surveys.find().map(SurveyItem.new).toList();
  }

  List<dynamic> getSurveyTemplate(surveyName) {
    Database db = Database('resources/db');
    var surveys = db['surveys'];
    var templates = db['templates'];

    String templateName = surveys.findOne(filter: {'name': surveyName})!['template'];
    List<dynamic> template = templates.findOne(filter: {'name': templateName})!['fields'];
    
    return template;
  }

  List<Widget> generateFields(List schema) {
    print('generateFields:');
    print(schema);
    var a=  schema.map((e) { print(111); print(e); return generateField(e); }).toList();
    print(a);
    return a;
  }

  Widget generateField(e) {
    print("generateField:");
    switch (e["type"]) {
      case "text":
        Widget w = TextFormItem(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          }, 
          fieldName: e['name'], 
          mode: 'FormMode.update', 
          onSavedCallback: (n, v) { print('saved: ${n} : ${v}'); setState(() { item['${n}'] = v; }); }, 
          title: e['name'],
          subtitle: e['subtitle'],
          isMultiline: e['multiline'] ?? false,
          isPassword: e['password'] ?? false,
          maxLength: e['maxLength'],
        );
        print(222);
        return w; 
      case "phone": return TextFormItem.phone(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          }, 
          fieldName: e['id'], 
          mode: 'FormMode.update', 
          onSavedCallback: (v) => setState(() { item[e['name']] = v; }), 
          title: e['title'],
          subtitle: e['subtitle']
        );    
      
      default: return Container(); 
    }
  }
}

class SurveyItem extends DropDownValue {
  final String name;
  final String? value;

  SurveyItem(Map survey) : name = survey['name'] ?? "", value = survey['name'];
  SurveyItem.empty() : name = "", value = null;
  static SurveyItem? from(Map? t) => t != null ? SurveyItem(t) : null; 
  
  @override
  String toString() => name ;
  
  @override
  getValue() => value;
}