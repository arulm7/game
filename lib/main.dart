import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/game_state.dart';
import 'screens/garden/garden_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set immersive dark UI overlay for game feel
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppTheme.gardenDarkBg,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const SavioursVsSaboteursApp());
}

class SavioursVsSaboteursApp extends StatefulWidget {
  const SavioursVsSaboteursApp({super.key});

  @override
  State<SavioursVsSaboteursApp> createState() => _SavioursVsSaboteursAppState();
}

class _SavioursVsSaboteursAppState extends State<SavioursVsSaboteursApp> {
  late final GameState _gameState;

  @override
  void initState() {
    super.initState();
    _gameState = GameState();
  }

  @override
  void dispose() {
    _gameState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saviours vs Saboteurs',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      home: GardenScreen(gameState: _gameState),
    );
  }
}
