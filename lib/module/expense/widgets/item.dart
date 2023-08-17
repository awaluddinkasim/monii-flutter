import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:monii/constants.dart';
import 'package:monii/module/expense/widgets/edit.dart';
import 'package:monii/shared/providers/auth.dart';
import 'package:monii/shared/providers/expense.dart';
import 'package:monii/shared/providers/settings.dart';
import 'package:monii/shared/utils/dio.dart';

class ItemWidget extends ConsumerWidget {
  final Map data;
  final DateFormat dateFormat;
  final ScrollController scrollController;
  const ItemWidget({
    super.key,
    required this.data,
    required this.dateFormat,
    required this.scrollController,
  });

  void _delete(BuildContext context, WidgetRef ref) async {
    var token = ref.read(authProvider).token;
    final navigator = Navigator.of(context);

    _loadMore(ref);

    try {
      Response response = await dio(token: token).delete(
        "/expense/delete",
        data: data,
      );

      if (response.statusCode == 200) {
        ref.read(expenseProvider.notifier).removeData(data);
        ref.read(expenseProvider.notifier).setMessage(response.data['message']);
      }
    } on DioException catch (e) {
      ref.read(expenseProvider.notifier).setMessage(e.response!.data['message']);
      ref.read(expenseProvider.notifier).fetchData(token);
    } finally {
      navigator.pop();
    }
  }

  void _loadMore(WidgetRef ref) {
    var token = ref.read(authProvider).token;

    var expenses = ref.read(expenseProvider).expenses;
    var isLastPage = ref.read(expenseProvider.notifier).isLastPage;

    if (expenses.length <= 10 && !isLastPage) {
      ref.read(expenseProvider.notifier).loadMore(token);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var formatter = NumberFormat();
    var currency = ref.watch(settingsProvider)['currency'];

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onLongPress: () {
            showModalBottomSheet(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              context: context,
              builder: (context) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        onTap: () {
                          Navigator.pop(context);
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) {
                              return EditWidget(
                                scrollController: scrollController,
                                dateFormat: dateFormat,
                                data: data,
                              );
                            },
                          );
                        },
                        leading: const Icon(Icons.edit),
                        title: const Text("Edit"),
                      ),
                      ListTile(
                        onTap: () {
                          context.loaderOverlay.show();
                          _delete(context, ref);
                        },
                        leading: const Icon(Icons.delete),
                        title: const Text("Hapus"),
                      ),
                    ],
                  ),
                );
              },
            ).then((_) => context.loaderOverlay.hide());
          },
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "${data['keperluan']}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(dateFormat.format(DateTime.parse(data['tanggal']))),
                    ],
                  ),
                ),
                Text("${AppConstats.currencySymbols[currency]}${formatter.format(data['jumlah'])}"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
