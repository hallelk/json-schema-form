import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_schema_form/data_viewer.dart';
import 'package:json_schema_form/survey_definition_form.dart';
import 'package:json_schema_form/template_definition_form.dart';

import 'custom_form.dart';

late List a;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  a = await json.decode(await rootBundle.loadString('assets/form-schema.json'));
  
  runApp(const MyApp());
} 

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Dynamic Form Demo';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: DefaultTabController(
          length: 4,
          child: Scaffold(
            appBar: AppBar(
              bottom: const TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.settings), text: "Template Builder",),
                  Tab(icon: Icon(Icons.settings), text: "Survey creation",),
                  Tab(icon: Icon(Icons.car_crash), text: "Data Collection"),
                  Tab(icon: Icon(Icons.data_array), text: "report"),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                TemplateDefinitionForm(a),
                const SurveyDefinitionForm(),
                const CustomForm(),
                DataViewer(a),
              ],
            ),
          ),
      ),
      ),
    );
  }
}