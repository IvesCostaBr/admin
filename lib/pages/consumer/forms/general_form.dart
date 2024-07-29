import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:core_dashboard/controllers/config.dart';

class GeneralConfigForm extends StatefulWidget {
  const GeneralConfigForm({Key? key, required this.onFieldChanged}) : super(key: key);

  final VoidCallback onFieldChanged;

  @override
  _GeneralConfigFormState createState() => _GeneralConfigFormState();
}

class _GeneralConfigFormState extends State<GeneralConfigForm> {
  final ConfigController configController = Get.find<ConfigController>();
  final TextEditingController appNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController nifNameController = TextEditingController();
  final TextEditingController versionController = TextEditingController();

  File? _logo;
  bool _isFormModified = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = configController.appData.value;
    setState(() {
      appNameController.text = data!.data.appName;
      descriptionController.text = data.data.description;
      nifNameController.text = data.data.nifName;
      versionController.text = data.data.version;
    });
  }

  Future<void> _pickImage(bool isLogo) async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      setState(() {
        _logo = File(result.files.single.path!);
        widget.onFieldChanged();
      });
    }
  }

  void _updateGeneralData() {
    configController.upadateGeneralData({
      'app_name': appNameController.text,
      'description': descriptionController.text,
      'nif_name': nifNameController.text,
      // 'logo': _logo, // Consider commenting or removing this line if it's causing issues
      'version': versionController.text,
    });
  }

  void _handleFieldChange(String value) {
    setState(() {
      _isFormModified = true;
      widget.onFieldChanged();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: appNameController,
              onChanged: _handleFieldChange,
              decoration: const InputDecoration(labelText: 'App Name'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descriptionController,
              onChanged: _handleFieldChange,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: nifNameController,
              onChanged: _handleFieldChange,
              decoration: const InputDecoration(labelText: 'NIF Name'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: versionController,
              onChanged: _handleFieldChange,
              decoration: const InputDecoration(labelText: 'Version'),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Text('Logo'),
                      _logo != null
                          ? Image.file(_logo!, height: 100)
                          : const Text('No logo selected'),
                      ElevatedButton(
                        onPressed: () => _pickImage(true),
                        child: const Text('Upload Logo'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _isFormModified ? _updateGeneralData : null,
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
