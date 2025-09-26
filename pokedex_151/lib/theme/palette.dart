import 'package:flutter/material.dart';

const List<Color> kCardPalette = [
  Color(0xFF9BB4D1), 
  Color(0xFFDCC7E1),
  Color(0xFFB5D49A), 
  Color(0xFF7AA5B6), 
  Color(0xFFE7D8B1), 
  Color(0xFFD8857A),
  Color(0xFFF1C04E), 
  Color(0xFFB28CC6),
];

Color cardColorForId(int id) => kCardPalette[id % kCardPalette.length];

String formatId(int id) => '#${id.toString().padLeft(3, '0')}';
dart

