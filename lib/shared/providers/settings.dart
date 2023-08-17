import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monii/constants.dart';

class SettingsNotifier extends StateNotifier<Map> {
  SettingsNotifier() : super({"currency": "IDR"});

  void loadSettings(Map settings) {
    state = settings;
  }

  void setCurrency(String currency) async {
    state = {"currency": currency};

    await AppConstats.storage.write(
      key: "settings",
      value: jsonEncode(
        {"currency": currency},
      ),
    );
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, Map>(
  (ref) => SettingsNotifier(),
);
