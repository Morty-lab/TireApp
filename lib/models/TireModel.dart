import 'dart:ffi';

import 'package:flutter/material.dart';

class TireModel {
  TireModel(
      {required this.rimDiameter,
      required this.tireSize,
      required this.loadIndex,
      required this.threadPattern,
      required this.unitPrice,
      required this.isNew});

  final int? rimDiameter;
  final String? tireSize;
  final String? loadIndex;
  final String? threadPattern;
  final double? unitPrice;
  final bool? isNew;

  dynamic getAttribute(String attributeName) {
    switch (attributeName) {
      case 'tireSize':
        return tireSize;
      case 'loadIndex':
        return loadIndex;
      case 'rimDiameter':
        return rimDiameter;
      case 'threadPattern':
        return threadPattern;
      // Add more cases as needed for other attributes
      default:
        throw ArgumentError('Unknown attribute: $attributeName');
    }
  }

  factory TireModel.fromMap(Map<String, dynamic> json) {
    return TireModel(
        rimDiameter: json['RimDiameter']?.toInt(),
        tireSize: json['TireSize'],
        loadIndex: json['LoadIndexSpeedSymbol'],
        threadPattern: json['TreadPattern'],
        unitPrice: json['UnitPriceWVAT']?.toDouble(),
        isNew: json['IsNew']);
  }
}
