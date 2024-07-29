import 'dart:ui';
import 'package:core_dashboard/dtos/screens.dart';


class AppData {
  final String consumerId;
  final Data data;
  final ThemeModel theme;
  final Map<String, Screen> screens;
  final Map<String, String> images;

  AppData({
    required this.consumerId,
    required this.data,
    required this.theme,
    required this.screens,
    required this.images,
  });

  factory AppData.fromJson(Map<String, dynamic> json) {
    return AppData(
      consumerId: json['id'],
      data: Data.fromJson(json['data']),
      theme: ThemeModel.fromJson(json['theme']),
      screens: Screens.fromJson(json["screens"]).screens,
      images: Map<String, String>.from(json['images']),
    );
  }
}

class Data {
  final String appName;
  final String description;
  final String nifName;
  final String logo;
  final String extraLogo;
  final String version;

  Data({
    required this.appName,
    required this.description,
    required this.nifName,
    required this.logo,
    required this.extraLogo,
    required this.version,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      appName: json['app_name'],
      description: json['description'],
      nifName: json['nif_name'],
      logo: json['logo'],
      extraLogo: json['extra_logo'],
      version: json['version'],
    );
  }
}

class ThemeModel {
  final Map<String, Color> colors;
  final String? fontFamily;

  ThemeModel({required this.colors, this.fontFamily});

  factory ThemeModel.fromJson(Map<String, dynamic> json) {
    Map<String, Color> parsedColors = {};
    json['colors'].forEach((key, value) {
      parsedColors[key] =
          Color(int.parse(value.replaceFirst('0x', ''), radix: 16))
              .withOpacity(1.0);
    });

    return ThemeModel(
      colors: parsedColors,
      fontFamily: json['font_family'],
    );
  }
}
