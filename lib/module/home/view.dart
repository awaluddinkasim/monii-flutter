import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monii/constants.dart';
import 'package:monii/module/home/widgets/chart_container.dart';
import 'package:monii/module/home/widgets/animated_money_badge.dart';
import 'package:monii/module/home/widgets/money_badge.dart';
import 'package:monii/shared/providers/auth.dart';
import 'package:monii/shared/providers/settings.dart';
import 'package:monii/shared/providers/stats.dart';
import 'package:monii/shared/widgets/drawer.dart';
import 'package:monii/shared/widgets/header.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Map<String, double> _initialMoney = {
    "money": 0,
    "today": 0,
    "this_month": 0,
  };

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    var token = ref.read(authProvider).token;
    _setInitialMoney();
    ref.read(statsProvider.notifier).fetchData(token);
  }

  void _setInitialMoney() {
    var balances = ref.read(statsProvider).balances;

    double today = balances['today']['income'].toDouble() - balances['today']['expense'].toDouble();
    double thisMonth =
        balances['this_month']['income'].toDouble() - balances['this_month']['expense'].toDouble();

    _initialMoney = {
      "money": double.parse(balances['money'].toString()),
      "today": today,
      "this_month": thisMonth,
    };
  }

  @override
  Widget build(BuildContext context) {
    var currency = ref.watch(settingsProvider)['currency'];
    var balances = ref.watch(statsProvider).balances;

    return Scaffold(
      drawer: const DrawerWidget(
        selectedMenu: "home",
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          children: [
            HeaderWidget(
              contentColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Keuangan saat ini",
                      style: TextStyle(
                        color: Colors.grey.shade400,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Countup(
                      begin: _initialMoney["money"]!,
                      end: double.parse(balances['money'].toString()),
                      duration: const Duration(milliseconds: 500),
                      prefix: "${AppConstats.currencySymbols[currency]}",
                      separator: ',',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                      curve: Curves.easeInOut,
                    ),
                  ],
                ),
              ),
            ),
            const ChartContainer(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Divider(),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Hari ini",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AnimatedMoneyBadge(
                        category: "today",
                        initialMoney: _initialMoney['today']!,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Bulan ini",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AnimatedMoneyBadge(
                        category: "this_month",
                        initialMoney: _initialMoney['this_month']!,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            title: const Text("Rincian Keuangan"),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            insetPadding: const EdgeInsets.all(15),
                            content: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    "Hari ini",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text("Pemasukan"),
                                            MoneyBadge(
                                              jenis: "income",
                                              nominal: balances['today']['income'].toDouble(),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text("Pengeluaran"),
                                            MoneyBadge(
                                              jenis: "expense",
                                              nominal: balances['today']['expense'].toDouble(),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 25),
                                  const Text(
                                    "Bulan ini",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text("Pemasukan"),
                                            MoneyBadge(
                                              jenis: "income",
                                              nominal: balances['this_month']['income'].toDouble(),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text("Pengeluaran"),
                                            MoneyBadge(
                                              jenis: "expense",
                                              nominal: balances['this_month']['expense'].toDouble(),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Tutup"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(
                        Colors.grey.shade200,
                      ),
                      foregroundColor: const MaterialStatePropertyAll(
                        Colors.black,
                      ),
                    ),
                    child: const Text("Lihat Rincian"),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
