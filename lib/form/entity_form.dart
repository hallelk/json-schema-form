/*
import 'package:flutter/material.dart';
import 'package:qtree/ui/styles/colors.dart';

abstract class EntityForm extends StatefulWidget {
  final FormMode? mode;
  
  const EntityForm({super.key, this.mode});
}

abstract class EntityFormState<T extends EntityForm> extends State<T> {

  void scrollToSelectedContent(GlobalKey widgetKey) {
    final keyContext = widgetKey.currentContext;
    
    if (keyContext != null) {
      Future.delayed(const Duration(milliseconds: 250)).then((value) {
        Scrollable.ensureVisible(
          keyContext,
          duration: Duration(milliseconds: keyContext.size!.height.toInt() * 2));
      });
    }
  }

  Widget buildForm(
    GlobalKey<FormState> formKey, 
    BuildContext context, 
    List<Widget> items, 
    Widget readButtons, 
    Widget imagesField, 
    void Function()? savePressed, 
    void Function()? cancelPressed
  ) {
    double height = MediaQuery.of(context).size.height;
    const buttonsHeight = 60;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: height - buttonsHeight),
        child: Scaffold(
          floatingActionButton: Visibility(
            visible: widget.mode != FormMode.read, 
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  backgroundColor: QColors.main_green_1, 
                  onPressed: savePressed, 
                  child: const Icon(Icons.save)
                ),
                FloatingActionButton(
                  backgroundColor: Colors.red, 
                  onPressed: cancelPressed, 
                  child: const Icon(Icons.cancel_rounded)
                ),
              ]
            )
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          body: SizedBox(
            height: height - buttonsHeight - 80, 
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical, 
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8), 
                child: Column(children: [
                  Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        imagesField,
                        widget.mode == FormMode.read 
                          ? readButtons 
                          : const SizedBox(),
                        ...items
                      ]
                    ),
                  ), 
                ])
              )
            )
          )
        )
      )
    );
  }
}

enum FormMode {
  read, insert, update
}

*/