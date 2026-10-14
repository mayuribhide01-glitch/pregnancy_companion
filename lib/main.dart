import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'core/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Same behaviour on every Android version (Android 15+ forces this anyway),
  // so MediaQuery always reports the real status-bar height.
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(appSystemUiStyle);
  runApp(const PregnancyCompanionApp());
}
