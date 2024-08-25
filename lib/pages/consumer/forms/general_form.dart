import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:core_dashboard/controllers/config.dart';
import 'dart:convert' show base64Decode, base64Encode;
import 'package:flutter/foundation.dart' show kIsWeb;

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
  final TextEditingController homePageController = TextEditingController();

  String? _logoBase64;
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
      homePageController.text = data.data.homePage;
    });

  }

  Future<void> _pickImage(bool isLogo) async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      if (kIsWeb) {
        // Web-specific logic
        final bytes = result.files.single.bytes;
        if (bytes != null) {
          setState(() {
            _handleFieldChange(_logoBase64!);
            _logoBase64 = base64Encode(bytes);
            
          });
          
        }
      } else {
        // Mobile and desktop logic
        final file = File(result.files.single.path!);
        final bytes = await file.readAsBytes();
        setState(() {
          _handleFieldChange(_logoBase64!);
          _logoBase64 = base64Encode(bytes);
        });
        
      }
      
    }
  }

  Future<void> _updateGeneralData() async {
    final result = await configController.upadateGeneralData({
      'app_name': appNameController.text,
      'description': descriptionController.text,
      'nif_name': nifNameController.text,
      'logo': _logoBase64 ?? '', // Sending Base64 string
      'version': versionController.text,
      'homePage': homePageController.text
    });

    if (result){
      Get.snackbar("Sucesso", "Configurações Atualizadas", backgroundColor: Colors.green);
    }else{
      Get.snackbar("Error", "Erro ao atualizar configurações", backgroundColor: Colors.red);
    }
  }

  void _handleFieldChange(String value) {
    setState(() {
      _isFormModified = true;
      widget.onFieldChanged();
    });
  }

  @override
  Widget build(BuildContext context) {
    _logoBase64 = configController.appData.value!.data.logo;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => _pickImage(true),
              child: Column(
                children: [
                  const Text('Logo'),
                  _logoBase64 != null
                      ? Container(
                        padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(12)),
                            border: Border.all(color: Colors.black)
                          ),
                          child: Image.memory(base64Decode(_logoBase64!), height: 130, width: 130,))
                      : const Text('No logo selected'),
                  
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: appNameController,
              onChanged: _handleFieldChange,
              decoration: const InputDecoration(labelText: 'App Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descriptionController,
              onChanged: _handleFieldChange,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: nifNameController,
              onChanged: _handleFieldChange,
              decoration: const InputDecoration(labelText: 'NIF Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: versionController,
              onChanged: _handleFieldChange,
              decoration: const InputDecoration(labelText: 'Version'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: homePageController,
              onChanged: _handleFieldChange,
              decoration: const InputDecoration(labelText: 'Home Page'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed:_isFormModified ? () async => await _updateGeneralData() : null,
              child: const Text('Atualizar'),
            ),
          ],
        ),
      ),
    );
  }
}
