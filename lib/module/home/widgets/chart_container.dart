import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monii/module/home/widgets/chart.dart';
import 'package:monii/shared/providers/stats.dart';

class ChartContainer extends ConsumerStatefulWidget {
  const ChartContainer({
    super.key,
  });

  @override
  ConsumerState<ChartContainer> createState() => _ChartContainerState();
}

class _ChartContainerState extends ConsumerState<ChartContainer> {
  @override
  Widget build(BuildContext context) {
    Chart currentChart = ref.watch(chartProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Grafik",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SegmentedButton(
                style: const ButtonStyle(
                  visualDensity: VisualDensity.compact,
                ),
                segments: const [
                  ButtonSegment(
                    value: Chart.daily,
                    label: Text(
                      "Harian",
                    ),
                  ),
                  ButtonSegment(
                    value: Chart.monthly,
                    label: Text(
                      "Bulanan",
                    ),
                  ),
                ],
                selected: {currentChart},
                onSelectionChanged: (value) {
                  ref.read(chartProvider.notifier).state = value.first;
                },
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: ChartWidget(),
          ),
        ],
      ),
    );
  }
}
