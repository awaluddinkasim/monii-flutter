import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monii/constants.dart';
import 'package:monii/shared/providers/settings.dart';

class CurrencySection extends ConsumerWidget {
  const CurrencySection({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var settings = ref.watch(settingsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Mata Uang",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        Row(
          children: [
            const Expanded(
              child: Text(
                "Simbol",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            DropdownButton(
              value: settings['currency'],
              borderRadius: BorderRadius.circular(10),
              isDense: true,
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              items: AppConstats.currencySymbols.keys.map(
                (String currency) {
                  return DropdownMenuItem(
                    value: currency,
                    child: Text(currency),
                  );
                },
              ).toList(),
              onChanged: (value) {
                ref.read(settingsProvider.notifier).setCurrency("$value");
              },
            ),
          ],
        ),
      ],
    );
  }
}
