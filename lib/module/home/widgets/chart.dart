import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:monii/shared/providers/stats.dart';
import 'package:skeletons/skeletons.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartWidget extends ConsumerStatefulWidget {
  const ChartWidget({super.key});

  @override
  ConsumerState<ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends ConsumerState<ChartWidget> {
  DateFormat _dateFormat = DateFormat();

  String _chartTitle = "";
  List _incomes = [];
  List _expenses = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    initializeDateFormatting();
    _dateFormat = DateFormat.MMMM("id");
  }

  void _updateDaily(stats) {
    setState(() {
      _chartTitle = "Bulan ${_dateFormat.format(DateTime.now())}";
      _incomes = stats['incomes']
          .map(
            (e) => StatData(
              e['tanggal'].toString(),
              e['nominal'],
            ),
          )
          .toList();

      _expenses = stats['expenses']
          .map(
            (e) => StatData(
              e['tanggal'].toString(),
              e['nominal'],
            ),
          )
          .toList();
    });
  }

  void _updateMonthly(stats) {
    _chartTitle = "Tahun ${DateTime.now().year}";
    setState(() {
      _incomes = stats['incomes']
          .map(
            (e) => StatData(
              e['bulan'].toString(),
              e['nominal'],
            ),
          )
          .toList();

      _expenses = stats['expenses']
          .map(
            (e) => StatData(
              e['bulan'].toString(),
              e['nominal'],
            ),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    Chart currentChart = ref.watch(chartProvider);
    var stats = ref.watch(statsProvider);

    ref.listen(
      statsProvider.select(
        (value) => currentChart == Chart.daily ? value.dailyStats : value.monthlyStats,
      ),
      (data, newData) {
        if (currentChart == Chart.daily) {
          _updateDaily(newData);
        } else {
          _updateMonthly(newData);
        }
        setState(() {
          _isLoading = false;
        });
      },
    );

    ref.listen(chartProvider, (prev, next) {
      if (next == Chart.daily) {
        _updateDaily(stats.dailyStats);
      } else {
        _updateMonthly(stats.monthlyStats);
      }
      setState(() {
        _isLoading = false;
      });
    });

    if (_isLoading) {
      return const SkeletonAvatar(
        style: SkeletonAvatarStyle(
          width: double.infinity,
          height: 350,
        ),
      );
    }

    return SizedBox(
      height: 350,
      child: SfCartesianChart(
        title: ChartTitle(
          text: _chartTitle,
          textStyle: const TextStyle(
            fontSize: 13,
          ),
        ),
        legend: const Legend(isVisible: true, position: LegendPosition.bottom),
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(
          numberFormat: NumberFormat(),
        ),
        series: [
          SplineSeries(
            name: "Pengeluaran",
            splineType: SplineType.monotonic,
            legendIconType: LegendIconType.horizontalLine,
            animationDuration: 0,
            dataSource: _expenses,
            xValueMapper: (stat, _) => stat.waktu,
            yValueMapper: (stat, _) => stat.nominal,
            color: Colors.red.shade300,
          ),
          SplineSeries(
            name: "Pemasukan",
            splineType: SplineType.monotonic,
            legendIconType: LegendIconType.horizontalLine,
            animationDuration: 0,
            dataSource: _incomes,
            xValueMapper: (stat, _) => stat.waktu,
            yValueMapper: (stat, _) => stat.nominal,
            color: Colors.green.shade400,
          ),
        ],
      ),
    );
  }
}

class StatData {
  StatData(this.waktu, this.nominal);
  final String waktu;
  final int nominal;
}
