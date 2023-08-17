import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monii/constants.dart';
import 'package:monii/shared/providers/settings.dart';
import 'package:monii/shared/providers/stats.dart';

class AnimatedMoneyBadge extends ConsumerWidget {
  final String category;
  final double initialMoney;
  const AnimatedMoneyBadge({
    super.key,
    required this.category,
    required this.initialMoney,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var currency = ref.watch(settingsProvider)['currency'];
    Map balances = ref.watch(statsProvider).balances;
    double value =
        balances[category]['income'].toDouble() - balances[category]['expense'].toDouble();

    return Container(
      padding: EdgeInsets.only(right: 10, left: value != 0 ? 0 : 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: value >= 0 ? Colors.green.shade400 : Colors.red.shade300,
      ),
      child: Row(
        children: [
          if (value != 0)
            Icon(
              value > 0 ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
              color: Colors.white,
            ),
          Countup(
            begin: initialMoney,
            end: value,
            duration: const Duration(milliseconds: 800),
            prefix: "${AppConstats.currencySymbols[currency]}",
            separator: ',',
            style: const TextStyle(
              color: Colors.white,
            ),
            curve: Curves.easeInOut,
          ),
        ],
      ),
    );
  }
}
