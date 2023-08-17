import 'package:flutter/material.dart';
import 'package:monii/shared/widgets/custom_title.dart';

import 'widgets/currency.dart';
import 'widgets/reset.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: ListView(
          children: const [
            CustomTitle(title: "Pengaturan"),
            Padding(
              padding: EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CurrencySection(),
                  SizedBox(
                    height: 20,
                  ),
                  ResetDataSection(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
