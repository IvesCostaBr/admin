import 'package:core_dashboard/pages/consumer/forms/general_form.dart';
import 'package:core_dashboard/pages/consumer/forms/theme_form.dart';
import 'package:core_dashboard/shared/widgets/container.dart';
import 'package:flutter/material.dart';

class ConsumerGeneralConfigPage extends StatefulWidget {
  @override
  _ConsumerGeneralConfigPageState createState() => _ConsumerGeneralConfigPageState();
}

class _ConsumerGeneralConfigPageState extends State<ConsumerGeneralConfigPage> {
  String selectedForm = 'General';
  bool isFormChanged = false;

  void _onFieldChanged() {
    setState(() {
      isFormChanged = true;
    });
  }

  void _saveChanges() {
    if (selectedForm == 'General') {
      // Save General Config changes
    } else {
      // Save Theme Config changes
    }

    setState(() {
      isFormChanged = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GenericContainer(
      text: "Configurações Aplicativo",
      content: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<String>(
                  value: selectedForm,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedForm = newValue!;
                    });
                  },
                  items: <String>['General', 'Theme']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              selectedForm == 'General' ? GeneralConfigForm(onFieldChanged: _onFieldChanged) : ThemeConfigForm(onFieldChanged: _onFieldChanged),
            ],
          ),
      ),
    );
  }
}
