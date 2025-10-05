import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web3_wallet/core/config/dotenv_config.dart';
import 'package:web3_wallet/core/injection/service_locator.dart';
import 'package:web3_wallet/core/theme/app_theme.dart';
import 'package:web3_wallet/presentation/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  final config = DotenvConfig();
  await initializeDependencies(config);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Web3 Wallet',
      theme: AppTheme.darkTheme,
      home: const DashboardScreen(),
    );
  }
}
