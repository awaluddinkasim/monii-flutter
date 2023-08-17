import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:monii/constants.dart';
import 'package:monii/shared/providers/settings.dart';

class MoneyBadge extends ConsumerWidget {
  final String jenis;
  final double nominal;
  const MoneyBadge({
    super.key,
    required this.jenis,
    required this.nominal,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var currency = ref.watch(settingsProvider)['currency'];
    var formatter = NumberFormat();

    return Container(
      padding: EdgeInsets.only(right: 10, left: nominal != 0 ? 0 : 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: nominal > 0
            ? (jenis == "income" ? Colors.green.shade400 : Colors.red.shade300)
            : Colors.green.shade400,
      ),
      child: Row(
        children: [
          if (nominal != 0)
            const Icon(
              Icons.arrow_drop_up_rounded,
              color: Colors.white,
            ),
          Text(
            "${AppConstats.currencySymbols[currency]}${formatter.format(nominal)}",
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
