import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monii/shared/utils/dio.dart';

enum Chart { daily, monthly }

class Stats {
  Map balances;
  Map dailyStats;
  Map monthlyStats;

  Stats({
    required this.balances,
    required this.dailyStats,
    required this.monthlyStats,
  });
}

class StatsNotifier extends StateNotifier<Stats> {
  StatsNotifier()
      : super(
          Stats(
            balances: {
              "money": 0,
              "today": {
                "income": 0,
                "expense": 0,
              },
              "this_month": {
                "income": 0,
                "expense": 0,
              },
            },
            dailyStats: {
              "incomes": [],
              "expenses": [],
            },
            monthlyStats: {
              "incomes": [],
              "expenses": [],
            },
          ),
        );

  String errorMessage = "";

  Future<void> fetchData(token) async {
    errorMessage = "";
    try {
      Response response = await dio(token: token).get('/user/stats');
      if (response.statusCode == 200) {
        var data = response.data;

        state = Stats(
          balances: data['balances'],
          dailyStats: data['daily_stats'],
          monthlyStats: data['monthly_stats'],
        );
      }
    } on DioException catch (e) {
      errorMessage = e.response!.data['message'];
    }
  }

  void resetState() {
    errorMessage = "";

    state = Stats(
      balances: {
        "money": 0,
        "today": 0,
        "this_month": 0,
      },
      dailyStats: {
        "incomes": [],
        "expenses": [],
      },
      monthlyStats: {
        "incomes": [],
        "expenses": [],
      },
    );
  }
}

final statsProvider = StateNotifierProvider<StatsNotifier, Stats>(
  (ref) => StatsNotifier(),
);

final chartProvider = StateProvider<Chart>(
  (ref) => Chart.daily,
);
