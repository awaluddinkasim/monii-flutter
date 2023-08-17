import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:monii/constants.dart';
import 'package:monii/module/auth/view/login.dart';
import 'package:monii/module/home/view.dart';
import 'package:monii/shared/providers/auth.dart';
import 'package:monii/shared/providers/settings.dart';
import 'package:page_transition/page_transition.dart';

class LoadingScreen extends ConsumerStatefulWidget {
  const LoadingScreen({super.key});

  @override
  ConsumerState<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends ConsumerState<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    var settings = await AppConstats.storage.read(key: "settings");

    if (settings != null) {
      ref.read(settingsProvider.notifier).loadSettings(jsonDecode(settings));
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.read(authProvider.notifier).getUserData();

    ref.listen(
      authProvider.select((value) => describeEnum(value.status)),
      (prev, next) {
        if (next == "authenticated") {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) {
              return const HomeScreen();
            }),
            (route) => false,
          );
        } else if (next == "unauthenticated") {
          Navigator.of(context).pushAndRemoveUntil(
            PageTransition(
              child: const LoginScreen(),
              type: PageTransitionType.fade,
            ),
            (route) => false,
          );
        }
      },
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Hero(
                tag: "main",
                child: SvgPicture.asset(
                  "assets/images/money.svg",
                  height: 300,
                ),
              ),
            ),
            Text(
              "Monii App",
              style: TextStyle(
                color: Colors.grey.shade800,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
