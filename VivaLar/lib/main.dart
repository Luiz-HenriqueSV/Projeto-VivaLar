import 'package:flutter/material.dart';
import 'models/app_state.dart';
import 'models/app_theme.dart';
import 'pages/home_page.dart';

class VivaLarApp extends StatelessWidget {
  const VivaLarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppState(
      builder: (context, state) => MaterialApp(
        title: 'VivaLar',
        debugShowCheckedModeBanner: false,
        themeMode: state.themeMode,
        theme: lightTheme(),
        darkTheme: darkTheme(),
        home: HomePage(appState: state),
      ),
    );
  }
}

void main() {
  runApp(const VivaLarApp());
}
