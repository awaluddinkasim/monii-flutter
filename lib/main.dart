import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:monii/loading.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const ProviderScope(child: MyApp()));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color themeColor = Colors.deepPurple;

    return GlobalLoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: const Center(
        child: CircularProgressIndicator(color: themeColor),
      ),
      child: MaterialApp(
        title: 'Monii',
        theme: ThemeData(
          fontFamily: 'Ubuntu',
          colorScheme: ColorScheme.fromSeed(seedColor: themeColor),
          useMaterial3: true,
        ),
        home: const LoadingScreen(),
      ),
    );
  }
}
