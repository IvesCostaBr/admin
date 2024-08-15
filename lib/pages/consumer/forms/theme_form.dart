import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:core_dashboard/controllers/config.dart';
import 'package:core_dashboard/shared/widgets/input/color_picker.dart';

class ThemeConfigForm extends StatefulWidget {
  const ThemeConfigForm({Key? key, required this.onFieldChanged}) : super(key: key);

  final VoidCallback onFieldChanged;

  @override
  _ThemeConfigFormState createState() => _ThemeConfigFormState();
}

class _ThemeConfigFormState extends State<ThemeConfigForm> {
  final ConfigController configController = Get.find<ConfigController>();
  Color _primaryColor = Colors.blue;
  Color _primaryVariantColor = Colors.blueAccent;
  Color _secondaryColor = Colors.green;
  Color _secondaryVariantColor = Colors.greenAccent;
  Color _backgroundColor = Colors.white;
  Color _surfaceColor = Colors.white;
  Color _errorColor = Colors.red;
  Color _onPrimaryColor = Colors.white;
  Color _onSecondaryColor = Colors.black;
  Color _onBackgroundColor = Colors.black;
  Color _onSurfaceColor = Colors.black;
  Color _onErrorColor = Colors.white;
  String _fontFamily = 'Roboto';

  bool _isFormValid = true;

  final List<String> _fontFamilies = [
    'Roboto',
    'Arial',
    'Verdana',
    'Times New Roman',
    'Courier New',
    // Adicione outras fontes conforme necessário
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = configController.appData.value;
    setState(() {
      _primaryColor = data!.theme.colors['primary']!;
      _primaryVariantColor = data.theme.colors['primaryVariant']!;
      _secondaryColor = data.theme.colors['secondary']!;
      _secondaryVariantColor = data.theme.colors['secondaryVariant']!;
      _backgroundColor = data.theme.colors['background']!;
      _surfaceColor = data.theme.colors['surface']!;
      _errorColor = data.theme.colors['error']!;
      _onPrimaryColor = data.theme.colors['onPrimary']!;
      _onSecondaryColor = data.theme.colors['onSecondary']!;
      _onBackgroundColor = data.theme.colors['onBackground']!;
      _onSurfaceColor = data.theme.colors['onSurface']!;
      _onErrorColor = data.theme.colors['onError']!;
      _fontFamily = data.theme.fontFamily!;
    });
  }

  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0')}';
  }

  Color _hexToColor(String hex) {
    final hexColor = hex.replaceAll('#', '');
    return Color(int.parse(hexColor, radix: 16)).withOpacity(1.0);
  }

  bool _validateHexColor(String hex) {
    final hexColor = hex.replaceAll('#', '');
    if (hexColor.length != 6 && hexColor.length != 8) {
      return false;
    }
    final color = int.tryParse(hexColor, radix: 16);
    return color != null;
  }

  void _handleColorChange(Color color, Function(Color) onColorChanged) {
    setState(() {
      onColorChanged(color);
      widget.onFieldChanged();
      _isFormValid = true;
    });
  }

  void _handleColorInputChange(String hex, Function(Color) onColorChanged) {
    if (_validateHexColor(hex)) {
      setState(() {
        final color = _hexToColor(hex);
        onColorChanged(color);
        widget.onFieldChanged();
        _isFormValid = true;
      });
    } else {
      setState(() {
        _isFormValid = false;
      });
    }
  }

  void _handleFontFamilyChange(String? newValue) {
    if (newValue != null) {
      setState(() {
        _fontFamily = newValue;
        widget.onFieldChanged();
      });
    }
  }

  void _updateThemeData() async {
    if (!_isFormValid) return;

    await configController.upadateThemeData({
        'colors': {
          'primary': _primaryColor.value.toRadixString(16),
          'primaryVariant': _primaryVariantColor.value.toRadixString(16),
          'secondary': _secondaryColor.value.toRadixString(16),
          'secondaryVariant': _secondaryVariantColor.value.toRadixString(16),
          'background': _backgroundColor.value.toRadixString(16),
          'surface': _surfaceColor.value.toRadixString(16),
          'error': _errorColor.value.toRadixString(16),
          'onPrimary': _onPrimaryColor.value.toRadixString(16),
          'onSecondary': _onSecondaryColor.value.toRadixString(16),
          'onBackground': _onBackgroundColor.value.toRadixString(16),
          'onSurface': _onSurfaceColor.value.toRadixString(16),
          'onError': _onErrorColor.value.toRadixString(16),
        },
        'font_family': _fontFamily,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(width: 10),
        Column(
            children: [
              _buildColorRow('Primary Color', _primaryColor, (color) => _primaryColor = color, _handleColorInputChange),
              _buildColorRow('Primary Variant Color', _primaryVariantColor, (color) => _primaryVariantColor = color, _handleColorInputChange),
              _buildColorRow('Secondary Color', _secondaryColor, (color) => _secondaryColor = color, _handleColorInputChange),
              _buildColorRow('Secondary Variant Color', _secondaryVariantColor, (color) => _secondaryVariantColor = color, _handleColorInputChange),
              _buildColorRow('Background Color', _backgroundColor, (color) => _backgroundColor = color, _handleColorInputChange),
              _buildColorRow('Surface Color', _surfaceColor, (color) => _surfaceColor = color, _handleColorInputChange),
              _buildColorRow('Error Color', _errorColor, (color) => _errorColor = color, _handleColorInputChange),
              _buildColorRow('On Primary Color', _onPrimaryColor, (color) => _onPrimaryColor = color, _handleColorInputChange),
              _buildColorRow('On Secondary Color', _onSecondaryColor, (color) => _onSecondaryColor = color, _handleColorInputChange),
              _buildColorRow('On Background Color', _onBackgroundColor, (color) => _onBackgroundColor = color, _handleColorInputChange),
              _buildColorRow('On Surface Color', _onSurfaceColor, (color) => _onSurfaceColor = color, _handleColorInputChange),
              _buildColorRow('On Error Color', _onErrorColor, (color) => _onErrorColor = color, _handleColorInputChange),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _fontFamily,
                onChanged: _handleFontFamilyChange,
                decoration: const InputDecoration(labelText: 'Font Family'),
                items: _fontFamilies.map((font) {
                  return DropdownMenuItem<String>(
                    value: font,
                    child: Text(font),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isFormValid ? _updateThemeData : null,
                child: const Text('Atualizar'),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildColorRow(String label, Color color, Function(Color) onColorChanged, Function(String, Function(Color)) onInputChange) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                ColorPickerInput(
                  initialColor: color,
                  onColorChanged: (newColor) => _handleColorChange(newColor, onColorChanged),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: TextEditingController(text: _colorToHex(color)),
                    decoration: InputDecoration(labelText: label),
                    keyboardType: TextInputType.text,
                    onChanged: (value) => onInputChange(value, onColorChanged),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 50,
            height: 50,
            color: color,
          ),
        ],
      ),
    );
  }
}
