import 'package:flutter/material.dart';

abstract class TextStyles {
  static get appName => const TextStyle(fontFamily: 'Yellowtail', fontSize: 42);

  static get h1 => const TextStyle(fontSize: 42, fontWeight: FontWeight.w700);

  static get h2 => const TextStyle(fontSize: 18, fontWeight: FontWeight.w600);

  static get h3 => const TextStyle(fontSize: 16, fontWeight: FontWeight.w500);

  static get info => const TextStyle(fontSize: 14, fontStyle: FontStyle.italic);
}
