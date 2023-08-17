import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:monii/module/expense/widgets/form.dart';
import 'package:monii/module/expense/widgets/item.dart';
import 'package:monii/shared/providers/auth.dart';
import 'package:monii/shared/providers/expense.dart';
import 'package:monii/shared/utils/snackbar.dart';
import 'package:monii/shared/widgets/drawer.dart';
import 'package:monii/shared/widgets/header.dart';
import 'package:monii/shared/widgets/loader.dart';

class ExpenseScreen extends ConsumerStatefulWidget {
  const ExpenseScreen({super.key});

  @override
  ConsumerState<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends ConsumerState<ExpenseScreen> {
  final ScrollController _scrollController = ScrollController();
  DateFormat _dateFormat = DateFormat();

  @override
  void initState() {
    super.initState();
    _fetching();
    initializeDateFormatting();
    _dateFormat = DateFormat.yMMMMEEEEd("id");
  }

  void _fetching({bool reload = false}) {
    var token = ref.read(authProvider).token;

    if (ref.read(expenseProvider).expenses.isEmpty || reload) {
      ref.read(expenseProvider.notifier).fetchData(token);
    }
  }

  void _onScroll(dataCount) {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (maxScroll == currentScroll && dataCount >= 10) {
      var token = ref.read(authProvider).token;

      ref.read(expenseProvider.notifier).loadMore(token);
    }
  }

  Future<void> _refresh() async {
    _fetching(reload: true);
  }

  @override
  Widget build(BuildContext context) {
    var expenseState = ref.watch(expenseProvider.notifier);
    var expenses = ref.watch(expenseProvider).expenses;

    ref.listen(expenseProvider.select((value) => value.message), (_, message) {
      if (message != "") {
        showSnackBar(context, message);
      }
    });

    return Scaffold(
      drawer: const DrawerWidget(selectedMenu: "expense"),
      body: SafeArea(
        top: false,
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollUpdateNotification) {
              if (!expenseState.isLastPage) {
                _onScroll(expenses.length);
              }
            }
            return false;
          },
          child: RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const HeaderWidget(
                  contentColor: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 5,
                    ),
                    child: Text(
                      "Pengeluaran",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FilledButton.icon(
                        icon: const Icon(Icons.add_chart_rounded),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) {
                              return FormWidget(
                                dateFormat: _dateFormat,
                              );
                            },
                          ).then((_) => context.loaderOverlay.hide());
                        },
                        label: const Text("INPUT PENGELUARAN"),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 25,
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: expenseState.isLoading
                      ? const LoaderWidget()
                      : expensesList(expenses, expenseState.isLastPage),
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget expensesList(expenses, isLastPage) {
    return expenses.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var expense in expenses)
                ItemWidget(
                  data: expense,
                  scrollController: _scrollController,
                  dateFormat: _dateFormat,
                ),
              const SizedBox(
                height: 10,
              ),
              if (!isLastPage) const LoaderWidget(),
            ],
          )
        : const Text(
            "Tidak ada data",
            textAlign: TextAlign.center,
          );
  }
}
