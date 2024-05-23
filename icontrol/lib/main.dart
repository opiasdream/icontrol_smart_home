import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:icontrol/common/constants/strings.dart';
import 'package:icontrol/services/mqtt_service.dart';

import 'package:icontrol/ui/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await IMQTTService.instance.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      themeMode: ThemeMode.light,
      theme: FlexThemeData.light(scheme: FlexScheme.tealM3),
      home: const HomeScreen(),
    );
  }
}
